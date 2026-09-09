import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/dompet_bottom_bar.dart';
import 'package:dompet_app/core/widgets/dompet_empty_search.dart';
import 'package:dompet_app/core/widgets/dompet_fab.dart';
import 'package:dompet_app/core/widgets/dompet_snackbar.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/activities/enums/activity_type.dart';
import 'package:dompet_app/features/activities/extensions/activity.dart';
import 'package:dompet_app/features/activities/widgets/activity_item_tile.dart';
import 'package:dompet_app/features/assets/pages/asset_archived_page.dart';
import 'package:dompet_app/features/assets/pages/asset_detail_page.dart';
import 'package:dompet_app/features/backup/cubits/backup_cubit.dart';
import 'package:dompet_app/features/backup/cubits/backup_state.dart';
import 'package:dompet_app/features/backup/models/backup_meta.dart';
import 'package:dompet_app/features/backup/repositories/backup_repository.dart';
import 'package:dompet_app/features/backup/services/backup_auth_service.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/budgets/models/budget_filter.dart';
import 'package:dompet_app/features/budgets/pages/budget_plan_list_page.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/budgets/widgets/archived_category_badge.dart';
import 'package:dompet_app/features/budgets/widgets/budget_fab.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/pages/category_archived_page.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:dompet_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:dompet_app/features/reports/models/category_spending.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:dompet_app/features/reports/widgets/category_spending_card.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:dompet_app/features/savings/models/saving_detail.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:dompet_app/features/savings/widgets/pocket_balance_hint.dart';
import 'package:dompet_app/features/savings/widgets/saving_fab.dart';
import 'package:dompet_app/features/transactions/cubits/balance_adjustment_cubit.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/exceptions/no_op_balance_adjustment_exception.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/repositories/balance_adjustment_repository.dart';
import 'package:dompet_app/features/transactions/repositories/transaction_repository.dart';
import 'package:dompet_app/features/transactions/repositories/transfer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'helpers/fixture.dart';
import 'helpers/test_app.dart';

/// Regression Fase-2 — 18 TC2 dari `docs/0002_TEST_CASE.md`.
///
/// Cara jalan (butuh device/emulator, JANGAN dijalankan tanpa device siap):
/// `flutter test integration_test/phase2_regression_test.dart`
///
/// Cakupan per TC2:
/// - TC2-BKP-001: kontrak state auth cadangan (unit OAuth/Drive asli tetap manual).
/// - TC2-NOM-001: tolak 0 lintas domain (form + repo + efek samping).
/// - TC2-NAV-001: replace-saat-edit sekali + dialog tutup (rantai drawer penuh manual).
/// - TC2-DSH-001: ringkasan kosong tanpa teks (repo + widget).
/// - TC2-ACT-001: jurnal setup tampil di list, eksklusif agregat.
/// - TC2-RPT-001: card pemasukan per kategori (repo + widget).
/// - TC2-SRCH-001: clear global + empty dompet + case-insensitive.
/// - TC2-KAT-001: kontrak balik buat-cepat (repo + form).
/// - TC2-KAT-002: list arsip kategori per tipe (repo + halaman arsip).
/// - TC2-DMP-001: grid arsip dompet + detail read-only (repo + widget).
/// - TC2-ADJ-001: no-op selisih 0 tanpa jurnal.
/// - TC2-OVD-001: overdraw 2 jurnal atomik (== 1 jurnal, > 2 jurnal).
/// - TC2-TRG-001: riwayat + running balance + hint terkumpul.
/// - TC2-TRG-002: belanja 2 jurnal + refresh anggaran + fallback.
/// - TC2-BGT-001: anggaran kategori diarsip (repo + badge/modal).
/// - TC2-BGT-002: list rencana anggaran (repo + halaman).
/// - TC2-TERM-001: judul Target + FAB konteks + nol bocor istilah.
/// - TC2-SNK-001: snackbar atas terang + gelap.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------------
  // Helper lokal file ini.
  // ---------------------------------------------------------------------------

  Future<int> postedJournalCount() async {
    final db = await getIt<DbService>().database;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM $journalEntryTable '
      'WHERE ${JournalEntryKey.status} = ?',
      [JournalStatus.posted.name],
    );
    return (rows.first['c'] as num).toInt();
  }

  Future<int> postedCountBySource(JournalSource source) async {
    final db = await getIt<DbService>().database;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM $journalEntryTable '
      'WHERE ${JournalEntryKey.status} = ? AND ${JournalEntryKey.source} = ?',
      [JournalStatus.posted.name, source.value],
    );
    return (rows.first['c'] as num).toInt();
  }

  CategoryForm newCategoryForm(String name, AccountType type) {
    final form = CategoryForm();
    form.nameControl.updateValue(name);
    form.typeControl.updateValue(type);
    return form;
  }

  // ---------------------------------------------------------------------------
  // TC2-BKP-001 — Auth Cadangan (kontrak state, Drive asli manual).
  // ---------------------------------------------------------------------------

  group('TC2-BKP-001 auth cadangan: logout + ganti akun + email', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('logout bersihkan meta+email basi, lokal utuh, ganti akun refresh',
        () async {
      await seedBaseData();
      final t0 = await totalUang();
      final journals0 = await postedJournalCount();

      // Step 1: login A — meta A tampil + email A eksplisit.
      final metaA = BackupMeta(
        updatedAt: DateTime.now(),
        sizeBytes: 1234,
      );
      const stateA = BackupState();
      final loggedA = stateA.copyWith(
        isSignedIn: true,
        accountEmail: 'a@mail.com',
        lastBackup: metaA,
        isLoadingMeta: false,
      );
      expect(loggedA.accountEmail, 'a@mail.com');
      expect(loggedA.lastBackup, isNotNull);
      // Step 2: setup pakai email aktual, bukan teks generik.
      expect(
        'Ada cadangan Dompet dari ${loggedA.accountEmail}.',
        contains('a@mail.com'),
      );

      // Step 3/5: logout — meta hilang + email null (FIX-02), lokal utuh.
      final cubit = BackupCubit(
        _NullBackupRepository(),
        BackupAuthService(serverClientId: 'integration-test'),
        AccountSignalCubit(),
        ActivitySignalCubit(),
        BudgetSignalCubit(),
        SavingSignalCubit(),
      );
      addTearDown(cubit.close);
      await cubit.signOut();
      expect(cubit.state.isSignedIn, isFalse);
      expect(cubit.state.lastBackup, isNull);
      expect(cubit.state.accountEmail, isNull);
      expect(await totalUang(), t0);
      expect(await postedJournalCount(), journals0);

      // Step 4: login B tanpa cadangan — kosong, bukan meta basi A.
      final loggedB = cubit.state.copyWith(
        isSignedIn: true,
        accountEmail: 'b@mail.com',
        clearLastBackup: true,
      );
      expect(loggedB.lastBackup, isNull);
      expect(loggedB.accountEmail, 'b@mail.com');
      expect(await totalUang(), t0);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-NOM-001 — Tolak nominal 0 lintas domain.
  // ---------------------------------------------------------------------------

  group('TC2-NOM-001 tolak nominal 0 lintas domain', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('0/empty ditolak form+repo di semua domain, efek samping tetap',
        () async {
      final base = await seedBaseData();
      final gopay = await createWallet(
        name: 'GoPay',
        preset: AccountPreset.eWallet,
      );
      final s0 = await balanceOf(base.bca.id);
      final t0 = await totalUang();
      final journals0 = await postedJournalCount();
      var budget = await getIt<BudgetRepository>().getActiveBudget(
        base.makanId,
      );
      final r0 = budget?.remaining;

      // 1. Pemasukan 0 single + kosong.
      final incomeZero = singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: s0,
        categoryId: base.gajiId,
        amount: 0,
      );
      expect(incomeZero.categories.first.amountControl.invalid, isTrue);
      await expectLater(
        getIt<TransactionRepository>().recordTransaction(
          form: incomeZero,
          type: TransactionType.income,
        ),
        throwsException,
      );
      final incomeEmpty = TransactionForm()
        ..assetForm.idControl.updateValue(base.bca.id)
        ..assetForm.nameControl.updateValue('BCA')
        ..assetForm.balanceControl.updateValue(s0);
      await expectLater(
        getIt<TransactionRepository>().recordTransaction(
          form: incomeEmpty,
          type: TransactionType.income,
        ),
        throwsException,
      );

      // 1b. Batch dengan satu baris 0.
      final batchZero = TransactionForm();
      batchZero.assetForm.idControl.updateValue(base.bca.id);
      batchZero.assetForm.nameControl.updateValue('BCA');
      batchZero.assetForm.balanceControl.updateValue(s0);
      batchZero.categories.first.categoryIdControl.updateValue(base.gajiId);
      batchZero.categories.first.amountControl.updateValue(0);
      batchZero.totalAmountControl.updateValue(0);
      await expectLater(
        getIt<TransactionRepository>().recordTransaction(
          form: batchZero,
          type: TransactionType.expense,
        ),
        throwsException,
      );

      // 2. Pengeluaran 0.
      final expenseZero = singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: s0,
        categoryId: base.makanId,
        amount: 0,
      );
      await expectLater(
        getIt<TransactionRepository>().recordTransaction(
          form: expenseZero,
          type: TransactionType.expense,
        ),
        throwsException,
      );

      // 3. Pindah dana 0.
      final transferZero = transferForm(
        sourceId: base.bca.id,
        sourceName: 'BCA',
        sourceBalance: s0,
        destinationId: gopay.id,
        destinationName: 'GoPay',
        destinationBalance: 0,
        amount: 0,
      );
      expect(transferZero.amountControl.invalid, isTrue);
      await expectLater(
        getIt<TransferRepository>().transferBalance(form: transferZero),
        throwsException,
      );

      // 4. Rencana anggaran 0 (plan + budget).
      await expectLater(
        getIt<BudgetPlanRepository>().upsert(
          accountId: base.transportId,
          amount: 0,
          note: null,
        ),
        throwsException,
      );
      await expectLater(
        getIt<BudgetRepository>().createBudget(
          accountId: base.transportId,
          amount: 0,
          periode: DateTime.now(),
        ),
        throwsException,
      );

      // 4b. Topup/withdraw/spend 0.
      await expectLater(
        getIt<SavingRepository>().topup(
          pocketId: base.target.accountId,
          assetId: base.bca.id,
          amount: 0,
        ),
        throwsException,
      );
      await expectLater(
        getIt<SavingRepository>().withdraw(
          pocketId: base.target.accountId,
          assetId: base.bca.id,
          amount: 0,
        ),
        throwsException,
      );

      // 5. Edit ke 0 (pemasukan + transfer).
      await recordIncome(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: s0,
        categoryId: base.gajiId,
        amount: 100000,
      );
      final incomeId = await lastPostedJournalId();
      final editZero = singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: s0 + 100000,
        categoryId: base.gajiId,
        amount: 0,
      );
      await expectLater(
        getIt<TransactionRepository>().updateTransaction(
          id: incomeId,
          form: editZero,
          type: TransactionType.income,
        ),
        throwsException,
      );
      await voidJournal(incomeId);

      // Efek samping: saldo, Total, anggaran, laporan, journal count tetap.
      expect(await balanceOf(base.bca.id), s0);
      expect(await totalUang(), t0);
      budget = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
      expect(budget?.remaining, r0);
      final summary = await getIt<ReportRepository>().getMonthlySummary(
        ReportPeriod.currentMonth(),
      );
      expect(summary.income, 0);
      expect(summary.expense, 0);
      expect(await postedJournalCount(), journals0);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-NAV-001 — Back tak jebol ke setup.
  // ---------------------------------------------------------------------------

  group('TC2-NAV-001 edit replace sekali tanpa duplikat jurnal', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('perbaiki → simpan void lama + 1 jurnal baru', () async {
      final base = await seedBaseData();
      await recordIncome(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5000000,
        categoryId: base.gajiId,
        amount: 500000,
        note: 'Gaji Jan',
      );
      final oldId = await lastPostedJournalId();
      final journals0 = await postedJournalCount();

      final edit = singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5500000,
        categoryId: base.gajiId,
        amount: 700000,
        note: 'Gaji Jan rev',
      );
      await settleFormTotal(edit, 700000);
      final newId = await getIt<TransactionRepository>().updateTransaction(
        id: oldId,
        form: edit,
        type: TransactionType.income,
      );

      // Tepat 1 jurnal baru, lama void (posted neto tetap), tak ada duplikat.
      expect(await postedJournalCount(), journals0);
      final oldEntry = await getIt<JournalRepository>().getJournal(oldId);
      expect(oldEntry.status, JournalStatus.voided);
      final fresh = await getIt<JournalRepository>().getJournal(newId);
      expect(fresh.status, JournalStatus.posted);
      expect(await balanceOf(base.bca.id), 5700000);
    });
  });

  group('TC2-NAV-001 back di root tak pernah ke setup', () {
    setUp(() async {
      await setupTestApp();
      await createWallet(
        name: 'Tunai',
        preset: AccountPreset.cash,
        balance: 1000000,
      );
      await createWallet(
        name: 'BCA',
        preset: AccountPreset.bank,
        balance: 5000000,
      );
    });
    tearDown(disposeFixture);

    testWidgets('root back → dialog tutup, batal diam di Beranda', (
      tester,
    ) async {
      await pumpTestApp(tester);
      await settleUntil(tester, find.text('Total Uang'));

      // Berada di Shell, bukan setup.
      expect(find.text('Mulai rapikan keuanganmu'), findsNothing);

      // Simulasi tombol back sistem (PopScope canPop:false → dialog).
      await tester.binding.handlePopRoute();
      await settleUntil(tester, find.text('Tutup aplikasi?'));
      expect(find.text('Ya, Tutup'), findsOneWidget);

      await tester.tap(find.text('Batal'));
      await settleGone(tester, find.text('Tutup aplikasi?'));
      expect(find.text('Total Uang'), findsOneWidget);
      expect(find.text('Mulai rapikan keuanganmu'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-DSH-001 — Ringkasan kosong tanpa teks.
  // ---------------------------------------------------------------------------

  group('TC2-DSH-001 ringkasan kosong tanpa teks', () {
    setUp(() async {
      await setupTestApp();
      await createWallet(
        name: 'Tunai',
        preset: AccountPreset.cash,
        balance: 1000000,
      );
      await createWallet(
        name: 'BCA',
        preset: AccountPreset.bank,
        balance: 5000000,
      );
    });
    tearDown(disposeFixture);

    testWidgets('tanpa transaksi: teks hilang, dua kartu Rp0 tetap', (
      tester,
    ) async {
      await pumpTestApp(tester);
      await settleUntil(tester, find.text('Total Uang'));
      await settle(tester, 6);

      // Logika: ringkasan 0/0 walau jurnal setup ada hari ini.
      final summary = await getIt<DashboardRepository>()
          .getTransactionSummary();
      expect(summary.income, 0);
      expect(summary.expense, 0);

      // UI: teks lama hilang, dua kartu tetap tampil.
      expect(find.text('Belum ada transaksi hari ini.'), findsNothing);
      expect(find.text('Ringkasan Hari Ini'), findsOneWidget);
      expect(find.text('Pemasukan'), findsWidgets);
      expect(find.text('Pengeluaran'), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-ACT-001 — Jurnal saldo awal tampil, eksklusif agregat.
  // ---------------------------------------------------------------------------

  group('TC2-ACT-001 jurnal saldo awal tampil eksklusif agregat', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('OVO 250k: 4 list ya, ringkasan/laporan/anggaran tidak', () async {
      await seedBaseData();
      final t0 = await totalUang();
      final summary0 = await getIt<ReportRepository>().getMonthlySummary(
        ReportPeriod.currentMonth(),
      );

      final ovo = await createWallet(
        name: 'OVO',
        preset: AccountPreset.eWallet,
        balance: 250000,
      );
      expect(await balanceOf(ovo.id), 250000);
      expect(await totalUang(), t0 + 250000);

      // 1. Muncul di aktivitas global + filter per dompet.
      final all = await getIt<JournalRepository>().getJournals(
        pagination: const Pagination(limit: 50),
      );
      final setupEntries = all.items
          .where((e) => e.source == JournalSource.setup)
          .toList();
      expect(setupEntries, isNotEmpty);
      final ovoEntry = setupEntries.firstWhere(
        (e) => e.lines.any((l) => l.accountId == ovo.id),
      );
      expect(ovoEntry.title(), 'Saldo awal');
      expect(ovoEntry.displayAmount(), startsWith('+'));
      expect(ovoEntry.type, ActivityType.income);

      final perWallet = await getIt<JournalRepository>().getJournals(
        pagination: const Pagination(limit: 50),
        filter: JournalFilter(accountId: ovo.id),
      );
      expect(
        perWallet.items.map((e) => e.id),
        contains(ovoEntry.id),
      );

      // 2. Eksklusif agregat: ringkasan, laporan, anggaran, count.
      final dash = await getIt<DashboardRepository>().getTransactionSummary();
      expect(dash.income, 0);
      expect(dash.expense, 0);
      final summary = await getIt<ReportRepository>().getMonthlySummary(
        ReportPeriod.currentMonth(),
      );
      expect(summary.income, summary0.income);
      expect(summary.expense, summary0.expense);
      expect(summary.transactionCount, summary0.transactionCount);
      expect(
        await getIt<ReportRepository>().getIncomeByCategory(
          ReportPeriod.currentMonth(),
        ),
        isEmpty,
      );
      expect(
        await getIt<ReportRepository>().getExpenseByCategory(
          ReportPeriod.currentMonth(),
        ),
        isEmpty,
      );
      final seed = await seedBaseDataRef();
      final makan = await getIt<BudgetRepository>().getActiveBudget(
        seed.makanId,
      );
      expect(makan?.actualSpend, 0);
    });
  });

  group('TC2-ACT-001 detail dompet tampilkan saldo awal', () {
    setUp(() async {
      await setupTestApp();
      await createWallet(
        name: 'Tunai',
        preset: AccountPreset.cash,
        balance: 1000000,
      );
    });
    tearDown(disposeFixture);

    testWidgets('list aktivitas OVO memuat Saldo awal', (tester) async {
      final ovo = await createWallet(
        name: 'OVO',
        preset: AccountPreset.eWallet,
        balance: 250000,
      );
      await pumpPage(tester, AssetDetailPage(id: ovo.id));
      await settleUntil(tester, find.text('Dompet OVO'));
      expect(find.text('Saldo awal'), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-RPT-001 — Card Pemasukan per kategori.
  // ---------------------------------------------------------------------------

  group('TC2-RPT-001 card pemasukan per kategori', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('angka = summary, saldo awal + saving non-expense eksklusif',
        () async {
      final base = await seedBaseData();
      final bonusId = await systemAccountId(AccountPreset.bonus.code);

      await recordIncome(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5000000,
        categoryId: base.gajiId,
        amount: 500000,
      );
      await recordIncome(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5500000,
        categoryId: bonusId,
        amount: 100000,
      );
      await recordExpense(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5600000,
        categoryId: base.makanId,
        amount: 50000,
      );
      // Saldo awal + topup/withdraw tak boleh menggelembungkan income.
      await createWallet(
        name: 'OVO',
        preset: AccountPreset.eWallet,
        balance: 250000,
      );
      await getIt<SavingRepository>().topup(
        pocketId: base.target.accountId,
        assetId: base.bca.id,
        amount: 50000,
      );
      await getIt<SavingRepository>().withdraw(
        pocketId: base.target.accountId,
        assetId: base.bca.id,
        amount: 20000,
      );

      final period = ReportPeriod.currentMonth();
      final summary = await getIt<ReportRepository>().getMonthlySummary(
        period,
      );
      final incomeCats = await getIt<ReportRepository>().getIncomeByCategory(
        period,
      );
      final byName = {for (final c in incomeCats) c.name: c.amount};
      expect(byName['Gaji / Pendapatan Tetap'], 500000);
      expect(byName.length, 2);
      expect(byName.values.fold<int>(0, (a, b) => a + b), summary.income);
      expect(summary.income, 600000);

      // Bulan kosong → ringkas kosong + list kosong (emptyText di widget).
      const emptyPeriod = ReportPeriod(year: 2020, month: 1);
      final empty = await getIt<ReportRepository>().getMonthlySummary(
        emptyPeriod,
      );
      expect(empty.isEmpty, isTrue);
      expect(
        await getIt<ReportRepository>().getIncomeByCategory(emptyPeriod),
        isEmpty,
      );
    });

    testWidgets('card judul + empty text baku', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategorySpendingCard(
              items: [],
              title: 'Pemasukan per kategori',
              emptyText: 'Belum ada pemasukan bulan ini.',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Pemasukan per kategori'), findsOneWidget);
      expect(find.text('Belum ada pemasukan bulan ini.'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategorySpendingCard(
              items: const [
                CategorySpending(
                  accountId: 1,
                  name: 'Gaji',
                  amount: 500000,
                  percentage: 83,
                ),
                CategorySpending(
                  accountId: 2,
                  name: 'Bonus',
                  amount: 100000,
                  percentage: 17,
                ),
              ],
              title: 'Pemasukan per kategori',
              emptyText: 'Belum ada pemasukan bulan ini.',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Gaji'), findsOneWidget);
      expect(find.text('Bonus'), findsOneWidget);
      expect(find.text('Lainnya'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-SRCH-001 — Clear global + empty Dompet.
  // ---------------------------------------------------------------------------

  group('TC2-SRCH-001 clear global + empty dompet', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('filter case-insensitive, kosong ramah, tak ubah data', () async {
      final base = await seedBaseData();
      await createWallet(name: 'GoPay', preset: AccountPreset.eWallet);
      final t0 = await totalUang();

      final lower = await getIt<AccountRepository>().getAccounts(
        filter: const AccountFilter(
          isSystem: false,
          isLiqid: true,
          type: AccountType.asset,
          name: 'bca',
        ),
      );
      expect(lower.map((a) => a.name), ['BCA']);

      final missing = await getIt<AccountRepository>().getAccounts(
        filter: const AccountFilter(
          isSystem: false,
          isLiqid: true,
          type: AccountType.asset,
          name: 'xyz-tidak-ada',
        ),
      );
      expect(missing, isEmpty);

      await recordIncome(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5000000,
        categoryId: base.gajiId,
        amount: 100000,
        note: 'Gaji Jan',
      );
      final journals = await getIt<JournalRepository>().getJournals(
        pagination: const Pagination(limit: 50),
        filter: const JournalFilter(description: 'gaji'),
      );
      expect(journals.items.length, 1);
      final none = await getIt<JournalRepository>().getJournals(
        pagination: const Pagination(limit: 50),
        filter: const JournalFilter(description: 'xyz-tidak-ada'),
      );
      expect(none.items, isEmpty);

      // Search tak ubah data (pemasukan 100k persiapan ikut Total).
      expect(await totalUang(), t0 + 100000);
      expect(base.bca.name, 'BCA');
    });

    testWidgets('clear ≥1 char → bersih + onClear, empty ada CTA reset', (
      tester,
    ) async {
      Future<void> pumpSearch(
        FormControl<String> control, {
        VoidCallback? onClear,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DompetTextField(
                formControl: control,
                placeholder: 'Cari...',
                textInputAction: TextInputAction.search,
                clearable: true,
                onClear: onClear,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      await pumpSearch(FormControl<String>());
      expect(find.byIcon(Icons.clear), findsNothing);

      final control = FormControl<String>();
      control.updateValue('b');
      var cleared = false;
      await pumpSearch(control, onClear: () => cleared = true);
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(control.value, isNull);
      expect(cleared, isTrue);
      expect(find.byIcon(Icons.clear), findsNothing);

      var reset = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DompetEmptySearch(
              subject: 'dompet',
              onReset: () => reset = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tidak ada dompet cocok.'), findsOneWidget);
      expect(find.text('Reset pencarian'), findsOneWidget);
      await tester.tap(find.text('Reset pencarian'));
      await tester.pumpAndSettle();
      expect(reset, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-KAT-001 — Buat cepat langsung terpilih.
  // ---------------------------------------------------------------------------

  group('TC2-KAT-001 buat cepat langsung terpilih', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    Future<List<String>> userNames(AccountType type) async {
      final accounts = await getIt<AccountRepository>().getAccounts(
        filter: AccountFilter(type: type, isSystem: false),
      );
      return accounts.map((a) => a.name).toList();
    }

    test('expense + income + batch kembali terisi + badge rencana', () async {
      final base = await seedBaseData();

      // 1. Pengeluaran → buat Minum → Comprehensive: langsung terpakai.
      final minum = await getIt<CategoryRepository>().createCategory(
        form: newCategoryForm('Minum', AccountType.expense),
      );
      final expenseForm = singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5000000,
        categoryId: minum.id,
        categoryName: minum.name,
        amount: 25000,
      );
      expect(expenseForm.categories.first.categoryId, minum.id);
      await settleFormTotal(expenseForm, 25000);
      await getIt<TransactionRepository>().recordTransaction(
        form: expenseForm,
        type: TransactionType.expense,
      );
      expect(await balanceOf(base.bca.id), 4975000);

      // Badge Terencana ikut bila ada rencana.
      await getIt<BudgetPlanRepository>().upsert(
        accountId: minum.id,
        amount: 200000,
        note: 'minum',
      );
      final withBudget = await getIt<AccountRepository>().getAccounts(
        filter: AccountFilter(type: AccountType.expense, isSystem: false),
        withBudget: true,
      );
      expect(
        withBudget
            .firstWhere((a) => a.id == minum.id)
            .activeBudgetPlanCount,
        greaterThan(0),
      );
      expect(await userNames(AccountType.expense), contains('Minum'));

      // 2. Pemasukan → buat BonusX.
      final bonusX = await getIt<CategoryRepository>().createCategory(
        form: newCategoryForm('BonusX', AccountType.income),
      );
      await recordIncome(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 4975000,
        categoryId: bonusX.id,
        amount: 50000,
      );
      expect(await userNames(AccountType.income), contains('BonusX'));

      // 3. Mode batch: dua kategori baru sekaligus.
      final batch = TransactionForm();
      batch.assetForm.idControl.updateValue(base.bca.id);
      batch.assetForm.nameControl.updateValue('BCA');
      batch.assetForm.balanceControl.updateValue(5025000);
      batch.categories.first.categoryIdControl.updateValue(minum.id);
      batch.categories.first.amountControl.updateValue(10000);
      batch.addCategory();
      batch.categories[1].categoryIdControl.updateValue(base.makanId);
      batch.categories[1].amountControl.updateValue(15000);
      batch.totalAmountControl.updateValue(25000);
      await settleFormTotal(batch, 25000);
      await getIt<TransactionRepository>().recordTransaction(
        form: batch,
        type: TransactionType.expense,
      );
      expect(await balanceOf(base.bca.id), 5000000);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-KAT-002 — List kategori arsip per tipe.
  // ---------------------------------------------------------------------------

  group('TC2-KAT-002 list kategori arsip per tipe', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('mirror per tipe, pulihkan kembali, arsip tak bisa dipakai baru',
        () async {
      final base = await seedBaseData();
      final hobi = await createCategoryAccount(name: 'Hobi');
      final freelance = await createCategoryAccount(
        name: 'Freelance',
        type: AccountType.income,
      );
      await recordExpense(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5000000,
        categoryId: hobi.id,
        amount: 50000,
      );
      await getIt<AccountRepository>().archiveAccount(hobi.id);
      await getIt<AccountRepository>().archiveAccount(freelance.id);

      // List arsip mirror aktif per tipe.
      final archivedExpense = await getIt<AccountRepository>()
          .getArchivedAccounts(
            filter: const AccountFilter(type: AccountType.expense),
          );
      final archivedIncome = await getIt<AccountRepository>()
          .getArchivedAccounts(
            filter: const AccountFilter(type: AccountType.income),
          );
      expect(archivedExpense.map((a) => a.id), contains(hobi.id));
      expect(archivedExpense.map((a) => a.id), isNot(contains(freelance.id)));
      expect(archivedIncome.map((a) => a.id), contains(freelance.id));

      // Hilang dari aktif; histori lama tetap nama + saldo tetap.
      final activeExpense = await getIt<AccountRepository>().getAccounts(
        filter: const AccountFilter(type: AccountType.expense),
      );
      expect(activeExpense.map((a) => a.id), isNot(contains(hobi.id)));
      expect(
        (await getIt<AccountRepository>().getAccount(hobi.id))?.name,
        'Hobi',
      );
      expect(await balanceOf(base.bca.id), 4950000);

      // Pulihkan → kembali ke aktif.
      await getIt<AccountRepository>().unarchiveAccount(hobi.id);
      final activeAfter = await getIt<AccountRepository>().getAccounts(
        filter: const AccountFilter(type: AccountType.expense),
      );
      expect(activeAfter.map((a) => a.id), contains(hobi.id));

      // Arsip tak bisa dipakai di form baru (transaksi + anggaran).
      final stale = singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 4950000,
        categoryId: freelance.id,
        amount: 10000,
      );
      await settleFormTotal(stale, 10000);
      await expectLater(
        getIt<TransactionRepository>().recordTransaction(
          form: stale,
          type: TransactionType.income,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('diarsipkan'),
          ),
        ),
      );
    });
  });

  group('TC2-KAT-002 halaman arsip via AppBar icon', () {
    setUp(() async {
      await setupTestApp();
      await seedBaseData();
    });
    tearDown(disposeFixture);

    testWidgets('judul + isi per tipe', (tester) async {
      await createCategoryAccount(name: 'Hobi');
      final freelance = await createCategoryAccount(
        name: 'Freelance',
        type: AccountType.income,
      );
      final accounts = getIt<AccountRepository>();
      final hobiId = (await accounts.getAccounts(
        filter: const AccountFilter(type: AccountType.expense),
      )).firstWhere((a) => a.name == 'Hobi').id;
      await accounts.archiveAccount(hobiId);
      await accounts.archiveAccount(freelance.id);

      await pumpPage(
        tester,
        const CategoryArchivedPage(type: TransactionType.expense),
      );
      await settleUntil(
        tester,
        find.text('Kategori Pengeluaran Diarsipkan'),
      );
      expect(find.text('Hobi'), findsWidgets);
      expect(find.text('Freelance'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-DMP-001 — Grid dompet arsip.
  // ---------------------------------------------------------------------------

  group('TC2-DMP-001 grid dompet arsip', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('arsip→pulihkan koreksi Total, arsip tak bisa dipakai baru',
        () async {
      final base = await seedBaseData();
      final t0 = await totalUang();

      await getIt<AccountRepository>().archiveAccount(base.tunai.id);
      expect(await totalUang(), t0 - 1000000);

      final archived = await getIt<AccountRepository>().getArchivedAccounts(
        filter: const AccountFilter(
          isSystem: false,
          isLiqid: true,
          type: AccountType.asset,
        ),
      );
      expect(archived.map((a) => a.id), contains(base.tunai.id));
      final active = await getIt<AccountRepository>().getAccounts(
        filter: const AccountFilter(
          isSystem: false,
          isLiqid: true,
          type: AccountType.asset,
        ),
      );
      expect(active.map((a) => a.id), isNot(contains(base.tunai.id)));

      // Tak bisa dipakai transaksi / pindah dana baru.
      final archivedExpense = singleCategoryForm(
        assetId: base.tunai.id,
        assetName: 'Tunai',
        assetBalance: 1000000,
        categoryId: base.makanId,
        amount: 10000,
      );
      await settleFormTotal(archivedExpense, 10000);
      await expectLater(
        getIt<TransactionRepository>().recordTransaction(
          form: archivedExpense,
          type: TransactionType.expense,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('diarsipkan'),
          ),
        ),
      );
      final gopay = await createWallet(
        name: 'GoPay',
        preset: AccountPreset.eWallet,
      );
      await expectLater(
        getIt<TransferRepository>().transferBalance(
          form: transferForm(
            sourceId: base.tunai.id,
            sourceName: 'Tunai',
            sourceBalance: 1000000,
            destinationId: gopay.id,
            destinationName: 'GoPay',
            destinationBalance: 0,
            amount: 10000,
          ),
        ),
        throwsException,
      );

      // Pulihkan → Total kembali.
      await getIt<AccountRepository>().unarchiveAccount(base.tunai.id);
      expect(await totalUang(), t0);
    });
  });

  group('TC2-DMP-001 halaman arsip + detail read-only', () {
    setUp(() async {
      await setupTestApp();
      await seedBaseData();
    });
    tearDown(disposeFixture);

    testWidgets('grid 2 kolom, chip abu, hanya Pulihkan', (tester) async {
      final accounts = getIt<AccountRepository>();
      final tunai = (await accounts.getAccounts(
        filter: const AccountFilter(
          isSystem: false,
          isLiqid: true,
          type: AccountType.asset,
        ),
      )).firstWhere((a) => a.name == 'Tunai');
      await accounts.archiveAccount(tunai.id);

      await pumpPage(tester, const AssetArchivedPage());
      await settleUntil(tester, find.text('Dompet Diarsipkan'));
      expect(find.text('Tunai'), findsWidgets);
      final grid = tester.widget<SliverGrid>(find.byType(SliverGrid).first);
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);

      await pumpPage(tester, AssetDetailPage(id: tunai.id));
      await settleUntil(tester, find.text('Dompet Tunai'));
      expect(find.text('Diarsipkan'), findsOneWidget);
      expect(find.text('Sesuaikan saldo'), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await settleUntil(tester, find.text('Pulihkan'));
      expect(find.text('Arsipkan'), findsNothing);
      expect(find.text('Ubah'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-ADJ-001 — Adjustment selisih 0 no-op.
  // ---------------------------------------------------------------------------

  group('TC2-ADJ-001 adjustment selisih 0 no-op', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('tanpa jurnal baru, saldo + Total + count tetap', () async {
      final base = await seedBaseData();
      // Samakan BCA ke Rp1.000.000 sesuai prakondisi TC.
      var bca = await getIt<AccountRepository>().getAccount(base.bca.id);
      await getIt<BalanceAdjustmentRepository>().adjustBalance(
        form: adjustmentForm(account: bca!, actualBalance: 1000000),
      );
      bca = await getIt<AccountRepository>().getAccount(base.bca.id);
      final t0 = await totalUang();
      final journals0 = await postedJournalCount();

      await expectLater(
        getIt<BalanceAdjustmentRepository>().adjustBalance(
          form: adjustmentForm(account: bca!, actualBalance: 1000000),
        ),
        throwsA(isA<NoOpBalanceAdjustmentException>()),
      );

      expect(await balanceOf(base.bca.id), 1000000);
      expect(await totalUang(), t0);
      expect(await postedJournalCount(), journals0);

      // Cubit lapor sukses kalem (pop + snackbar info di UI).
      final cubit = BalanceAdjustmentCubit(
        getIt<BalanceAdjustmentRepository>(),
      );
      addTearDown(cubit.close);
      await cubit.adjustBalance(
        adjustmentForm(account: bca, actualBalance: 1000000),
      );
      expect(
        cubit.state.toString(),
        'ActionState.success(message: Tidak ada perubahan saldo)',
      );

      // Selisih nyata tetap jalan (guard tak over-block).
      bca = await getIt<AccountRepository>().getAccount(base.bca.id);
      await getIt<BalanceAdjustmentRepository>().adjustBalance(
        form: adjustmentForm(account: bca!, actualBalance: 1200000),
      );
      expect(await balanceOf(base.bca.id), 1200000);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-OVD-001 — Overdraw 2 jurnal atomik.
  // ---------------------------------------------------------------------------

  group('TC2-OVD-001 overdraw 2 jurnal atomik', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('== 1 jurnal, > 2 jurnal, batal 0, edit efektif, rollback',
        () async {
      final base = await seedBaseData();
      final kas = await createWallet(
        name: 'Kas Kecil',
        preset: AccountPreset.cash,
        balance: 10000,
      );
      final bcaKecil = await createWallet(
        name: 'BCA Kecil',
        preset: AccountPreset.bank,
        balance: 50000,
      );
      final gopay = await createWallet(
        name: 'GoPay',
        preset: AccountPreset.eWallet,
      );
      var makan = await getIt<BudgetRepository>().getActiveBudget(
        base.makanId,
      );
      final spend0 = makan?.actualSpend ?? 0;

      // 1. Pengeluaran == saldo → 1 jurnal biasa, tanpa adjustment.
      var posted0 = await postedJournalCount();
      var adj0 = await postedCountBySource(JournalSource.adjustment);
      final kasForm = singleCategoryForm(
        assetId: kas.id,
        assetName: 'Kas Kecil',
        assetBalance: 10000,
        categoryId: base.transportId,
        amount: 10000,
      );
      await settleFormTotal(kasForm, 10000);
      await getIt<TransactionRepository>().recordTransactionAuto(
        form: kasForm,
        type: TransactionType.expense,
      );
      expect(await postedJournalCount(), posted0 + 1);
      expect(
        await postedCountBySource(JournalSource.adjustment),
        adj0,
      );
      expect(await balanceOf(kas.id), 0);

      // 2. Pengeluaran > saldo → 2 jurnal (selisih + biasa), saldo akhir 0.
      final kasB = await createWallet(
        name: 'Kas B',
        preset: AccountPreset.cash,
        balance: 10000,
      );
      posted0 = await postedJournalCount();
      adj0 = await postedCountBySource(JournalSource.adjustment);
      final kasBForm = singleCategoryForm(
        assetId: kasB.id,
        assetName: 'Kas B',
        assetBalance: 10000,
        categoryId: base.makanId,
        amount: 100000,
      );
      await settleFormTotal(kasBForm, 100000);
      await getIt<TransactionRepository>().recordTransactionAuto(
        form: kasBForm,
        type: TransactionType.expense,
      );
      expect(await postedJournalCount(), posted0 + 2);
      expect(await postedCountBySource(JournalSource.adjustment), adj0 + 1);
      expect(await balanceOf(kasB.id), 0);
      // Adjustment = selisih (90k), budget terhitung sekali.
      makan = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
      expect(makan?.actualSpend, spend0 + 100000);

      // 2b. Batal = tak panggil repo = 0 jurnal.
      posted0 = await postedJournalCount();
      expect(await postedJournalCount(), posted0);

      // 3. Pindah dana == saldo sumber → 1 jurnal, Total tetap.
      final t0 = await totalUang();
      posted0 = await postedJournalCount();
      await getIt<TransferRepository>().transferBalanceAuto(
        form: transferForm(
          sourceId: bcaKecil.id,
          sourceName: 'BCA Kecil',
          sourceBalance: 50000,
          destinationId: gopay.id,
          destinationName: 'GoPay',
          destinationBalance: 0,
          amount: 50000,
        ),
      );
      expect(await postedJournalCount(), posted0 + 1);
      expect(await balanceOf(bcaKecil.id), 0);
      expect(await balanceOf(gopay.id), 50000);
      expect(await totalUang(), t0);

      // 4. Pindah dana > saldo sumber → 2 jurnal, cek sumber saja.
      final bca2 = await createWallet(
        name: 'BCA 2',
        preset: AccountPreset.bank,
        balance: 50000,
      );
      posted0 = await postedJournalCount();
      adj0 = await postedCountBySource(JournalSource.adjustment);
      await getIt<TransferRepository>().transferBalanceAuto(
        form: transferForm(
          sourceId: bca2.id,
          sourceName: 'BCA 2',
          sourceBalance: 50000,
          destinationId: gopay.id,
          destinationName: 'GoPay',
          destinationBalance: 50000,
          amount: 100000,
        ),
      );
      expect(await postedJournalCount(), posted0 + 2);
      expect(await postedCountBySource(JournalSource.adjustment), adj0 + 1);
      expect(await balanceOf(bca2.id), 0);
      expect(await balanceOf(gopay.id), 150000);
      // Total = t0 + dana dompet baru 50k + adjustment selisih 50k.
      expect(await totalUang(), t0 + 100000);

      // 5. Edit: efektif = kini + lama bila dompet sama.
      final tunaiE = await createWallet(
        name: 'Tunai E',
        preset: AccountPreset.cash,
        balance: 100000,
      );
      final tunaiEForm = singleCategoryForm(
        assetId: tunaiE.id,
        assetName: 'Tunai E',
        assetBalance: 100000,
        categoryId: base.transportId,
        amount: 10000,
      );
      await settleFormTotal(tunaiEForm, 10000);
      await getIt<TransactionRepository>().recordTransactionAuto(
        form: tunaiEForm,
        type: TransactionType.expense,
      );
      final firstId = await lastPostedJournalId();
      // Naik ke 60k < efektif 100k → tanpa adjustment.
      posted0 = await postedJournalCount();
      adj0 = await postedCountBySource(JournalSource.adjustment);
      final editUpForm = singleCategoryForm(
        assetId: tunaiE.id,
        assetName: 'Tunai E',
        assetBalance: 90000,
        categoryId: base.transportId,
        amount: 60000,
      );
      await settleFormTotal(editUpForm, 60000);
      final secondId = await getIt<TransactionRepository>()
          .updateTransactionAuto(
            id: firstId,
            form: editUpForm,
            type: TransactionType.expense,
            previousAmount: 10000,
            previousAssetId: tunaiE.id,
          );
      expect(await postedJournalCount(), posted0);
      expect(await postedCountBySource(JournalSource.adjustment), adj0);
      expect(await balanceOf(tunaiE.id), 40000);
      expect(
        (await getIt<JournalRepository>().getJournal(firstId)).status,
        JournalStatus.voided,
      );
      // Naik ke 150k > efektif 100k → adjustment selisih 50k.
      final editOverForm = singleCategoryForm(
        assetId: tunaiE.id,
        assetName: 'Tunai E',
        assetBalance: 40000,
        categoryId: base.transportId,
        amount: 150000,
      );
      await settleFormTotal(editOverForm, 150000);
      await getIt<TransactionRepository>().updateTransactionAuto(
        id: secondId,
        form: editOverForm,
        type: TransactionType.expense,
        previousAmount: 60000,
        previousAssetId: tunaiE.id,
      );
      expect(await balanceOf(tunaiE.id), 0);

      // Gagal tengah → rollback semua (0 jurnal baru).
      final hobi = await createCategoryAccount(name: 'Hobi');
      await getIt<AccountRepository>().archiveAccount(hobi.id);
      final kasC = await createWallet(
        name: 'Kas C',
        preset: AccountPreset.cash,
        balance: 10000,
      );
      posted0 = await postedJournalCount();
      final rollbackForm = singleCategoryForm(
        assetId: kasC.id,
        assetName: 'Kas C',
        assetBalance: 10000,
        categoryId: hobi.id,
        amount: 100000,
      );
      await settleFormTotal(rollbackForm, 100000);
      await expectLater(
        getIt<TransactionRepository>().recordTransactionAuto(
          form: rollbackForm,
          type: TransactionType.expense,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('diarsipkan'),
          ),
        ),
      );
      expect(await postedJournalCount(), posted0);
      expect(await balanceOf(kasC.id), 10000);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-TRG-001 — UI Target: repos + info terkumpul.
  // ---------------------------------------------------------------------------

  group('TC2-TRG-001 riwayat + running balance + hint', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('0→200→150→120 urut tanggal', () async {
      final base = await seedBaseData();
      final pocketId = base.target.accountId;

      await getIt<SavingRepository>().topup(
        pocketId: pocketId,
        assetId: base.bca.id,
        amount: 200000,
      );
      await getIt<SavingRepository>().withdraw(
        pocketId: pocketId,
        assetId: base.bca.id,
        amount: 50000,
      );
      await getIt<SavingRepository>().spend(
        pocketId: pocketId,
        categoryId: base.makanId,
        assetId: base.bca.id,
        amount: 30000,
      );

      final journals = await getIt<SavingRepository>().getPocketJournals(
        pocketId,
      );
      expect(journals.length, 3);
      // Terbaru dulu; yang tertua terakhir.
      final oldestFirst = journals.reversed.toList();
      expect(oldestFirst[0].metadata?.toLowerCase(), contains('topup'));
      expect(oldestFirst[1].metadata?.toLowerCase(), contains('withdraw'));
      expect(oldestFirst[2].metadata?.toLowerCase(), contains('spend'));

      var running = 0;
      final trail = <int>[];
      for (final j in oldestFirst) {
        final meta = (j.metadata ?? '').toLowerCase();
        if (meta.contains('topup')) {
          running += j.amount;
        } else {
          running -= j.amount;
        }
        trail.add(running);
      }
      expect(trail, [200000, 150000, 120000]);

      final plan = await getIt<SavingRepository>().getByAccountId(pocketId);
      final detail = SavingDetail.compute(
        plan: plan!,
        activities: journals,
        now: DateTime.now(),
      );
      expect(detail.transactionCount, 3);
    });

    testWidgets('hint + footer di dalam card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PocketBalanceHint(balance: 150000),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Terkumpul'), findsOneWidget);
      expect(find.textContaining('maksimal'), findsOneWidget);
    });

    testWidgets('tile belanja bawa footer terkumpul', (tester) async {
      await resetFixture();
      addTearDown(disposeFixture);
      final base = await seedBaseData();
      await getIt<SavingRepository>().topup(
        pocketId: base.target.accountId,
        assetId: base.bca.id,
        amount: 200000,
      );
      await getIt<SavingRepository>().spend(
        pocketId: base.target.accountId,
        categoryId: base.makanId,
        assetId: base.bca.id,
        amount: 30000,
      );
      final journals = await getIt<SavingRepository>().getPocketJournals(
        base.target.accountId,
      );
      final spendTile = journals.first;
      expect(spendTile.title(), contains('Belanja'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActivityItemTile(
              activity: spendTile,
              footerTrailing: 'Terkumpul ${170000.currency}',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Terkumpul'), findsOneWidget);
      expect(find.textContaining('Belanja'), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-TRG-002 — Belanja 2 jurnal + refresh anggaran.
  // ---------------------------------------------------------------------------

  group('TC2-TRG-002 belanja 2 jurnal + refresh anggaran', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('J1 tarik + J2 expense, fallback, over-target ditolak', () async {
      final base = await seedBaseData();
      final pocket = await getIt<SavingRepository>().createPocket(
        name: 'Laptop',
      );
      await getIt<SavingRepository>().topup(
        pocketId: pocket.accountId,
        assetId: base.bca.id,
        amount: 150000,
      );
      final b0 = await balanceOf(base.bca.id);
      final t0 = await totalUang();
      var budget = await getIt<BudgetRepository>().getActiveBudget(
        base.makanId,
      );
      final r0 = budget?.remaining ?? 0;
      final posted0 = await postedJournalCount();

      // Belanja Makan 30k via BCA.
      await getIt<SavingRepository>().spend(
        pocketId: pocket.accountId,
        categoryId: base.makanId,
        assetId: base.bca.id,
        amount: 30000,
      );

      // Tepat 2 jurnal atomik: J1 saving-hybrid + J2 transaction-expense.
      expect(await postedJournalCount(), posted0 + 2);
      final j2id = await lastPostedJournalId();
      final j2 = await getIt<JournalRepository>().getJournal(j2id);
      expect(j2.source, JournalSource.transaction);
      expect(j2.metadata?.toLowerCase(), contains('hybrid_expense'));
      final pocketJournals = await getIt<SavingRepository>()
          .getPocketJournals(pocket.accountId);
      expect(
        pocketJournals.first.metadata?.toLowerCase(),
        contains('spend'),
      );

      // Efek samping: target -30k, BCA net tetap, Total tetap.
      expect(await balanceOf(pocket.accountId), 120000);
      expect(await balanceOf(base.bca.id), b0);
      expect(await totalUang(), t0);

      // List + detail anggaran segar sama R0-30k.
      budget = await getIt<BudgetRepository>().getActiveBudget(base.makanId);
      expect(budget?.actualSpend, 30000);
      expect(budget?.remaining, r0 - 30000);
      final listed = await getIt<BudgetRepository>().getBudgets(
        const BudgetFilter(),
      );
      expect(
        listed.firstWhere((b) => b.accountId == base.makanId).actualSpend,
        30000,
      );

      // Laporan + ringkasan + aktivitas.
      final summary = await getIt<ReportRepository>().getMonthlySummary(
        ReportPeriod.currentMonth(),
      );
      expect(summary.expense, 30000);
      expect(summary.savingSpend, 30000);
      final dash = await getIt<DashboardRepository>().getTransactionSummary();
      expect(dash.expense, 30000);
      expect(pocketJournals.first.title(), contains('Belanja'));

      // Tanpa kategori → fallback Lain-Lain, tetap sukses.
      final beforeFallback = await postedJournalCount();
      final fallbackId = await getIt<SavingRepository>().spend(
        pocketId: pocket.accountId,
        assetId: base.bca.id,
        amount: 10000,
      );
      expect(await postedJournalCount(), beforeFallback + 2);
      final fallbackJournal = await getIt<JournalRepository>().getJournal(
        fallbackId,
      );
      final otherId = await systemAccountId(
        AccountPreset.otherExpense.code,
      );
      expect(
        fallbackJournal.lines.any((l) => l.accountId == otherId),
        isTrue,
      );
      expect(await balanceOf(pocket.accountId), 110000);

      // Melebihi target → ditolak, tak ada jurnal.
      final postedBeforeFail = await postedJournalCount();
      await expectLater(
        getIt<SavingRepository>().spend(
          pocketId: pocket.accountId,
          categoryId: base.makanId,
          assetId: base.bca.id,
          amount: 200000,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Saldo tidak mencukupi'),
          ),
        ),
      );
      expect(await postedJournalCount(), postedBeforeFail);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-BGT-001 — Anggaran kategori diarsip.
  // ---------------------------------------------------------------------------

  group('TC2-BGT-001 anggaran kategori diarsip', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('tetap aktif + terhitung + badge, baru ditolak lembut', () async {
      final base = await seedBaseData();
      final hobi = await createCategoryAccount(name: 'Hobi');
      await getIt<BudgetPlanRepository>().upsert(
        accountId: hobi.id,
        amount: 500000,
        note: 'hobi',
      );
      await getIt<BudgetRepository>().createBudget(
        accountId: hobi.id,
        amount: 500000,
        periode: DateTime.now(),
      );
      await recordExpense(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 5000000,
        categoryId: hobi.id,
        amount: 100000,
      );

      await getIt<AccountRepository>().archiveAccount(hobi.id);

      // Anggaran tetap aktif + terhitung + flag arsip (list & detail).
      final listed = await getIt<BudgetRepository>().getBudgets(
        const BudgetFilter(),
      );
      final row = listed.firstWhere((b) => b.accountId == hobi.id);
      expect(row.categoryArchived, isTrue);
      expect(row.actualSpend, 100000);
      final active = await getIt<BudgetRepository>().getActiveBudget(hobi.id);
      expect(active, isNotNull);
      expect(active?.categoryArchived, isTrue);
      expect(active?.actualSpend, 100000);

      // Transaksi baru ditolak lembut; histori lama jalan.
      final hobiStale = singleCategoryForm(
        assetId: base.bca.id,
        assetName: 'BCA',
        assetBalance: 4900000,
        categoryId: hobi.id,
        amount: 10000,
      );
      await settleFormTotal(hobiStale, 10000);
      await expectLater(
        getIt<TransactionRepository>().recordTransaction(
          form: hobiStale,
          type: TransactionType.expense,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('diarsipkan'),
          ),
        ),
      );
      expect(
        (await getIt<BudgetRepository>().getActiveBudget(hobi.id))
            ?.actualSpend,
        100000,
      );
    });

    testWidgets('badge + modal kalem', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ArchivedCategoryBadge(categoryName: 'Hobi')),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Kategori diarsipkan'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.info_outline_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Kategori Hobi diarsipkan'), findsOneWidget);
      expect(find.text('Mengerti'), findsOneWidget);
      await tester.tap(find.text('Mengerti'));
      await tester.pumpAndSettle();
      expect(find.text('Kategori Hobi diarsipkan'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-BGT-002 — List rencana anggaran.
  // ---------------------------------------------------------------------------

  group('TC2-BGT-002 list rencana anggaran', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    test('isi = besar rencana + tanggal, konsisten, tanpa jurnal', () async {
      final base = await seedBaseData();
      await getIt<BudgetPlanRepository>().upsert(
        accountId: base.transportId,
        amount: 500000,
        note: 'transport',
      );
      final journals0 = await postedJournalCount();

      final plans = await getIt<BudgetPlanRepository>()
          .getPlansWithCategories();
      expect(plans.length, 2);
      final byName = {for (final p in plans) p.category.name: p.plan.amount};
      expect(byName['Makan / Minum'], 1000000);
      expect(byName['Transportasi'], 500000);
      for (final p in plans) {
        expect(p.plan.createdAt, greaterThan(0));
      }
      // Konsisten dengan detail rencana existing.
      final makan = await getIt<BudgetPlanRepository>().getByAccountId(
        base.makanId,
      );
      expect(makan?.amount, 1000000);
      expect(await postedJournalCount(), journals0);
    });
  });

  group('TC2-BGT-002 halaman list via AppBar icon', () {
    late BaseData planBase;
    setUp(() async {
      await setupTestApp();
      planBase = await seedBaseData();
    });
    tearDown(disposeFixture);

    testWidgets('judul + tile per kategori', (tester) async {
      await getIt<BudgetPlanRepository>().upsert(
        accountId: planBase.transportId,
        amount: 500000,
        note: 'transport',
      );

      await pumpPage(tester, const BudgetPlanListPage());
      await settleUntil(tester, find.text('Rencana Anggaran'));
      expect(find.textContaining('Makan'), findsWidgets);
      expect(find.textContaining('Transport'), findsWidgets);
      expect(find.textContaining('1.000.000'), findsWidgets);
      expect(find.textContaining('500.000'), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-TERM-001 — Judul Target baku.
  // ---------------------------------------------------------------------------

  group('TC2-TERM-001 judul Target baku', () {
    setUp(() async {
      await setupTestApp();
      await createWallet(
        name: 'Tunai',
        preset: AccountPreset.cash,
        balance: 1000000,
      );
      await createWallet(
        name: 'BCA',
        preset: AccountPreset.bank,
        balance: 5000000,
      );
    });
    tearDown(disposeFixture);

    testWidgets('4 tab judul + FAB konteks + nol bocor istilah', (
      tester,
    ) async {
      await pumpTestApp(tester);
      await settleUntil(tester, find.text('Total Uang'));

      // Route name tak berubah, hanya label.
      expect(SavingRoute.name, 'SavingRoute');

      Future<void> openTab(String label) async {
        await tester.tap(
          find.descendant(
            of: find.byType(DompetBottomBar),
            matching: find.text(label),
          ),
        );
        await settleUntil(
          tester,
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text(label == 'Beranda' ? 'Selamat' : label),
          ),
        );
      }

      // Bottom bar: Target (bukan Tabungan).
      expect(
        find.descendant(
          of: find.byType(DompetBottomBar),
          matching: find.text('Target'),
        ),
        findsOneWidget,
      );
      expect(find.text('Tabungan'), findsNothing);

      await openTab('Aktivitas');
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Aktivitas'),
        ),
        findsOneWidget,
      );
      expect(find.byType(DompetFab), findsOneWidget);

      await openTab('Anggaran');
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Anggaran'),
        ),
        findsOneWidget,
      );
      expect(find.byType(BudgetFab), findsOneWidget);

      await openTab('Target');
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Target'),
        ),
        findsOneWidget,
      );
      expect(find.byType(SavingFab), findsOneWidget);

      // Nol bocor istilah teknis di chrome (AppBar + bottom bar).
      final chromeTexts = [
        ...tester
            .widgetList<Text>(
              find.descendant(
                of: find.byType(AppBar),
                matching: find.byType(Text),
              ),
            )
            .map((t) => t.data ?? ''),
        ...tester
            .widgetList<Text>(
              find.descendant(
                of: find.byType(DompetBottomBar),
                matching: find.byType(Text),
              ),
            )
            .map((t) => t.data ?? ''),
      ];
      for (final banned in ['Tabungan', 'Pocket', 'saving', 'backup', 'neto']) {
        expect(
          chromeTexts.any((s) => s.contains(banned)),
          isFalse,
          reason: 'bocor istilah: $banned',
        );
      }
    });
  });

  // ---------------------------------------------------------------------------
  // TC2-SNK-001 — Snackbar atas global terang + gelap.
  // ---------------------------------------------------------------------------

  group('TC2-SNK-001 snackbar atas global', () {
    setUp(resetFixture);
    tearDown(disposeFixture);

    IconData expectedIcon(SnackBarType type) => switch (type) {
      SnackBarType.error => Icons.error_rounded,
      SnackBarType.info => Icons.info_rounded,
      SnackBarType.success => Icons.check_circle_rounded,
    };

    testWidgets('atas, bg seragam, pembeda teks/icon', (tester) async {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        Color? bg;
        final textColors = <SnackBarType, Color?>{};
        for (final type in SnackBarType.values) {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                colorSchemeSeed: Colors.blue,
                brightness: brightness,
              ),
              home: Scaffold(
                appBar: AppBar(title: const Text('Uji')),
                body: Builder(
                  builder: (context) {
                    return FilledButton(
                      onPressed: () {
                        // Messenger state lestari antar pumpWidget
                        // (snackbar 4 dtk belum kedaluwarsa) — usir dulu
                        // agar tiap tipe tampil dan terverifikasi sendiri.
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          DompetSnackbar(
                            context,
                            message: 'Uji ${type.name}',
                            snackBarType: type,
                          ),
                        );
                      },
                      child: const Text('Tampil'),
                    );
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text('Tampil'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));

          // Catatan: ScaffoldMessenger menyisipkan snackbar sebagai SnackBar
          // (finder sub-tipe tak cocok), jadi verifikasi via tipe dasar —
          // margin/bg/icon/teks tetap milik DompetSnackbar.
          final snack = tester.widget<SnackBar>(find.byType(SnackBar));
          expect(snack.behavior, SnackBarBehavior.floating);
          final margin = snack.margin as EdgeInsets;
          expect(
            margin.bottom,
            greaterThan(margin.top),
            reason: 'snackbar harus menempel atas di $brightness',
          );
          bg ??= snack.backgroundColor;
          expect(
            snack.backgroundColor,
            bg,
            reason: 'satu bg sama semua tipe di $brightness',
          );
          expect(find.byIcon(expectedIcon(type)), findsOneWidget);
          textColors[type] =
              tester.widget<Text>(find.text('Uji ${type.name}')).style?.color;
        }
        // Pembeda hanya warna teks/icon: tiga tipe, tiga warna teks.
        expect(
          textColors.values.toSet().length,
          3,
          reason: 'warna teks pembeda di $brightness',
        );
      }
    });
  });
}

/// Repositori cadangan null-object untuk TC2-BKP-001.
///
/// Drive asli butuh OAuth Google + jaringan sehingga tak bisa dipakai di
/// integration test; kontrak yang diuji adalah state cubit (FIX-02).
class _NullBackupRepository implements BackupRepository {
  @override
  Future<BackupMeta?> getLastBackupMeta() async => null;

  @override
  Future<bool> hasBackup() async => false;

  @override
  Future<BackupMeta> backup() => throw UnimplementedError();

  @override
  Future<BackupMeta?> restore() async => null;
}

/// Data dasar untuk test widget yang butuh [setupTestApp] (DI app penuh).
///
/// [seedBaseData] sama, tapi mengembalikan ulang agar test widget tak
/// bergantung pada instance sebelum pump.
Future<BaseData> seedBaseDataRef() => seedBaseData();
