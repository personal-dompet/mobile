import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:dompet_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/forms/balance_adjustment_form.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:dompet_app/features/transactions/repositories/transaction_repository.dart';
import 'package:dompet_app/core/network/connectivity_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/app_configurations/cubits/app_configuration_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Pump berbatas: pumpAndSettle() hang di device fisik bila ada animasi
/// berulang (chart/spinner), jadi pakai pump manual beberapa ronde.
/// Default 5 ronde (≈1,5 dtk waktu fake) cukup untuk transisi route +
/// load cubit; jangan dibesarkan tanpa perlu (pump di device lambat).
Future<void> settle(WidgetTester tester, [int rounds = 5]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.pump(const Duration(milliseconds: 300));
  }
  await tester.pump();
}

/// Pump hingga [finder] menemukan widget (atau [maxRounds] habis).
/// Jauh lebih cepat daripada ronde tetap: berhenti segera setelah
/// navigasi/load async selesai, baik di host maupun device lambat.
Future<void> settleUntil(
  WidgetTester tester,
  Finder finder, [
  int maxRounds = 40,
]) async {
  for (var i = 0; i < maxRounds; i++) {
    await tester.pump(const Duration(milliseconds: 300));
    if (finder.evaluate().isNotEmpty) {
      await tester.pump();
      return;
    }
  }
  await tester.pump();
}

/// Pump hingga [finder] TIDAK menemukan widget lagi (atau [maxRounds] habis).
Future<void> settleGone(
  WidgetTester tester,
  Finder finder, [
  int maxRounds = 40,
]) async {
  for (var i = 0; i < maxRounds; i++) {
    await tester.pump(const Duration(milliseconds: 300));
    if (finder.evaluate().isEmpty) {
      await tester.pump();
      return;
    }
  }
  await tester.pump();
}

/// Pump satu halaman dengan provider level aplikasi yang sama seperti
/// MyApp (signal cubit dsb.) — tanpanya halaman detail melempar
/// ProviderNotFoundException saat build.
Future<void> pumpPage(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ConnectivityCubit>()..init()),
        BlocProvider(create: (_) => getIt<ActivitySignalCubit>()),
        BlocProvider(create: (_) => getIt<AccountSignalCubit>()),
        BlocProvider(create: (_) => getIt<AppConfigurationCubit>()),
        BlocProvider(create: (_) => getIt<BudgetSignalCubit>()),
        BlocProvider(create: (_) => getIt<SavingSignalCubit>()),
      ],
      child: MaterialApp(home: page),
    ),
  );
  await settle(tester, 6);
}

/// Data dasar sesuai "Setup awal" TEST_CASE.md §2-11:
/// Tunai Rp1.000.000, BCA Rp5.000.000, kategori Makan/Transport/Gaji
/// (pakai seed sistem), target Dana Darurat Rp10.000.000,
/// rencana+anggaran aktif Makan Rp1.000.000.
class BaseData {
  BaseData({
    required this.tunai,
    required this.bca,
    required this.makanId,
    required this.transportId,
    required this.gajiId,
    required this.target,
  });

  final Account tunai;
  final Account bca;
  final int makanId;
  final int transportId;
  final int gajiId;
  final SavingPlan target;
}

/// Inisialisasi ulang DI dengan in-memory DB.
/// Harus dipanggil di setUp setiap test (mirip setupTestApp tanpa UI).
Future<void> resetFixture() async {
  await getIt.reset();
  await initDependency(dbTestPath: inMemoryDatabasePath);
}

/// Tutup DB lalu reset DI (dipanggil di tearDown).
Future<void> disposeFixture() async {
  if (getIt.isRegistered<DbService>()) {
    try {
      await getIt<DbService>().close();
    } catch (_) {}
  }
  await getIt.reset();
}

Future<Account> createWallet({
  required String name,
  required AccountPreset preset,
  int? balance,
}) async {
  final form = AssetForm()
    ..nameControl.updateValue(name)
    ..codeControl.updateValue(preset.code);
  if (balance != null) form.balanceControl.updateValue(balance);
  return getIt<AssetRepository>().createAsset(form);
}

Future<Account> createCategoryAccount({
  required String name,
  AccountType type = AccountType.expense,
}) async {
  final form = CategoryForm();
  form.nameControl.updateValue(name);
  form.typeControl.updateValue(type);
  return getIt<CategoryRepository>().createCategory(form: form);
}

Future<int> systemAccountId(String code) async {
  final db = await getIt<DbService>().database;
  final rows = await db.query(
    accountTable,
    columns: [AccountKey.id],
    where: '${AccountKey.code} = ?',
    whereArgs: [code],
    limit: 1,
  );
  return rows.first[AccountKey.id] as int;
}

Future<BaseData> seedBaseData() async {
  final tunai = await createWallet(
    name: 'Tunai',
    preset: AccountPreset.cash,
    balance: 1000000,
  );
  final bca = await createWallet(
    name: 'BCA',
    preset: AccountPreset.bank,
    balance: 5000000,
  );

  final makanId = await systemAccountId(AccountPreset.food.code);
  final transportId = await systemAccountId(AccountPreset.transport.code);
  final gajiId = await systemAccountId(AccountPreset.salary.code);

  final target = await getIt<SavingRepository>().createPocket(
    name: 'Dana Darurat',
    targetAmount: 10000000,
  );

  await getIt<BudgetPlanRepository>().upsert(
    accountId: makanId,
    amount: 1000000,
    note: 'base',
  );
  await getIt<BudgetRepository>().createBudget(
    accountId: makanId,
    amount: 1000000,
    periode: DateTime.now(),
  );

  return BaseData(
    tunai: tunai,
    bca: bca,
    makanId: makanId,
    transportId: transportId,
    gajiId: gajiId,
    target: target,
  );
}

/// Total Uang = jumlah saldo dompet cair aktif (TC-DSH-002).
Future<int> totalUang() =>
    getIt<DashboardRepository>().getTotalLiquidBalance();

Future<int> balanceOf(int accountId) async {
  final account = await getIt<AccountRepository>().getAccount(accountId);
  return account?.balance ?? 0;
}

TransactionForm singleCategoryForm({
  required int assetId,
  required String assetName,
  required int assetBalance,
  int? categoryId,
  String? categoryName,
  required int amount,
  String? note,
  DateTime? date,
}) {
  final form = TransactionForm();
  form.assetForm.idControl.updateValue(assetId);
  form.assetForm.nameControl.updateValue(assetName);
  form.assetForm.balanceControl.updateValue(assetBalance);
  final category = form.categories.first;
  if (categoryId != null) {
    category.categoryIdControl.updateValue(categoryId);
  }
  if (categoryName != null) {
    category.categoryNameControl.updateValue(categoryName);
  }
  category.amountControl.updateValue(amount);
  if (note != null) {
    category.noteControl.updateValue(note);
    form.noteControl.updateValue(note);
  }
  if (date != null) form.dateControl.updateValue(date);
  form.totalAmountControl.updateValue(amount);
  return form;
}

TransferForm transferForm({
  required int sourceId,
  required String sourceName,
  required int sourceBalance,
  required int destinationId,
  required String destinationName,
  required int destinationBalance,
  required int amount,
  String? note,
}) {
  final form = TransferForm();
  form.sourceForm.idControl.updateValue(sourceId);
  form.sourceForm.nameControl.updateValue(sourceName);
  form.sourceForm.balanceControl.updateValue(sourceBalance);
  form.destinationForm.idControl.updateValue(destinationId);
  form.destinationForm.nameControl.updateValue(destinationName);
  form.destinationForm.balanceControl.updateValue(destinationBalance);
  form.amountControl.updateValue(amount);
  if (note != null) form.noteControl.updateValue(note);
  return form;
}

BalanceAdjustmentForm adjustmentForm({
  required Account account,
  required int actualBalance,
}) {
  final form = BalanceAdjustmentForm();
  form.accountControl.updateValue(account);
  form.amountControl.updateValue(actualBalance);
  return form;
}

/// Id jurnal posted terbaru (untuk dihapus/void pada uji hapus).
Future<int> lastPostedJournalId() async {
  final db = await getIt<DbService>().database;
  final rows = await db.rawQuery(
    'SELECT ${JournalEntryKey.id} AS id FROM $journalEntryTable '
    'WHERE ${JournalEntryKey.status} = ? '
    'ORDER BY ${JournalEntryKey.id} DESC LIMIT 1',
    [JournalStatus.posted.name],
  );
  return rows.first['id'] as int;
}

Future<void> voidJournal(int id) =>
    getIt<JournalRepository>().deleteJournal(id);

Future<void> recordIncome({
  required int assetId,
  required String assetName,
  required int assetBalance,
  int? categoryId,
  required int amount,
  String? note,
}) async {
  await getIt<TransactionRepository>().recordTransaction(
    form: singleCategoryForm(
      assetId: assetId,
      assetName: assetName,
      assetBalance: assetBalance,
      categoryId: categoryId,
      amount: amount,
      note: note,
    ),
    type: TransactionType.income,
  );
}

Future<void> recordExpense({
  required int assetId,
  required String assetName,
  required int assetBalance,
  int? categoryId,
  required int amount,
  String? note,
}) async {
  await getIt<TransactionRepository>().recordTransaction(
    form: singleCategoryForm(
      assetId: assetId,
      assetName: assetName,
      assetBalance: assetBalance,
      categoryId: categoryId,
      amount: amount,
      note: note,
    ),
    type: TransactionType.expense,
  );
}
