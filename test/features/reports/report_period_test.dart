import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:dompet_app/features/reports/models/period_comparison.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportPeriod', () {
    test('batas bulan September 2026', () {
      const period = ReportPeriod(year: 2026, month: 9);
      expect(period.startDate, DateTime(2026, 9, 1));
      // endOfMonth mempertahankan jam 23:59:59
      expect(period.endDate.year, 2026);
      expect(period.endDate.month, 9);
      expect(period.endDate.day, 30);
      expect(period.startEpoch < period.endEpoch, isTrue);
    });

    test('previous dari Januari mundur ke Desember tahun lalu', () {
      const period = ReportPeriod(year: 2026, month: 1);
      expect(period.previous, const ReportPeriod(year: 2025, month: 12));
    });

    test('next dari Desember maju ke Januari tahun depan', () {
      const period = ReportPeriod(year: 2026, month: 12);
      expect(period.next, const ReportPeriod(year: 2027, month: 1));
    });

    test('currentMonth dan previousMonth konsisten', () {
      final now = DateTime(2026, 9, 5);
      expect(
        ReportPeriod.currentMonth(now),
        const ReportPeriod(year: 2026, month: 9),
      );
      expect(
        ReportPeriod.previousMonth(now),
        const ReportPeriod(year: 2026, month: 8),
      );
    });
  });

  group('PeriodComparison.changePercent', () {
    test('turun 8%: 5,7jt vs 6,2jt', () {
      final pct = PeriodComparison.changePercent(
        current: 5700000,
        previous: 6200000,
      );
      expect(pct, closeTo(-8.06, 0.01));
    });

    test('nol vs nol -> 0, bukan null', () {
      expect(
        PeriodComparison.changePercent(current: 0, previous: 0),
        0,
      );
    });

    test('periode lalu kosong tapi sekarang ada -> null', () {
      expect(
        PeriodComparison.changePercent(current: 100000, previous: 0),
        isNull,
      );
      expect(PeriodComparison.changeLabel(null), isNull);
    });

    test('label Bahasa Indonesia', () {
      expect(PeriodComparison.changeLabel(-8.06), 'turun 8%');
      expect(PeriodComparison.changeLabel(5.4), 'naik 5%');
      expect(
        PeriodComparison.changeLabel(0),
        'sama seperti bulan lalu',
      );
    });

    test('label turun saat pengeluaran menyusut', () {
      final comparison = PeriodComparison(
        current: const MonthlySummary(
          period: ReportPeriod(year: 2026, month: 9),
          expense: 5700000,
        ),
        previous: const MonthlySummary(
          period: ReportPeriod(year: 2026, month: 8),
          expense: 6200000,
        ),
      );
      expect(comparison.expenseLabel, 'turun 8%');
    });

    test('tanpa baseline bulan lalu -> label null (banner netral)', () {
      final comparison = PeriodComparison(
        current: const MonthlySummary(
          period: ReportPeriod(year: 2026, month: 9),
          expense: 5700000,
        ),
        previous: const MonthlySummary(
          period: ReportPeriod(year: 2026, month: 8),
        ),
      );
      expect(comparison.expenseChangePercent, isNull);
      expect(comparison.expenseLabel, isNull);
    });
  });
}
