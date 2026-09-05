import 'package:dompet_app/features/reports/models/monthly_summary.dart';

/// Perbandingan periode sekarang vs periode sebelumnya.
///
/// Murni kalkulasi (tanpa `DateTime.now()` di dalam) agar mudah di-test.
/// Konvensi persen: ((sekarang - lalu) / lalu) * 100.
/// Jika periode lalu nol:
/// - sekarang juga nol -> 0% (tidak ada perubahan)
/// - sekarang > 0 -> null (tidak terdefinisi, jangan tampilkan angka menyesatkan)
class PeriodComparison {
  const PeriodComparison({
    required this.current,
    required this.previous,
  });

  final MonthlySummary current;
  final MonthlySummary previous;

  static double? changePercent({required int current, required int previous}) {
    if (previous == 0) return current == 0 ? 0 : null;
    return (current - previous) / previous * 100;
  }

  double? get incomeChangePercent => changePercent(
    current: current.income,
    previous: previous.income,
  );

  double? get expenseChangePercent => changePercent(
    current: current.expense,
    previous: previous.expense,
  );

  double? get netChangePercent =>
      changePercent(current: current.net, previous: previous.net);

  /// Label Bahasa Indonesia untuk banner, mis. "turun 8%".
  /// Null jika persen tidak terdefinisi (periode lalu kosong).
  static String? changeLabel(double? percent) {
    if (percent == null) return null;
    if (percent == 0) return 'sama seperti bulan lalu';
    final rounded = percent.abs().round();
    return '${percent < 0 ? 'turun' : 'naik'} $rounded%';
  }

  String? get expenseLabel {
    // Tanpa baseline bulan lalu, perbandingan tak bermakna — selalu
    // kembalikan null (banner netral), terlepas dari kondisi bulan berjalan.
    if (previous.expense == 0) return null;
    return changeLabel(expenseChangePercent);
  }
  String? get incomeLabel => changeLabel(incomeChangePercent);
}
