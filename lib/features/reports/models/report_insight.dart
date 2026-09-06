import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/reports/models/category_spending.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:dompet_app/features/reports/models/period_comparison.dart';

/// Bobot visual sebuah insight (dipetakan ke ikon/warna di widget).
enum InsightKind { positive, negative, info }

/// Satu baris insight otomatis di halaman Laporan.
///
/// Semua kalkulasi murni (tanpa `DateTime.now()` di dalam) mengikuti pola
/// [SavingInsight]: panggil [ReportInsight.generate] dengan data eksplisit
/// agar mudah di-test.
///
/// Aturan (berurutan berdasarkan pentingnya):
/// 1. Bulan kosong -> satu pesan ajakan mencatat.
/// 2. Pengeluaran vs pemasukan bulan berjalan.
/// 3. Pengeluaran vs rata-rata bulan-bulan sebelumnya yang ada aktivitas
///    (maksimal 3, dari [trend] tanpa bulan berjalan).
/// 4. Kategori pengeluaran terbesar.
/// 5. Perubahan pemasukan vs bulan lalu.
/// 6. Uang yang dialokasikan ke target.
class ReportInsight {
  const ReportInsight({required this.kind, required this.message});

  final InsightKind kind;
  final String message;

  static List<ReportInsight> generate({
    required MonthlySummary current,
    required PeriodComparison comparison,
    required List<MonthlySummary> trend,
    required List<CategorySpending> categories,
  }) {
    if (current.isEmpty) {
      return const [
        ReportInsight(
          kind: InsightKind.info,
          message: 'Belum ada transaksi bulan ini. Mulai catat untuk melihat pola keuanganmu.',
        ),
      ];
    }

    final insights = <ReportInsight>[];

    if (current.net >= 0) {
      insights.add(
        ReportInsight(
          kind: InsightKind.positive,
          message:
              'Bulan ini surplus ${current.net.compactCurrency} — pemasukan melebihi pengeluaran.',
        ),
      );
    } else {
      insights.add(
        ReportInsight(
          kind: InsightKind.negative,
          message:
              'Pengeluaran melebihi pemasukan ${(-current.net).compactCurrency} bulan ini.',
        ),
      );
    }

    final average = _averageExpense(trend, current);
    if (average != null && average > 0 && current.expense != average) {
      insights.add(
        ReportInsight(
          kind: current.expense < average
              ? InsightKind.positive
              : InsightKind.negative,
          message:
              'Pengeluaran ${current.expense < average ? 'di bawah' : 'di atas'} rata-rata bulan sebelumnya (${average.compactCurrency}).',
        ),
      );
    }

    if (categories.isNotEmpty) {
      final top = categories.first;
      insights.add(
        ReportInsight(
          kind: InsightKind.info,
          message:
              '${top.name} menjadi pengeluaran terbesar bulan ini (${top.percentage.round()}%).',
        ),
      );
    }

    final incomeChange = comparison.incomeChangePercent;
    if (incomeChange != null && incomeChange != 0) {
      insights.add(
        ReportInsight(
          kind: incomeChange > 0 ? InsightKind.positive : InsightKind.negative,
          message:
              'Pemasukan ${incomeChange > 0 ? 'naik' : 'turun'} ${incomeChange.abs().round()}% dibanding bulan lalu.',
        ),
      );
    }

    if (current.netSaving > 0) {
      insights.add(
        ReportInsight(
          kind: InsightKind.info,
          message:
              '${current.netSaving.compactCurrency} dialokasikan ke target bulan ini.',
        ),
      );
    }

    return insights;
  }

  /// Rata-rata pengeluaran bulan-bulan sebelum [current] yang ada aktivitas
  /// (maksimal 3). Null bila tidak ada histori.
  static int? _averageExpense(
    List<MonthlySummary> trend,
    MonthlySummary current,
  ) {
    final history = trend
        .where((e) => e.period != current.period && !e.isEmpty)
        .toList();
    if (history.isEmpty) return null;
    final recent = history.length <= 3
        ? history
        : history.sublist(history.length - 3);
    final total = recent.fold<int>(0, (sum, e) => sum + e.expense);
    return total ~/ recent.length;
  }
}
