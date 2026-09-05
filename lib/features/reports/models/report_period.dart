import 'package:dompet_app/core/extensions/date.dart';

/// Periode laporan bulanan.
///
/// Single source of truth untuk batas tanggal laporan.
/// Menggunakan epoch-detik agar konsisten dengan
/// `JournalEntry.entryDate` dan extension [EpochSecond].
class ReportPeriod {
  const ReportPeriod({required this.year, required this.month})
    : assert(year >= 1970),
      assert(month >= 1 && month <= 12);

  final int year;
  final int month;

  factory ReportPeriod.currentMonth([DateTime? now]) {
    final current = now ?? DateTime.now();
    return ReportPeriod(year: current.year, month: current.month);
  }

  factory ReportPeriod.previousMonth([DateTime? now]) {
    final current = now ?? DateTime.now();
    final firstOfMonth = DateTime(current.year, current.month, 1);
    final prev = DateTime(firstOfMonth.year, firstOfMonth.month - 1, 1);
    return ReportPeriod(year: prev.year, month: prev.month);
  }

  DateTime get startDate => DateTime(year, month, 1).startOfMonth;

  DateTime get endDate => DateTime(year, month, 1).endOfMonth;

  int get startEpoch => startDate.secondsSinceEpoch;

  int get endEpoch => endDate.secondsSinceEpoch;

  ReportPeriod get previous {
    final first = DateTime(year, month, 1);
    final prev = DateTime(first.year, first.month - 1, 1);
    return ReportPeriod(year: prev.year, month: prev.month);
  }

  ReportPeriod get next {
    final first = DateTime(year, month, 1);
    final following = DateTime(first.year, first.month + 1, 1);
    return ReportPeriod(year: following.year, month: following.month);
  }

  String label({bool hideDate = true}) =>
      DateTime(year, month, 1).format(hideDate: hideDate);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportPeriod && year == other.year && month == other.month;

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => 'ReportPeriod($year-$month)';
}
