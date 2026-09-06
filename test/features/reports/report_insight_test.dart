import 'package:dompet_app/features/reports/models/category_spending.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:dompet_app/features/reports/models/period_comparison.dart';
import 'package:dompet_app/features/reports/models/report_insight.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:flutter_test/flutter_test.dart';

const _sep = ReportPeriod(year: 2026, month: 9);
const _aug = ReportPeriod(year: 2026, month: 8);
const _jul = ReportPeriod(year: 2026, month: 7);

MonthlySummary _summary({
  required ReportPeriod period,
  int income = 0,
  int expense = 0,
  int txCount = 0,
  int topup = 0,
  int withdraw = 0,
}) {
  return MonthlySummary(
    period: period,
    income: income,
    expense: expense,
    transactionCount: txCount,
    savingTopup: topup,
    savingWithdraw: withdraw,
  );
}

void main() {
  group('ReportInsight.generate', () {
    test('bulan kosong -> satu ajakan', () {
      final current = _summary(period: _sep);
      final insights = ReportInsight.generate(
        current: current,
        comparison: PeriodComparison(
          current: current,
          previous: _summary(period: _aug),
        ),
        trend: const [],
        categories: const [],
      );
      expect(insights.length, 1);
      expect(insights.single.kind, InsightKind.info);
      expect(insights.single.message, contains('Belum ada transaksi'));
    });

    test('surplus + di bawah rata-rata + kategori + pemasukan naik + alokasi target', () {
      final current = _summary(
        period: _sep,
        income: 8000000,
        expense: 5700000,
        txCount: 5,
        topup: 2000000,
      );
      final previous = _summary(period: _aug, income: 7000000, expense: 6200000);
      final insights = ReportInsight.generate(
        current: current,
        comparison: PeriodComparison(current: current, previous: previous),
        trend: [
          _summary(period: _jul, income: 7000000, expense: 6000000),
          previous,
          current,
        ],
        categories: const [
          CategorySpending(
            accountId: 1,
            name: 'Makanan',
            amount: 1800000,
            percentage: 31.5,
          ),
        ],
      );

      expect(
        insights.map((e) => e.message),
        [
          contains('surplus'),
          contains('di bawah rata-rata'),
          contains('Makanan'),
          contains('Pemasukan naik'),
          contains('dialokasikan ke target'),
        ],
      );
      expect(insights[0].kind, InsightKind.positive);
      expect(insights[2].kind, InsightKind.info);
    });

    test('pengeluaran melebihi pemasukan + di atas rata-rata', () {
      final current = _summary(period: _sep, income: 3000000, expense: 5000000);
      final previous = _summary(period: _aug, income: 8000000, expense: 4000000);
      final insights = ReportInsight.generate(
        current: current,
        comparison: PeriodComparison(current: current, previous: previous),
        trend: [previous, current],
        categories: const [],
      );

      expect(insights[0].kind, InsightKind.negative);
      expect(insights[0].message, contains('Pengeluaran melebihi pemasukan'));
      expect(insights[1].message, contains('di atas rata-rata'));
      // Pemasukan turun 62%.
      expect(insights.any((e) => e.message.contains('Pemasukan turun')), isTrue);
    });

    test('tanpa histori -> tanpa pesan rata-rata', () {
      final current = _summary(period: _sep, income: 5000000, expense: 1000000);
      final insights = ReportInsight.generate(
        current: current,
        comparison: PeriodComparison(
          current: current,
          previous: _summary(period: _aug),
        ),
        trend: [current],
        categories: const [],
      );
      expect(
        insights.any((e) => e.message.contains('rata-rata')),
        isFalse,
      );
    });

    test('tanpa aktivitas alokasi -> tanpa pesan target', () {
      final current = _summary(period: _sep, income: 5000000, expense: 1000000);
      final insights = ReportInsight.generate(
        current: current,
        comparison: PeriodComparison(
          current: current,
          previous: _summary(period: _aug, income: 5000000, expense: 1000000),
        ),
        trend: const [],
        categories: const [],
      );
      expect(
        insights.any((e) => e.message.contains('dialokasikan')),
        isFalse,
      );
    });
  });
}
