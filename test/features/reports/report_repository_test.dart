import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/reports/models/category_spending.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'report_test_helpers.dart';

void main() {
  group('ReportRepository.getMonthlySummary', () {
    test('agregasi September: income 8jt, expense 5,7jt', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final salary = await accountId(db, '401.0001');
      final food = await accountId(db, '501.0001');
      final transport = await accountId(db, '501.0003');

      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 3),
        assetId: cash,
        categoryId: salary,
        amount: 8000000,
        isExpense: false,
      );
      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 10),
        assetId: cash,
        categoryId: food,
        amount: 4800000,
        isExpense: true,
      );
      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 12),
        assetId: cash,
        categoryId: transport,
        amount: 900000,
        isExpense: true,
      );
      // Transaksi Agustus tidak boleh ikut.
      await insertTransaction(
        db: db,
        date: DateTime(2026, 8, 20),
        assetId: cash,
        categoryId: food,
        amount: 9999999,
        isExpense: true,
      );

      const period = ReportPeriod(year: 2026, month: 9);
      final summary = await repo.getMonthlySummary(period);

      expect(summary.income, 8000000);
      expect(summary.expense, 5700000);
      expect(summary.net, 2300000);
      expect(summary.transactionCount, 3);
    });

    test('transfer dan adjustment dikecualikan', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final food = await accountId(db, '501.0001');

      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 5),
        assetId: cash,
        categoryId: food,
        amount: 1000000,
        isExpense: true,
      );
      // Transfer antar dompet: tidak boleh dihitung sebagai expense.
      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 6),
        assetId: cash,
        categoryId: food,
        amount: 5000000,
        isExpense: true,
        source: JournalSource.transfer,
      );
      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 7),
        assetId: cash,
        categoryId: food,
        amount: 7000000,
        isExpense: true,
        source: JournalSource.adjustment,
      );

      const period = ReportPeriod(year: 2026, month: 9);
      final summary = await repo.getMonthlySummary(period);

      expect(summary.expense, 1000000);
      expect(summary.transactionCount, 1);
    });

    test('bulan kosong -> nol, comparison null yang aman', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      const period = ReportPeriod(year: 2026, month: 9);
      final summary = await repo.getMonthlySummary(period);
      expect(summary.isEmpty, isTrue);

      final comparison = await repo.getComparison(period);
      // Tanpa baseline bulan lalu: label null (banner netral),
      // meski sama-sama kosong. Nilai persen murni tetap 0.
      expect(comparison.expenseChangePercent, 0);
      expect(comparison.expenseLabel, isNull);
    });

    test('comparison September vs Agustus: expense turun ~8%', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final food = await accountId(db, '501.0001');

      await insertTransaction(
        db: db,
        date: DateTime(2026, 8, 10),
        assetId: cash,
        categoryId: food,
        amount: 6200000,
        isExpense: true,
      );
      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 10),
        assetId: cash,
        categoryId: food,
        amount: 5700000,
        isExpense: true,
      );

      const period = ReportPeriod(year: 2026, month: 9);
      final comparison = await repo.getComparison(period);
      expect(
        comparison.expenseChangePercent,
        closeTo(-8.06, 0.01),
      );
      expect(comparison.expenseLabel, 'turun 8%');
    });
  });

  group('ReportRepository tabungan', () {
    test('topup bukan expense: tercatat di neto, rekonsiliasi exact', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final salary = await accountId(db, '401.0001');
      final food = await accountId(db, '501.0001');
      final pocket = await createPocketAccount(db);

      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 3),
        assetId: cash,
        categoryId: salary,
        amount: 8000000,
        isExpense: false,
      );
      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 10),
        assetId: cash,
        categoryId: food,
        amount: 5000000,
        isExpense: true,
      );
      await insertSaving(
        db: db,
        date: DateTime(2026, 9, 15),
        pocketId: pocket,
        assetId: cash,
        amount: 2000000,
        tx: SavingTxType.topup,
      );

      const period = ReportPeriod(year: 2026, month: 9);
      final summary = await repo.getMonthlySummary(period);

      expect(summary.income, 8000000);
      // Topup tidak menggelembungkan expense maupun jumlah transaksi.
      expect(summary.expense, 5000000);
      expect(summary.transactionCount, 2);
      expect(summary.savingTopup, 2000000);
      expect(summary.savingWithdraw, 0);
      expect(summary.savingSpend, 0);
      expect(summary.netSaving, 2000000);
      // 8jt − 5jt − 2jt terkunci = +1jt perubahan uang aktif.
      expect(summary.liquidChange, 1000000);
    });

    test('spend dari pocket ikut expense, neto = delta pocket', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final food = await accountId(db, '501.0001');
      final pocket = await createPocketAccount(db);

      await insertSaving(
        db: db,
        date: DateTime(2026, 9, 5),
        pocketId: pocket,
        assetId: cash,
        amount: 2000000,
        tx: SavingTxType.topup,
      );
      await insertSaving(
        db: db,
        date: DateTime(2026, 9, 20),
        pocketId: pocket,
        categoryId: food,
        amount: 500000,
        tx: SavingTxType.spend,
      );

      const period = ReportPeriod(year: 2026, month: 9);
      final summary = await repo.getMonthlySummary(period);

      // Belanja dari pocket adalah konsumsi: wajib masuk expense.
      expect(summary.expense, 500000);
      expect(summary.savingTopup, 2000000);
      expect(summary.savingSpend, 500000);
      expect(summary.netSaving, 1500000);
      // Uang aktif hanya berkurang 2jt (saat topup); spend tidak
      // menyentuh dompet cair: net(−500rb) − neto(1,5jt) = −2jt.
      expect(summary.liquidChange, -2000000);
    });

    test('withdraw bukan income, mengurangi neto', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final pocket = await createPocketAccount(db);

      await insertSaving(
        db: db,
        date: DateTime(2026, 8, 5),
        pocketId: pocket,
        assetId: cash,
        amount: 2000000,
        tx: SavingTxType.topup,
      );
      await insertSaving(
        db: db,
        date: DateTime(2026, 9, 6),
        pocketId: pocket,
        assetId: cash,
        amount: 1000000,
        tx: SavingTxType.withdraw,
      );

      const period = ReportPeriod(year: 2026, month: 9);
      final summary = await repo.getMonthlySummary(period);

      // Penarikan kembali bukan pemasukan.
      expect(summary.income, 0);
      expect(summary.savingTopup, 0);
      expect(summary.savingWithdraw, 1000000);
      expect(summary.netSaving, -1000000);
      expect(summary.liquidChange, 1000000);
    });
  });

  group('ReportRepository.getExpenseByCategory', () {
    test('urut terbesar + persen benar', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final food = await accountId(db, '501.0001');
      final transport = await accountId(db, '501.0003');
      final entertainment = await accountId(db, '501.0005');

      for (final (category, amount) in [
        (food, 1800000),
        (transport, 900000),
        (entertainment, 500000),
      ]) {
        await insertTransaction(
          db: db,
          date: DateTime(2026, 9, 10),
          assetId: cash,
          categoryId: category,
          amount: amount,
          isExpense: true,
        );
      }
      // Beda bulan tidak ikut.
      await insertTransaction(
        db: db,
        date: DateTime(2026, 8, 10),
        assetId: cash,
        categoryId: food,
        amount: 9999999,
        isExpense: true,
      );

      final items = await repo.getExpenseByCategory(
        const ReportPeriod(year: 2026, month: 9),
      );

      expect(items.map((e) => e.amount), [1800000, 900000, 500000]);
      expect(items.first.name, isNotEmpty);
      expect(items[0].percentage, closeTo(56.25, 0.01));
      expect(items[1].percentage, closeTo(28.125, 0.01));
      expect(items[2].percentage, closeTo(15.625, 0.01));
      final totalPct = items.fold<double>(0, (s, e) => s + e.percentage);
      expect(totalPct, closeTo(100, 0.01));
    });

    test('spend dari pocket masuk kategorinya, pocket tak muncul', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final food = await accountId(db, '501.0001');
      final pocket = await createPocketAccount(db);

      await insertSaving(
        db: db,
        date: DateTime(2026, 9, 5),
        pocketId: pocket,
        assetId: cash,
        amount: 2000000,
        tx: SavingTxType.topup,
      );
      await insertSaving(
        db: db,
        date: DateTime(2026, 9, 20),
        pocketId: pocket,
        categoryId: food,
        amount: 500000,
        tx: SavingTxType.spend,
      );

      final items = await repo.getExpenseByCategory(
        const ReportPeriod(year: 2026, month: 9),
      );

      // Hanya kategori expense; topup (akun aset) tidak muncul.
      expect(items.length, 1);
      expect(items.single.amount, 500000);
      expect(items.single.percentage, 100);
    });

    test('bulan kosong -> list kosong', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final items = await repo.getExpenseByCategory(
        const ReportPeriod(year: 2026, month: 9),
      );
      expect(items, isEmpty);
    });

    test('topWithOthers: 8 kategori -> 6 + Lainnya', () {
      final all = List.generate(
        8,
        (i) => CategorySpending(
          accountId: i,
          name: 'K$i',
          amount: (8 - i) * 100,
          percentage: (8 - i) * 10.0,
        ),
      );
      final result = CategorySpending.topWithOthers(all);
      expect(result.length, 7);
      expect(result.last.name, 'Lainnya');
      expect(result.last.amount, 100 + 200);
      expect(result.last.percentage, closeTo(30, 0.001));
    });
  });

  group('ReportRepository.getTrend', () {
    test('3 bulan tertua->terbaru, bulan kosong nol', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final salary = await accountId(db, '401.0001');
      final food = await accountId(db, '501.0001');

      // Juli: hanya pemasukan.
      await insertTransaction(
        db: db,
        date: DateTime(2026, 7, 5),
        assetId: cash,
        categoryId: salary,
        amount: 8000000,
        isExpense: false,
      );
      // Agustus: hanya pengeluaran.
      await insertTransaction(
        db: db,
        date: DateTime(2026, 8, 10),
        assetId: cash,
        categoryId: food,
        amount: 6200000,
        isExpense: true,
      );
      // September: keduanya. Oktober kosong.
      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 3),
        assetId: cash,
        categoryId: salary,
        amount: 8000000,
        isExpense: false,
      );
      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 10),
        assetId: cash,
        categoryId: food,
        amount: 5700000,
        isExpense: true,
      );

      final trend = await repo.getTrend(
        const ReportPeriod(year: 2026, month: 10),
        months: 4,
      );

      expect(trend.map((e) => e.period.month), [7, 8, 9, 10]);
      expect(trend[0].income, 8000000);
      expect(trend[0].expense, 0);
      expect(trend[1].income, 0);
      expect(trend[1].expense, 6200000);
      expect(trend[2].income, 8000000);
      expect(trend[2].expense, 5700000);
      expect(trend[3].isEmpty, isTrue);
    });

    test('lewat batas tahun: Des -> Jan', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);

      final cash = await accountId(db, '101.0001');
      final food = await accountId(db, '501.0001');

      await insertTransaction(
        db: db,
        date: DateTime(2025, 12, 15),
        assetId: cash,
        categoryId: food,
        amount: 1000000,
        isExpense: true,
      );

      final trend = await repo.getTrend(
        const ReportPeriod(year: 2026, month: 1),
        months: 2,
      );

      expect(trend.map((e) => (e.period.year, e.period.month)), [
        (2025, 12),
        (2026, 1),
      ]);
      expect(trend[0].expense, 1000000);
      expect(trend[1].expense, 0);
    });
  });
}
