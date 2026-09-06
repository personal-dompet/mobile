import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/reports/models/category_spending.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:dompet_app/features/reports/models/period_comparison.dart';
import 'package:dompet_app/features/reports/models/report_insight.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:dompet_app/features/savings/models/saving_insight.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/repositories/transaction_repository.dart';
import 'package:dompet_app/features/transactions/repositories/balance_adjustment_repository.dart';
import 'package:dompet_app/features/transactions/repositories/transfer_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/fixture.dart';

/// Alur Target, Anggaran, Laporan, dan konsistensi lintas aksi.
///
/// Menggabungkan:
/// - TC-TRG-001/002/003/004/006/009/010/013/014/015/017/022/023/024/025
/// - TC-BGT-003/008/010/011/014/015/016/018/019/020
/// - TC-RPT-003 (rumus net & dialokasikan)
/// - TC-GLB-002 (konsistensi Total Uang lintas aksi)
///
/// Tidak diotomatiskan (widget/UI murni): TC-TRG-005/007/008/011/012/016/
/// 018/019/020/021/026/027, TC-BGT-001/002/004/005/006/007/009/012/013/017/021,
/// TC-RPT-001/002/004 s.d. TC-RPT-012 — diverifikasi manual.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(resetFixture);
  tearDown(disposeFixture);

  test('TC-TRG-001/002/003/004/006/023/024 buat, validasi, edit, hapus kosong',
      () async {
    await seedBaseData();
    final t0 = await totalUang();

    // TC-TRG-001: buat target dengan nominal + deadline.
    final deadline = DateTime.now().add(const Duration(days: 180));
    final laptop = await getIt<SavingRepository>().createPocket(
      name: 'Laptop',
      targetAmount: 10000000,
      targetDate: deadline.millisecondsSinceEpoch ~/ 1000,
      note: 'kerja',
    );
    expect(laptop.balance, 0);
    expect(laptop.targetAmount, 10000000);
    // TC-TRG-001 efek samping: dompet & Total Uang tidak berubah.
    expect(await totalUang(), t0);

    // TC-TRG-002: tanpa nominal & tanggal — berhasil.
    final fleksibel = await getIt<SavingRepository>().createPocket(
      name: 'Dana Fleksibel',
    );
    expect(fleksibel.targetAmount, isNull);

    // TC-TRG-003: nama kosong ditolak.
    expect(
      () => getIt<SavingRepository>().createPocket(name: '   '),
      throwsException,
    );

    // TC-TRG-004: nominal 0 / negatif ditolak.
    expect(
      () => getIt<SavingRepository>().createPocket(
        name: 'Nol',
        targetAmount: 0,
      ),
      throwsException,
    );
    expect(
      () => getIt<SavingRepository>().createPocket(
        name: 'Minus',
        targetAmount: -10000,
      ),
      throwsException,
    );

    // TC-TRG-006: nama duplikat diizinkan.
    final laptop2 = await getIt<SavingRepository>().createPocket(
      name: 'Laptop',
      targetAmount: 5000000,
    );
    expect(laptop2.accountId, isNot(laptop.accountId));

    // TC-TRG-023: edit hanya ubah info — saldo tetap.
    await getIt<SavingRepository>().topup(
      pocketId: laptop.accountId,
      assetId: (await seedTopupSource()),
      amount: 120000,
    );
    final edited = await getIt<SavingRepository>().updatePlan(
      accountId: laptop.accountId,
      name: 'Laptop Baru',
      targetAmount: 15000000,
    );
    expect(edited?.accountName, 'Laptop Baru');
    final afterEdit = await getIt<SavingRepository>().getByAccountId(
      laptop.accountId,
    );
    expect(afterEdit?.balance, 120000);

    // TC-TRG-024: hapus target saldo kosong — tanpa jurnal, saldo tetap.
    final t1 = await totalUang();
    await getIt<SavingRepository>().delete(fleksibel.accountId);
    expect(
      await getIt<SavingRepository>().getByAccountId(fleksibel.accountId),
      isNull,
    );
    expect(await totalUang(), t1);
  });

  test(
    'TC-TRG-009/010/013/014/015/017/022/025 alokasi, tarik, belanja, hapus bersaldo',
    () async {
      final base = await seedBaseData();
      final pocketId = base.target.accountId;
      final t0 = await totalUang();

      // TC-TRG-009: alokasi Rp200.000 — dompet & Total Uang berkurang.
      await getIt<SavingRepository>().topup(
        pocketId: pocketId,
        assetId: base.bca.id,
        amount: 200000,
      );
      expect(await balanceOf(base.bca.id), 4800000);
      expect(await balanceOf(pocketId), 200000);
      expect(await totalUang(), t0 - 200000);

      // TC-TRG-010: alokasi melebihi saldo dompet ditolak.
      expect(
        () => getIt<SavingRepository>().topup(
          pocketId: pocketId,
          assetId: base.tunai.id,
          amount: 5000000,
        ),
        throwsException,
      );
      expect(await balanceOf(pocketId), 200000);

      // TC-TRG-011: nominal 0 ditolak.
      expect(
        () => getIt<SavingRepository>().topup(
          pocketId: pocketId,
          assetId: base.bca.id,
          amount: 0,
        ),
        throwsException,
      );

      // TC-TRG-013: tarik Rp50.000 — Total Uang bertambah lagi.
      await getIt<SavingRepository>().withdraw(
        pocketId: pocketId,
        assetId: base.bca.id,
        amount: 50000,
      );
      expect(await balanceOf(pocketId), 150000);
      expect(await balanceOf(base.bca.id), 4850000);
      expect(await totalUang(), t0 - 150000);

      // TC-TRG-014: tarik melebihi saldo target ditolak.
      expect(
        () => getIt<SavingRepository>().withdraw(
          pocketId: pocketId,
          assetId: base.bca.id,
          amount: 200000,
        ),
        throwsException,
      );

      // TC-TRG-015: belanja Rp30.000 kategori Makan — dompet & Total tetap,
      // laporan + anggaran bertambah.
      final bcaBefore = await balanceOf(base.bca.id);
      final totalBefore = await totalUang();
      await getIt<SavingRepository>().spend(
        pocketId: pocketId,
        categoryId: base.makanId,
        amount: 30000,
      );
      expect(await balanceOf(pocketId), 120000);
      expect(await balanceOf(base.bca.id), bcaBefore);
      expect(await totalUang(), totalBefore);
      final summary = await getIt<ReportRepository>().getMonthlySummary(
        ReportPeriod.currentMonth(),
      );
      expect(summary.expense, 30000);
      expect(summary.savingSpend, 30000);
      final budget = await getIt<BudgetRepository>().getActiveBudget(
        base.makanId,
      );
      expect(budget?.actualSpend, 30000);

      // TC-TRG-017: belanja melebihi saldo target ditolak.
      expect(
        () => getIt<SavingRepository>().spend(
          pocketId: pocketId,
          categoryId: base.makanId,
          amount: 200000,
        ),
        throwsException,
      );

      // TC-TRG-022: riwayat = topup, tarik, belanja (3 jurnal).
      final history = await getIt<SavingRepository>().getPocketJournals(
        pocketId,
      );
      expect(history.length, 3);

      // TC-TRG-025: hapus bersaldo — sisa kembali ke dompet.
      await getIt<SavingRepository>().deleteWithWithdraw(
        accountId: pocketId,
        assetId: base.bca.id,
      );
      expect(
        await getIt<SavingRepository>().getByAccountId(pocketId),
        isNull,
      );
      expect(await balanceOf(base.bca.id), bcaBefore + 120000);
      expect(await totalUang(), totalBefore + 120000);
    },
  );

  test(
    'TC-BGT flow rencana, aktifkan, spend, tutup, rollover, edit/hapus rencana',
    () async {
      final base = await seedBaseData();

      // TC-BGT-003/008: rencana Transport Rp500.000 lalu aktifkan.
      await getIt<BudgetPlanRepository>().upsert(
        accountId: base.transportId,
        amount: 500000,
        note: 'transport',
      );
      var plan = await getIt<BudgetPlanRepository>().getByAccountId(
        base.transportId,
      );
      expect(plan?.amount, 500000);
      await getIt<BudgetRepository>().createBudget(
        accountId: base.transportId,
        amount: 500000,
        periode: DateTime.now(),
      );
      var active = await getIt<BudgetRepository>().getActiveBudget(
        base.transportId,
      );
      expect(active, isNotNull);
      expect(active?.actualBudgetAmount, 500000);

      // TC-BGT-010: pengeluaran mengurangi sisa.
      await recordExpense(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5000000,
        categoryId: base.makanId,
        amount: 100000,
      );
      var makan = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
      expect(makan?.actualSpend, 100000);
      expect(makan?.remaining, 900000);

      // TC-BGT-011: belanja dari target ikut mengurangi sisa.
      final pocket = await getIt<SavingRepository>().createPocket(
        name: 'Belanja',
      );
      await getIt<SavingRepository>().topup(
        pocketId: pocket.accountId,
        assetId: base.bca.id,
        amount: 200000,
      );
      await getIt<SavingRepository>().spend(
        pocketId: pocket.accountId,
        categoryId: base.makanId,
        amount: 30000,
      );
      makan = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
      expect(makan?.actualSpend, 130000);

      // TC-BGT-018: upsert bulan sama tidak duplikat error.
      await getIt<BudgetRepository>().createBudget(
        accountId: base.makanId,
        amount: 1000000,
        periode: DateTime.now(),
      );
      makan = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
      expect(makan?.budgetAmount, 1000000);

      // TC-BGT-019: edit rencana tak sentuh anggaran aktif.
      await getIt<BudgetPlanRepository>().upsert(
        accountId: base.makanId,
        amount: 2000000,
        note: 'naik',
      );
      makan = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
      expect(makan?.budgetAmount, 1000000);
      plan = await getIt<BudgetPlanRepository>().getByAccountId(base.makanId);
      expect(plan?.amount, 2000000);

      // TC-BGT-020: hapus rencana tak hapus anggaran aktif.
      await getIt<BudgetPlanRepository>().delete(base.makanId);
      expect(
        await getIt<BudgetPlanRepository>().getByAccountId(base.makanId),
        isNull,
      );
      expect(
        await getIt<BudgetRepository>().getActiveBudget(base.makanId),
        isNotNull,
      );

      // TC-BGT-014: tutup — hilang dari list aktif.
      await getIt<BudgetRepository>().closeActiveBudgets(base.transportId);
      expect(
        await getIt<BudgetRepository>().getActiveBudget(base.transportId),
        isNull,
      );

      // TC-BGT-015: tutup & buka baru tanpa sisa (carry 0).
      await getIt<BudgetRepository>().createBudget(
        accountId: base.transportId,
        amount: 500000,
        periode: DateTime.now(),
      );
      active = await getIt<BudgetRepository>().getActiveBudget(base.transportId);
      expect(active?.actualBudgetAmount, 500000);

      // TC-BGT-016: tutup & buka baru dengan sisa (rollover).
      await getIt<BudgetRepository>().closeActiveBudgets(base.transportId);
      await getIt<BudgetRepository>().createBudget(
        accountId: base.transportId,
        amount: 500000,
        periode: DateTime.now(),
        carryAmount: 200000,
      );
      active = await getIt<BudgetRepository>().getActiveBudget(base.transportId);
      expect(active?.actualBudgetAmount, 700000);
      expect(active?.carryAmount, 200000);
    },
  );

  test('TC-RPT-003 + TC-GLB-002 rumus laporan & konsistensi Total Uang',
      () async {
    final base = await seedBaseData();
    final pocketId = base.target.accountId;
    final t0 = await totalUang();

    // Rangkaian TC-GLB-002.
    await recordIncome(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: base.gajiId,
      amount: 100000,
    );
    final incomeId = await lastPostedJournalId();
    expect(await totalUang(), t0 + 100000);

    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5100000,
      categoryId: base.makanId,
      amount: 40000,
    );
    final expenseId = await lastPostedJournalId();
    expect(await totalUang(), t0 + 60000);

    await getIt<TransferRepository>().transferBalance(
      form: transferForm(
        sourceId: base.bca.id,
        sourceName: 'BCA',
        sourceBalance: 5060000,
        destinationId: base.tunai.id,
        destinationName: 'Tunai',
        destinationBalance: 1000000,
        amount: 50000,
      ),
    );
    final transferId = await lastPostedJournalId();
    expect(await totalUang(), t0 + 60000);

    final topupId = await getIt<SavingRepository>().topup(
      pocketId: pocketId,
      assetId: base.bca.id,
      amount: 50000,
    );
    expect(await totalUang(), t0 + 10000);

    final withdrawId = await getIt<SavingRepository>().withdraw(
      pocketId: pocketId,
      assetId: base.bca.id,
      amount: 20000,
    );
    expect(await totalUang(), t0 + 30000);

    final spendId = await getIt<SavingRepository>().spend(
      pocketId: pocketId,
      categoryId: base.makanId,
      amount: 10000,
    );
    expect(await totalUang(), t0 + 30000);

    final bca = await getIt<AccountRepository>().getAccount(base.bca.id);
    await getIt<BalanceAdjustmentRepository>().adjustBalance(
      form: adjustmentForm(
        account: bca!,
        actualBalance: await balanceOf(base.bca.id) + 10000,
      ),
    );
    final adjustId = await lastPostedJournalId();
    expect(await totalUang(), t0 + 40000);

    // TC-RPT-003: net = 100rb - 50rb; dialokasikan = 50-20-10rb;
    // perubahan uang tersedia = net - netSaving + penyesuaian.
    final summary = await getIt<ReportRepository>().getMonthlySummary(
      ReportPeriod.currentMonth(),
    );
    expect(summary.income, 100000);
    expect(summary.expense, 50000);
    expect(summary.net, 50000);
    expect(summary.netSaving, 20000);
    expect(summary.liquidChange, 30000);
    expect(
      summary.liquidChange + 10000,
      (await totalUang()) - t0,
      reason: 'selisih Rp10.000 adalah penyesuaian saldo (di luar metrik)',
    );

    // TC-GLB-002 akhir: hapus semua satu per satu → kembali ke T0.
    for (final id in [
      adjustId,
      spendId,
      withdrawId,
      topupId,
      transferId,
      expenseId,
      incomeId,
    ]) {
      await voidJournal(id);
    }
    expect(await totalUang(), t0);
    expect(await balanceOf(base.bca.id), 5000000);
    expect(await balanceOf(base.tunai.id), 1000000);
    expect(await balanceOf(pocketId), 0);
    final makan = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
    expect(makan?.actualSpend, 0);
    final clean = await getIt<ReportRepository>().getMonthlySummary(
      ReportPeriod.currentMonth(),
    );
    expect(clean.isEmpty, isTrue);
  });

  test('TC-TRG-016 belanja tanpa kategori valid ditolak', () async {
    final base = await seedBaseData();

    await getIt<SavingRepository>().topup(
      pocketId: base.target.accountId,
      assetId: base.bca.id,
      amount: 100000,
    );
    expect(
      () => getIt<SavingRepository>().spend(
        pocketId: base.target.accountId,
        categoryId: 999999,
        amount: 10000,
      ),
      throwsException,
    );
    expect(await balanceOf(base.target.accountId), 100000);
  });

  test('TC-TRG-019/020 insight proyeksi & overdue', () async {
    final base = await seedBaseData();
    final now = DateTime.now();

    // TC-TRG-019: tanpa deadline + 1 topup → notEnoughData (tanpa ETA);
    // topup ke-2 → projected + ETA. Withdraw/belanja diabaikan untuk laju
    // (hanya jurnal TOPUP yang dihitung).
    final pocket = await getIt<SavingRepository>().createPocket(
      name: 'Proyeksi',
      targetAmount: 1000000,
    );
    await getIt<SavingRepository>().topup(
      pocketId: pocket.accountId,
      assetId: base.bca.id,
      amount: 100000,
    );
    var plan = await getIt<SavingRepository>().getByAccountId(pocket.accountId);
    var journals = await getIt<SavingRepository>().getPocketJournals(
      pocket.accountId,
    );
    var insight = SavingInsight.compute(plan: plan!, journals: journals, now: now);
    expect(insight.topupCount, 1);
    expect(insight.status, SavingInsightStatus.notEnoughData);
    expect(insight.showProjection, isFalse);

    await getIt<SavingRepository>().topup(
      pocketId: pocket.accountId,
      assetId: base.bca.id,
      amount: 50000,
    );
    plan = await getIt<SavingRepository>().getByAccountId(pocket.accountId);
    journals = await getIt<SavingRepository>().getPocketJournals(
      pocket.accountId,
    );
    insight = SavingInsight.compute(plan: plan!, journals: journals, now: now);
    expect(insight.topupCount, 2);
    expect(insight.status, SavingInsightStatus.projected);
    expect(insight.showProjection, isTrue);

    // 1 topup + ada deadline → status projected (ada neededPerMonth) tapi
    // TETAP tanpa ETA menyesatkan (tanpa tanggal proyeksi).
    final dated = await getIt<SavingRepository>().createPocket(
      name: 'Dated',
      targetAmount: 1000000,
      targetDate: now.add(const Duration(days: 180)).millisecondsSinceEpoch ~/ 1000,
    );
    await getIt<SavingRepository>().topup(
      pocketId: dated.accountId,
      assetId: base.bca.id,
      amount: 100000,
    );
    final datedPlan = await getIt<SavingRepository>().getByAccountId(
      dated.accountId,
    );
    final datedJournals = await getIt<SavingRepository>().getPocketJournals(
      dated.accountId,
    );
    final datedInsight = SavingInsight.compute(
      plan: datedPlan!,
      journals: datedJournals,
      now: now,
    );
    expect(datedInsight.topupCount, 1);
    expect(datedInsight.neededPerMonth, isNotNull);
    expect(datedInsight.projectedDate, isNull);
    expect(datedInsight.showProjection, isFalse);

    // TC-TRG-020: deadline lewat → overdue, bukan proyeksi menyesatkan.
    final telat = await getIt<SavingRepository>().createPocket(
      name: 'Telat',
      targetAmount: 500000,
      targetDate:
          now.subtract(const Duration(days: 1)).millisecondsSinceEpoch ~/ 1000,
    );
    await getIt<SavingRepository>().topup(
      pocketId: telat.accountId,
      assetId: base.bca.id,
      amount: 50000,
    );
    final telatPlan = await getIt<SavingRepository>().getByAccountId(
      telat.accountId,
    );
    final telatJournals = await getIt<SavingRepository>().getPocketJournals(
      telat.accountId,
    );
    final telatInsight = SavingInsight.compute(
      plan: telatPlan!,
      journals: telatJournals,
      now: now,
    );
    expect(telatInsight.isOverdue, isTrue);
    expect(telatInsight.showNeedRate, isFalse);
  });

  test('TC-BGT-012 over-budget: sisa negatif, rasio > 100%', () async {
    final base = await seedBaseData();

    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: base.makanId,
      amount: 1100000,
    );
    final budget = await getIt<BudgetRepository>().getActiveBudget(
      base.makanId,
    );
    expect(budget?.actualSpend, 1100000);
    expect(budget?.remaining, -100000);
    expect(budget?.useageRatio, greaterThan(1));
  });

  test('TC-DSH-004 subtitle: jumlah dompet & nominal dialokasikan', () async {
    final base = await seedBaseData();

    // Prinsip subtitle BalanceCard: hitung dompet cair + netSaving bulan ini.
    final accounts = await getIt<AccountRepository>().getAccounts(
      filter: const AccountFilter(
        isSystem: false,
        isLiqid: true,
        type: AccountType.asset,
      ),
    );
    expect(accounts.length, 2);

    var summary = await getIt<ReportRepository>().getMonthlySummary(
      ReportPeriod.currentMonth(),
    );
    expect(summary.netSaving, 0);

    await getIt<SavingRepository>().topup(
      pocketId: base.target.accountId,
      assetId: base.bca.id,
      amount: 200000,
    );
    summary = await getIt<ReportRepository>().getMonthlySummary(
      ReportPeriod.currentMonth(),
    );
    expect(summary.netSaving, 200000);
  });

  test('TC-RPT-004/005/006 comparison, insight, kartu alokasi', () async {
    final base = await seedBaseData();
    final now = DateTime.now();
    final current = ReportPeriod.currentMonth();
    final prevMonth = DateTime(now.year, now.month - 1, 15);

    // Baseline 0 & kini > 0 → persen disembunyikan (netral).
    await recordIncome(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: base.gajiId,
      amount: 1000000,
    );
    var comparison = await getIt<ReportRepository>().getComparison(current);
    expect(comparison.incomeChangePercent, isNull);
    expect(comparison.incomeLabel, isNull);

    // Bulan lalu ada data → label naik/turun + % benar.
    await getIt<TransactionRepository>().recordTransaction(
      form: singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 6000000,
        categoryId: base.gajiId,
        amount: 500000,
        date: prevMonth,
      ),
      type: TransactionType.income,
    );
    await getIt<TransactionRepository>().recordTransaction(
      form: singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 6500000,
        categoryId: base.makanId,
        amount: 200000,
        date: prevMonth,
      ),
      type: TransactionType.expense,
    );
    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 6300000,
      categoryId: base.makanId,
      amount: 400000,
    );
    comparison = await getIt<ReportRepository>().getComparison(current);
    expect(comparison.incomeChangePercent, 100);
    expect(comparison.incomeLabel, 'naik 100%');
    expect(comparison.expenseChangePercent, 100);
    expect(comparison.expenseLabel, 'naik 100%');
    expect(PeriodComparison.changeLabel(0), 'tetap');
    expect(PeriodComparison.changePercent(current: 0, previous: 0), 0);

    // TC-RPT-005: insight surplus + aturan bulan kosong.
    final summary = await getIt<ReportRepository>().getMonthlySummary(current);
    final trend = await getIt<ReportRepository>().getTrend(current);
    final categories = await getIt<ReportRepository>().getExpenseByCategory(
      current,
    );
    final insights = ReportInsight.generate(
      current: summary,
      comparison: comparison,
      trend: trend,
      categories: categories,
    );
    expect(insights.first.message, contains('surplus'));
    final emptyInsights = ReportInsight.generate(
      current: MonthlySummary(period: current),
      comparison: comparison,
      trend: const [],
      categories: const [],
    );
    expect(emptyInsights.length, 1);
    expect(emptyInsights.first.message, contains('Belum ada transaksi'));

    // TC-RPT-006: kartu alokasi hidden tanpa aktivitas target.
    expect(summary.hasSavingActivity, isFalse);
    await getIt<SavingRepository>().topup(
      pocketId: base.target.accountId,
      assetId: base.bca.id,
      amount: 50000,
    );
    final withSaving = await getIt<ReportRepository>().getMonthlySummary(
      current,
    );
    expect(withSaving.hasSavingActivity, isTrue);
  });

  test('TC-RPT-007/008/009/010 kategori, anggaran, tren, bulan kosong',
      () async {
    final base = await seedBaseData();
    final current = ReportPeriod.currentMonth();

    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 5000000,
      categoryId: base.makanId,
      amount: 100000,
    );
    await recordExpense(
      assetId: base.bca.id,
      assetName: 'BCA',
      assetBalance: 4900000,
      categoryId: base.transportId,
      amount: 50000,
    );

    // TC-RPT-007: urut terbesar + persentase; aturan "Lainnya" untuk >6.
    final categories = await getIt<ReportRepository>().getExpenseByCategory(
      current,
    );
    expect(categories.map((c) => c.amount), [100000, 50000]);
    expect(categories.first.percentage, closeTo(66.67, 0.01));
    final many = List.generate(
      7,
      (i) => CategorySpending(
        accountId: i,
        name: 'K$i',
        amount: 10000,
        percentage: 10,
      ),
    );
    final grouped = CategorySpending.topWithOthers(many);
    expect(grouped.length, 7);
    expect(grouped.last.name, 'Lainnya');
    expect(grouped.last.amount, 10000);

    // TC-RPT-008: section anggaran ada isi vs bulan kosong hidden.
    final budgets = await getIt<BudgetRepository>().getBudgetsForMonth(current);
    expect(budgets.map((b) => b.accountId), contains(base.makanId));
    final makan = budgets.firstWhere((b) => b.accountId == base.makanId);
    expect(makan.actualSpend, 100000);
    expect(
      await getIt<BudgetRepository>().getBudgetsForMonth(
        const ReportPeriod(year: 2020, month: 1),
      ),
      isEmpty,
    );

    // TC-RPT-009: tren 6 titik, kosong → nol.
    final trend = await getIt<ReportRepository>().getTrend(current);
    expect(trend.length, 6);
    expect(trend.last.expense, 150000);
    expect(trend.first.isEmpty, isTrue);

    // TC-RPT-010: bulan kosong total.
    final empty = await getIt<ReportRepository>().getMonthlySummary(
      const ReportPeriod(year: 2020, month: 1),
    );
    expect(empty.isEmpty, isTrue);
  });
}

/// Dompet cair ber-saldo untuk TC-TRG-023 (butuh sumber alokasi).
Future<int> seedTopupSource() async {
  final wallet = await createWallet(
    name: 'Sumber',
    preset: AccountPreset.cash,
    balance: 1000000,
  );
  return wallet.id;
}
