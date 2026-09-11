import 'dart:math';

import 'package:dompet_app/core/constants/last_day.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';
import 'package:intl/intl.dart';

/// Matematika jadwal tagihan murni (tanpa dependensi Flutter widget).
///
/// Format schedule tersimpan:
/// - monthly: hari `1`-`28` atau [lastDay] (`last_day`).
/// - yearly: `MM-DD` zero-padded (mis. `01-05`), tanpa [lastDay].
abstract final class BillSchedule {
  /// Urutan hari dalam sebulan untuk perbandingan jadwal monthly.
  static int monthlyDayOrder(String schedule) {
    if (schedule == lastDay) return 99;
    return int.parse(schedule);
  }

  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Tanggal billed/due monthly pada [year]-[month].
  static DateTime monthlyDate(int year, int month, String schedule) {
    if (schedule == lastDay) return DateTime(year, month + 1, 0);
    final day = min(int.parse(schedule), daysInMonth(year, month));
    return DateTime(year, month, day);
  }

  /// Tanggal `MM-DD` pada [year].
  static DateTime yearlyDate(int year, String schedule) {
    final parts = schedule.split('-');
    return DateTime(year, int.parse(parts[0]), int.parse(parts[1]));
  }

  /// Kemunculan billed monthly terdekat yang >= hari ini.
  static DateTime nextMonthlyBilled(DateTime from, String schedule) {
    final today = from.startOfDay;
    var candidate = monthlyDate(today.year, today.month, schedule);
    if (candidate.isBefore(today)) {
      candidate = monthlyDate(today.year, today.month + 1, schedule);
    }
    return candidate;
  }

  /// Kemunculan billed yearly terdekat yang >= hari ini.
  static DateTime nextYearlyBilled(DateTime from, String schedule) {
    final today = from.startOfDay;
    var candidate = yearlyDate(today.year, schedule);
    if (candidate.isBefore(today)) {
      candidate = yearlyDate(today.year + 1, schedule);
    }
    return candidate;
  }

  static DateTime nextBilled(
    DateTime from,
    String period,
    String billedSchedule,
  ) {
    if (period == BillPlanPeriodEnum.yearly.name) {
      return nextYearlyBilled(from, billedSchedule);
    }
    return nextMonthlyBilled(from, billedSchedule);
  }

  /// Kemunculan billed berikutnya setelah [after] (eksklusif).
  static DateTime nextBilledAfter(
    DateTime after,
    String period,
    String billedSchedule,
  ) {
    if (period == BillPlanPeriodEnum.yearly.name) {
      return yearlyDate(after.year + 1, billedSchedule);
    }
    return monthlyDate(after.year, after.month + 1, billedSchedule);
  }

  /// Jatuh tempo untuk satu [billed].
  static DateTime dueDateFor(
    DateTime billed,
    String period,
    String dueDateSchedule,
  ) {
    if (period == BillPlanPeriodEnum.yearly.name) {
      var due = yearlyDate(billed.year, dueDateSchedule);
      if (due.isBefore(billed.startOfDay)) {
        due = yearlyDate(billed.year + 1, dueDateSchedule);
      }
      return due;
    }
    return monthlyDate(billed.year, billed.month, dueDateSchedule);
  }

  /// Maks pengingat H-n agar tidak mendahului tanggal ditagih.
  ///
  /// - monthly: selisih hari (`last_day` dianggap 28).
  /// - yearly: selisih hari billed → due pada [refYear]
  ///   (due boleh jatuh tahun berikutnya).
  /// Null bila jadwal belum lengkap / format tak dikenal.
  /// 0 berarti pengingat dipaksa mati.
  static int? maxReminderDays({
    required String period,
    String? billedSchedule,
    String? dueDateSchedule,
    int? refYear,
  }) {
    if (billedSchedule == null ||
        billedSchedule.isEmpty ||
        dueDateSchedule == null ||
        dueDateSchedule.isEmpty) {
      return null;
    }
    try {
      if (period == BillPlanPeriodEnum.yearly.name) {
        final year = refYear ?? DateTime.now().year;
        final billed = yearlyDate(year, billedSchedule);
        final due = dueDateFor(billed, period, dueDateSchedule);
        return due.difference(billed).inDays;
      }
      final billedDay = billedSchedule == lastDay
          ? 28
          : int.parse(billedSchedule);
      final dueDay = dueDateSchedule == lastDay
          ? 28
          : int.parse(dueDateSchedule);
      return dueDay - billedDay;
    } catch (_) {
      return null;
    }
  }

  /// Label periode tagihan: monthly `yyyy-MM`, yearly `yyyy`.
  static String billPeriodFor(DateTime billed, String period) {
    if (period == BillPlanPeriodEnum.yearly.name) {
      return billed.year.toString();
    }
    return DateFormat('yyyy-MM').format(billed);
  }

  /// Hitung berapa draft dari kemunculan terdekat s.d. [endedAt] inklusif.
  static int countDrafts({
    required String period,
    required String billedSchedule,
    required DateTime endedAt,
    DateTime? from,
  }) {
    final end = endedAt.startOfDay;
    var billed = nextBilled(from ?? DateTime.now(), period, billedSchedule);
    var count = 0;
    while (!billed.isAfter(end)) {
      count++;
      billed = nextBilledAfter(billed, period, billedSchedule);
    }
    return count;
  }

  /// Tanggal billed kemunculan ke-[n] (1-based) dari [from].
  static DateTime nthBilledDate({
    required String period,
    required String billedSchedule,
    required int n,
    DateTime? from,
  }) {
    var billed = nextBilled(from ?? DateTime.now(), period, billedSchedule);
    for (var i = 1; i < n; i++) {
      billed = nextBilledAfter(billed, period, billedSchedule);
    }
    return billed;
  }

  /// Label tampil schedule: monthly `Tanggal 5` / `Hari terakhir`,
  /// yearly `5 Januari`.
  static String format(String period, String schedule) {
    if (period == BillPlanPeriodEnum.yearly.name) {
      final date = yearlyDate(2000, schedule);
      return DateFormat('d MMMM', 'id').format(date);
    }
    if (schedule == lastDay) return 'Hari terakhir';
    return 'Tanggal ${int.parse(schedule)}';
  }

  /// Label ringkas untuk tile: monthly `5` / `Akhir`, yearly `5 Jan`.
  static String formatShort(String period, String schedule) {
    if (period == BillPlanPeriodEnum.yearly.name) {
      final date = yearlyDate(2000, schedule);
      return DateFormat('d MMM', 'id').format(date);
    }
    if (schedule == lastDay) return 'Akhir';
    return int.parse(schedule).toString();
  }
}
