import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/activities/enums/activity_type.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/exceptions/no_op_balance_adjustment_exception.dart';
import 'package:dompet_app/features/transactions/forms/balance_adjustment_form.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:dompet_app/features/transactions/repositories/transaction_repository.dart';
import 'package:dompet_app/features/transactions/repositories/transfer_repository.dart';
import 'package:dompet_app/features/transactions/repositories/balance_adjustment_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/fixture.dart';

/// Alur transaksi: pemasukan, pengeluaran, pindah dana, penyesuaian.
///
/// Menggabungkan:
/// - TC-IN-001/002/003/005/006/009/010/011
/// - TC-OUT-001/002/005/007/008/010 (+ TC-BGT-010 sisa anggaran)
/// - TC-TRF-001/004/007/008
/// - TC-ADJ-001/002/004/007
/// - TC-ACT-009 (hapus = void, saldo/anggaran/laporan terkoreksi)
///
/// Tidak diotomatiskan (validasi/widget UI murni):
/// - TC-IN-004/007/008/012, TC-OUT-003/004/006/009/011,
///   TC-TRF-002/003/005/006, TC-ADJ-003/005/006
///   (toggle batch, date-picker future-block, dialog overdraw,
///   pemilih dompet/kategori arsip — diverifikasi manual).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(resetFixture);
  tearDown(disposeFixture);

  test('TC-IN flow catat, batch, edit, pindah dompet, hapus', () async {
    final base = await seedBaseData();

    // TC-IN-001: pemasukan single kategori.
    await recordIncome(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: base.gajiId,
      amount: 500000,
      note: 'Gaji Jan',
    );
    final incomeId = await lastPostedJournalId();
    expect(await balanceOf(base.bca.id), 5500000);
    expect(await totalUang(), 6500000);

    // TC-IN-002: tanpa kategori (opsional) — masuk akun Lainnya.
    await recordIncome(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5500000,
      amount: 100000,
    );
    expect(await balanceOf(base.bca.id), 5600000);

    // TC-IN-003: multi kategori satu jurnal (total auto-sum 500rb).
    final bonusId = await systemAccountId(AccountPreset.bonus.code);
    final batch = TransactionForm();
    batch.assetForm.idControl.updateValue(base.bca.id);
    batch.assetForm.nameControl.updateValue('BCA');
    batch.assetForm.balanceControl.updateValue(5600000);
    batch.categories.first.categoryIdControl.updateValue(base.gajiId);
    batch.categories.first.amountControl.updateValue(400000);
    batch.addCategory();
    batch.categories[1].categoryIdControl.updateValue(bonusId);
    batch.categories[1].amountControl.updateValue(100000);
    batch.totalAmountControl.updateValue(500000);
    await getIt<TransactionRepository>().recordTransaction(
      form: batch,
      type: TransactionType.income,
    );
    expect(await balanceOf(base.bca.id), 6100000);
    expect(await totalUang(), 7100000);

    // Batch tercatat sebagai 1 jurnal: 3 pemasukan = 3 jurnal.
    final summary = await getIt<ReportRepository>().getMonthlySummary(
      ReportPeriod.currentMonth(),
    );
    expect(summary.income, 1100000);
    expect(summary.expense, 0);
    expect(summary.transactionCount, 3);

    // TC-IN-009: edit nominal di dompet sama (efek lama dibalik dulu).
    final editSame = singleCategoryForm(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 6100000,
      categoryId: base.gajiId,
      amount: 700000,
      note: 'Gaji Jan',
    );
    final editedId = await getIt<TransactionRepository>().updateTransaction(
      id: incomeId,
      form: editSame,
      type: TransactionType.income,
    );
    expect(await balanceOf(base.bca.id), 6300000);

    // TC-IN-010: edit pindah dompet — BCA kembali, Tunai bertambah.
    final moveToTunai = singleCategoryForm(
      assetId: base.tunai.id,
      assetName: 'Tunai',
      assetBalance: 1000000,
      categoryId: base.gajiId,
      amount: 700000,
      note: 'Gaji Jan',
    );
    final movedId = await getIt<TransactionRepository>().updateTransaction(
      id: editedId,
      form: moveToTunai,
      type: TransactionType.income,
    );
    expect(await balanceOf(base.bca.id), 5600000);
    expect(await balanceOf(base.tunai.id), 1700000);
    expect(await totalUang(), 7300000);

    // TC-IN-011 + TC-ACT-009: hapus mengembalikan saldo (void).
    await voidJournal(movedId);
    expect(await balanceOf(base.tunai.id), 1000000);
    expect(await totalUang(), 6600000);
  });

  test('TC-IN-005/006 nominal & dompet wajib diisi', () async {
    final base = await seedBaseData();

    // Tanpa nominal (kategori amount null).
    final noAmount = TransactionForm();
    noAmount.assetForm.idControl.updateValue(base.bca.id);
    noAmount.assetForm.nameControl.updateValue('BCA');
    noAmount.assetForm.balanceControl.updateValue(5000000);
    expect(
      () => getIt<TransactionRepository>().recordTransaction(
        form: noAmount,
        type: TransactionType.income,
      ),
      throwsException,
    );

    // Tanpa dompet.
    final noAsset = TransactionForm();
    noAsset.categories.first.categoryIdControl.updateValue(base.gajiId);
    noAsset.categories.first.amountControl.updateValue(100000);
    noAsset.totalAmountControl.updateValue(100000);
    expect(
      () => getIt<TransactionRepository>().recordTransaction(
        form: noAsset,
        type: TransactionType.income,
      ),
      throwsException,
    );

    expect(await totalUang(), 6000000);
  });

  test('TC-OUT flow catat, batch, edit, pindah dompet, hapus + anggaran',
      () async {
    final base = await seedBaseData();

    // TC-OUT-001: pengeluaran single kategori mengurangi anggaran.
    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: base.makanId,
      amount: 50000,
    );
    final expenseId = await lastPostedJournalId();
    expect(await balanceOf(base.bca.id), 4950000);
    expect(await totalUang(), 5950000);
    var budget = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
    expect(budget?.actualSpend, 50000);
    expect(budget?.remaining, 950000);

    // TC-OUT-002: batch Makan 30rb + Transport 20rb satu nota.
    final batch = TransactionForm();
    batch.assetForm.idControl.updateValue(base.bca.id);
    batch.assetForm.nameControl.updateValue('BCA');
    batch.assetForm.balanceControl.updateValue(4950000);
    batch.categories.first.categoryIdControl.updateValue(base.makanId);
    batch.categories.first.amountControl.updateValue(30000);
    batch.addCategory();
    batch.categories[1].categoryIdControl.updateValue(base.transportId);
    batch.categories[1].amountControl.updateValue(20000);
    batch.totalAmountControl.updateValue(50000);
    await getIt<TransactionRepository>().recordTransaction(
      form: batch,
      type: TransactionType.expense,
    );
    expect(await balanceOf(base.bca.id), 4900000);
    budget = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
    expect(budget?.actualSpend, 80000);

    // TC-OUT-007: edit naik 50rb -> 80rb di dompet sama.
    final editUp = singleCategoryForm(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 4900000,
      categoryId: base.makanId,
      amount: 80000,
    );
    final editedId = await getIt<TransactionRepository>().updateTransaction(
      id: expenseId,
      form: editUp,
      type: TransactionType.expense,
    );
    expect(await balanceOf(base.bca.id), 4870000);
    budget = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
    expect(budget?.actualSpend, 110000);

    // TC-OUT-008: edit pindah dompet — BCA kembali, Tunai berkurang.
    final moveToTunai = singleCategoryForm(
      assetId: base.tunai.id,
      assetName: 'Tunai',
      assetBalance: 1000000,
      categoryId: base.makanId,
      amount: 80000,
    );
    final movedId = await getIt<TransactionRepository>().updateTransaction(
      id: editedId,
      form: moveToTunai,
      type: TransactionType.expense,
    );
    expect(await balanceOf(base.bca.id), 4950000);
    expect(await balanceOf(base.tunai.id), 920000);

    // TC-OUT-010 + TC-ACT-009: hapus mengembalikan saldo & anggaran.
    await voidJournal(movedId);
    expect(await balanceOf(base.tunai.id), 1000000);
    expect(await totalUang(), 5950000);
    budget = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
    expect(budget?.actualSpend, 30000);

    final summary = await getIt<ReportRepository>().getMonthlySummary(
      ReportPeriod.currentMonth(),
    );
    expect(summary.expense, 50000);
  });

  test('TC-TRF flow pindah dana, edit, hapus, validasi', () async {
    final base = await seedBaseData();
    final gopay = await createWallet(
      name: 'GoPay',
      preset: AccountPreset.eWallet,
    );
    final t0 = await totalUang();

    // TC-TRF-001: BCA -> GoPay Rp200.000, Total Uang tetap.
    await getIt<TransferRepository>().transferBalance(
      form: transferForm(
        sourceId: base.bca.id,
        sourceName: 'BCA',
        sourceBalance: 5000000,
        destinationId: gopay.id,
        destinationName: 'GoPay',
        destinationBalance: 0,
        amount: 200000,
      ),
    );
    final transferId = await lastPostedJournalId();
    expect(await balanceOf(base.bca.id), 4800000);
    expect(await balanceOf(gopay.id), 200000);
    expect(await totalUang(), t0);

    // TC-TRF-007: edit transfer 200rb -> 250rb (koreksi selisih).
    final edit = transferForm(
      sourceId: base.bca.id,
      sourceName: 'BCA',
      sourceBalance: 4800000,
      destinationId: gopay.id,
      destinationName: 'GoPay',
      destinationBalance: 200000,
      amount: 250000,
    );
    await getIt<TransferRepository>().updateTransfer(form: edit, id: transferId);
    final editedId = await lastPostedJournalId();
    expect(await balanceOf(base.bca.id), 4750000);
    expect(await balanceOf(gopay.id), 250000);
    expect(await totalUang(), t0);

    // TC-TRF-008: hapus mengembalikan kedua sisi.
    await voidJournal(editedId);
    expect(await balanceOf(base.bca.id), 5000000);
    expect(await balanceOf(gopay.id), 0);
    expect(await totalUang(), t0);

    // TC-TRF-004: nominal/dompet wajib diisi.
    final noAmount = TransferForm();
    noAmount.sourceForm.idControl.updateValue(base.bca.id);
    noAmount.sourceForm.nameControl.updateValue('BCA');
    noAmount.sourceForm.balanceControl.updateValue(5000000);
    noAmount.destinationForm.idControl.updateValue(gopay.id);
    noAmount.destinationForm.nameControl.updateValue('GoPay');
    noAmount.destinationForm.balanceControl.updateValue(0);
    expect(
      () => getIt<TransferRepository>().transferBalance(form: noAmount),
      throwsException,
    );
    expect(await totalUang(), t0);
  });

  test('TC-ADJ flow sesuaikan naik, turun, hapus, validasi', () async {
    final base = await seedBaseData();
    final t0 = await totalUang();

    // TC-ADJ-001: sesuaikan naik 5jt -> 5,2jt.
    var bca = await getIt<AccountRepository>().getAccount(base.bca.id);
    await getIt<BalanceAdjustmentRepository>().adjustBalance(
      form: adjustmentForm(account: bca!, actualBalance: 5200000),
    );
    final upId = await lastPostedJournalId();
    expect(await balanceOf(base.bca.id), 5200000);
    expect(await totalUang(), t0 + 200000);
    // Penyesuaian bertipe sendiri: tak sentuh anggaran maupun income/expense.
    var budget = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
    expect(budget?.actualSpend, 0);
    var summary = await getIt<ReportRepository>().getMonthlySummary(
      ReportPeriod.currentMonth(),
    );
    expect(summary.income, 0);
    expect(summary.expense, 0);

    // TC-ADJ-007: hapus penyesuaian mengembalikan saldo.
    await voidJournal(upId);
    expect(await balanceOf(base.bca.id), 5000000);
    expect(await totalUang(), t0);

    // TC-ADJ-002: sesuaikan turun 5jt -> 4,8jt lalu hapus.
    bca = await getIt<AccountRepository>().getAccount(base.bca.id);
    await getIt<BalanceAdjustmentRepository>().adjustBalance(
      form: adjustmentForm(account: bca!, actualBalance: 4800000),
    );
    final downId = await lastPostedJournalId();
    expect(await balanceOf(base.bca.id), 4800000);
    expect(await totalUang(), t0 - 200000);
    await voidJournal(downId);
    expect(await balanceOf(base.bca.id), 5000000);
    expect(await totalUang(), t0);

    // TC-ADJ-004: saldo sebenarnya wajib diisi.
    bca = await getIt<AccountRepository>().getAccount(base.bca.id);
    final empty = BalanceAdjustmentForm();
    empty.accountControl.updateValue(bca!);
    expect(
      () => getIt<BalanceAdjustmentRepository>().adjustBalance(form: empty),
      throwsException,
    );
    expect(await totalUang(), t0);
  });

  test('TC-ADJ-003 sesuaikan sama (selisih 0) no-op tanpa jurnal',
      () async {
    // UPDATE TC2-ADJ-001 (IMP-4): selisih 0 = no-op, bukan jurnal Rp0.
    final base = await seedBaseData();
    final t0 = await totalUang();
    final beforeId = await lastPostedJournalId();

    final bca = await getIt<AccountRepository>().getAccount(base.bca.id);
    await expectLater(
      getIt<BalanceAdjustmentRepository>().adjustBalance(
        form: adjustmentForm(account: bca!, actualBalance: 5000000),
      ),
      throwsA(isA<NoOpBalanceAdjustmentException>()),
    );

    // Tanpa jurnal baru, tanpa perubahan saldo & Total.
    expect(await lastPostedJournalId(), beforeId);
    expect(await balanceOf(base.bca.id), 5000000);
    expect(await totalUang(), t0);
  });

  test('TC-IN-008 pemasukan tanggal lampau tersimpan di hari itu', () async {
    final base = await seedBaseData();
    final now = DateTime.now();
    final past = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 3));

    await getIt<TransactionRepository>().recordTransaction(
      form: singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5000000,
        categoryId: base.gajiId,
        amount: 250000,
        date: past.add(const Duration(hours: 10)),
      ),
      type: TransactionType.income,
    );
    final id = await lastPostedJournalId();

    final db = await getIt<DbService>().database;
    final rows = await db.query(
      journalEntryTable,
      columns: [JournalEntryKey.entryDate],
      where: '${JournalEntryKey.id} = ?',
      whereArgs: [id],
      limit: 1,
    );
    final entryDate = rows.first[JournalEntryKey.entryDate] as int;
    final dayStart = past.millisecondsSinceEpoch ~/ 1000;
    expect(entryDate, inInclusiveRange(dayStart, dayStart + 86399));
    // Saldo tetap bertambah walau tanggal lampau.
    expect(await balanceOf(base.bca.id), 5250000);
  });

  test('TC-ACT-003/004 filter tipe, periode, search, dan per dompet',
      () async {
    final base = await seedBaseData();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    await recordIncome(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: base.gajiId,
      amount: 500000,
      note: 'Gaji Jan',
    );
    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5500000,
      categoryId: base.makanId,
      amount: 50000,
    );
    await getIt<TransferRepository>().transferBalance(
      form: transferForm(
        sourceId: base.bca.id,
        sourceName: 'BCA',
        sourceBalance: 5450000,
        destinationId: base.tunai.id,
        destinationName: 'Tunai',
        destinationBalance: 1000000,
        amount: 10000,
      ),
    );
    var bca = await getIt<AccountRepository>().getAccount(base.bca.id);
    await getIt<BalanceAdjustmentRepository>().adjustBalance(
      form: adjustmentForm(
        account: bca!,
        actualBalance: await balanceOf(base.bca.id),
      ),
    );
    await getIt<TransactionRepository>().recordTransaction(
      form: singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5440000,
        categoryId: base.makanId,
        amount: 20000,
        date: now.subtract(const Duration(days: 10)),
      ),
      type: TransactionType.expense,
    );

    Future<int> count(JournalFilter filter) async {
      final result = await getIt<JournalRepository>().getJournals(
        pagination: const Pagination(limit: 50),
        filter: filter,
      );
      return result.items.length;
    }

    // TC-ACT-003: chip tipe (jurnal setup otomatis dikecualikan).
    expect(
      await count(const JournalFilter(type: ActivityType.expense)),
      2,
    );
    expect(await count(const JournalFilter(type: ActivityType.income)), 1);
    expect(
      await count(const JournalFilter(type: ActivityType.transfer)),
      1,
    );
    expect(
      await count(const JournalFilter(type: ActivityType.adjustment)),
      1,
    );

    // TC-ACT-004: periode hari ini mengecualikan transaksi 10 hari lalu.
    expect(
      await count(
        JournalFilter(
          dates: (
            todayStart,
            todayStart.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
          ),
        ),
      ),
      4,
    );

    // TC-ACT-002 (logika): search deskripsi case-insensitive.
    expect(await count(const JournalFilter(description: 'gaji')), 1);
    expect(await count(const JournalFilter(description: 'xyz-tidak-ada')), 0);

    // TC-ACT-005 (logika): filter per dompet — semua 5 menyentuh BCA.
    expect(await count(JournalFilter(accountId: base.bca.id)), 5);
    expect(await count(JournalFilter(accountId: base.tunai.id)), 1);
  });

  test('TC-DSH-009 ringkasan hari ini: aturan ikut/tidak ikut', () async {
    final base = await seedBaseData();

    var summary = await getIt<DashboardRepository>().getTransactionSummary();
    expect(summary.income, 0);
    expect(summary.expense, 0);

    await recordIncome(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: base.gajiId,
      amount: 500000,
    );
    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5500000,
      categoryId: base.makanId,
      amount: 100000,
    );
    summary = await getIt<DashboardRepository>().getTransactionSummary();
    expect(summary.income, 500000);
    expect(summary.expense, 100000);

    // Topup ditarik dari ringkasan; belanja dari target ikut Pengeluaran.
    await getIt<SavingRepository>().topup(
      pocketId: base.target.accountId,
      assetId: base.bca.id,
      amount: 50000,
    );
    summary = await getIt<DashboardRepository>().getTransactionSummary();
    expect(summary.expense, 100000);
    await getIt<SavingRepository>().spend(
      pocketId: base.target.accountId,
      categoryId: base.makanId,
        assetId: base.bca.id,
      amount: 30000,
    );
    summary = await getIt<DashboardRepository>().getTransactionSummary();
    expect(summary.expense, 130000);
  });
}