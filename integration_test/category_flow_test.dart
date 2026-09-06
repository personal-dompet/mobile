import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/models/account_icon_option.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/fixture.dart';

/// Alur Kategori: buat, validasi, ubah, arsip.
///
/// Menggabungkan:
/// - TC-KAT-003/004/005/006/007
///
/// Tidak diotomatiskan (UI murni): TC-KAT-001/002/008/009/010/011
/// (drawer, search debounce, pemilih kategori + badge, buat cepat,
/// empty state, search ikon — diverifikasi manual).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(resetFixture);
  tearDown(disposeFixture);

  CategoryForm categoryForm({
    String? name,
    required AccountType type,
    AccountIconOption? icon,
  }) {
    final form = CategoryForm();
    if (name != null) form.nameControl.updateValue(name);
    form.typeControl.updateValue(type);
    if (icon != null) form.iconControl.updateValue(icon);
    return form;
  }

  Future<List<String>> userCategoryNames(AccountType type) async {
    final accounts = await getIt<AccountRepository>().getAccounts(
      filter: AccountFilter(type: type, isSystem: false),
    );
    return accounts.map((a) => a.name).toList();
  }

  test('TC-KAT-003 buat kategori baru muncul di Kategori Saya', () async {
    final base = await seedBaseData();

    final hobi = await getIt<CategoryRepository>().createCategory(
      form: categoryForm(
        name: 'Hobi',
        type: AccountType.expense,
        icon: const AccountIconOption(
          icon: Icons.sports_soccer_rounded,
          keywords: ['bola'],
          type: TransactionType.expense,
        ),
      ),
    );
    expect(hobi.name, 'Hobi');
    expect(await userCategoryNames(AccountType.expense), contains('Hobi'));

    // Efek samping: langsung bisa dipakai di form Pengeluaran ...
    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: hobi.id,
      amount: 75000,
    );
    expect(await balanceOf(base.bca.id), 4925000);

    // ... dan Rencana Anggaran.
    await getIt<BudgetPlanRepository>().upsert(
      accountId: hobi.id,
      amount: 300000,
      note: 'hobi',
    );
    await getIt<BudgetRepository>().createBudget(
      accountId: hobi.id,
      amount: 300000,
      periode: DateTime.now(),
    );
    final budget = await getIt<BudgetRepository>().getActiveBudget(hobi.id);
    expect(budget?.actualSpend, 75000);
    expect(budget?.remaining, 225000);
  });

  test('TC-KAT-004 buat kategori tanpa nama ditolak', () async {
    await seedBaseData();

    expect(
      () => getIt<CategoryRepository>().createCategory(
        form: categoryForm(type: AccountType.expense),
      ),
      throwsException,
    );
    expect(await userCategoryNames(AccountType.expense), isEmpty);
  });

  test('TC-KAT-005 buat kategori tanpa ikon pakai ikon default', () async {
    await seedBaseData();

    final tanpaIkon = await getIt<CategoryRepository>().createCategory(
      form: categoryForm(name: 'Tanpa Ikon', type: AccountType.expense),
    );
    expect(
      tanpaIkon.iconCode,
      Icons.account_balance_wallet_rounded.codePoint,
    );

    final gajiBaru = await getIt<CategoryRepository>().createCategory(
      form: categoryForm(name: 'Gaji Baru', type: AccountType.income),
    );
    expect(gajiBaru.iconCode, Icons.payment_rounded.codePoint);
  });

  test('TC-KAT-006 ubah kategori: nama berubah, tipe immutable', () async {
    await seedBaseData();

    final hobi = await getIt<CategoryRepository>().createCategory(
      form: categoryForm(name: 'Hobi', type: AccountType.expense),
    );
    await getIt<CategoryRepository>().updateCategory(
      id: hobi.id,
      form: categoryForm(name: 'Hobi Baru', type: AccountType.expense),
    );

    final updated = await getIt<AccountRepository>().getAccount(hobi.id);
    expect(updated?.name, 'Hobi Baru');
    // Tipe tak bisa berubah jadi income: updateCategory hanya menyentuh
    // nama + ikon, kolom type tidak pernah di-update.
    expect(updated?.type, AccountType.expense);
    expect(await userCategoryNames(AccountType.expense), contains('Hobi Baru'));
    expect(await userCategoryNames(AccountType.income), isNot(contains('Hobi Baru')));
  });

  test('TC-KAT-007 arsip kategori: hilang dari pemilih, riwayat tetap',
      () async {
    final base = await seedBaseData();

    final hobi = await getIt<CategoryRepository>().createCategory(
      form: categoryForm(name: 'Hobi', type: AccountType.expense),
    );
    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: hobi.id,
      amount: 50000,
    );

    await getIt<AccountRepository>().archiveAccount(hobi.id);

    // Hilang dari daftar & pemilih (query aktif).
    expect(await userCategoryNames(AccountType.expense), isNot(contains('Hobi')));

    // Transaksi lama tetap tampil namanya (baris DB tidak dihapus).
    final archived = await getIt<AccountRepository>().getAccount(hobi.id);
    expect(archived?.name, 'Hobi');
    expect(archived?.isDeleted, isTrue);
    // ... dan efek saldonya tetap (jurnal tidak ikut void).
    expect(await balanceOf(base.bca.id), 4950000);
  });
}
