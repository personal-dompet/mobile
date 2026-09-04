import 'dart:convert';

import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';

/// Status tampilan insight di Detail Target.
///
/// Urutan resolusi di [SavingInsight.compute]:
/// reached > noTarget > notEnoughData > projected.
enum SavingInsightStatus {
  /// Sisa <= 0. Tampilkan selebrasi.
  reached,

  /// Tanpa nominal tujuan. Hanya laju bulanan + riwayat yang relevan.
  noTarget,

  /// Punya target tapi histori alokasi belum cukup (< 2 topup
  /// atau laju nol). Jangan tampilkan tanggal proyeksi yang menyesatkan.
  notEnoughData,

  /// Siap tampil: sisa + (butuh/bulan jika ada deadline) + estimasi tanggal.
  projected,
}

/// Insight Detail Target: sisa, laju bulanan, dan proyeksi.
///
/// Semua angka yang ditampilkan ke pengguna dalam bulanan.
///
/// Semua kalkulasi murni (tanpa `DateTime.now()` di dalam) agar mudah
/// di-test: panggil [SavingInsight.compute] dengan `now` eksplisit.
///
/// Konvensi yang disepakati:
/// - Rata-rata = totalTopup ÷ bulan kalender sejak target dibuat (inklusif,
///   min 1), **termasuk bulan tanpa alokasi**. Alokasi berkali-kali dalam
///   satu bulan dihitung sebagai total bulan itu — BUKAN dibagi jumlah
///   transaksi. Contoh: Jan 800rb, Feb 0, Mar 500rb -> 1,3jt ÷ 3 =
///   Rp433.333/bulan. Ini jujur menggambarkan kecepatan pengguna, karena
///   bulan tanpa alokasi tetap dihitung.
/// - `Butuh RpX/bulan` hanya jika ada `targetDate` di masa depan.
/// - `Estimasi tercapai` dihitung dari laju histori, butuh >= 2 topup.
/// - `daysRemaining` inklusif (deadline hari ini = 1, lewat = 0) agar
///   tidak pernah bagi-nol dan tidak menghasilkan angka aneh.
class SavingInsight {
  const SavingInsight({
    required this.status,
    required this.totalTopup,
    required this.topupCount,
    required this.addedThisMonth,
    required this.monthsElapsed,
    required this.avgPerMonth,
    required this.remaining,
    required this.daysRemaining,
    required this.neededPerMonth,
    required this.etaDays,
    required this.projectedDate,
    required this.isOverdue,
    required this.isDueToday,
  });

  final SavingInsightStatus status;

  /// Total nominal TOPUP sejak dibuat (withdraw/spend diabaikan).
  final int totalTopup;

  /// Jumlah jurnal TOPUP (untuk gate `notEnoughData`).
  final int topupCount;

  /// Total TOPUP pada bulan kalender [now].
  final int addedThisMonth;

  /// Bulan kalender sejak dibuat (inklusif, min 1).
  /// Contoh: dibuat Januari, sekarang Maret -> 3 (Jan, Feb, Mar).
  final int monthsElapsed;

  /// Rata-rata alokasi per bulan = totalTopup ÷ monthsElapsed (dibulatkan).
  /// Inilah satu-satunya angka laju yang ditampilkan ke pengguna.
  final int avgPerMonth;

  /// Sisa menuju target (0 jika tanpa target).
  final int remaining;

  /// Sisa hari inklusif menuju deadline. Null jika tanpa deadline.
  /// Deadline hari ini = 1, sudah lewat = 0.
  final int? daysRemaining;

  /// Kebutuhan bulanan agar tepat waktu = ceil(remaining * 30 / days).
  /// Null jika tanpa deadline, sudah tercapai, atau deadline lewat.
  ///
  /// Catatan: jika tenggat kurang dari sebulan, annualisasi parsial membuat
  /// angka ini melebihi sisa itu sendiri (mis. sisa 30rb/27 hari -> 33rb).
  /// Karena itu rate hanya ditampilkan bila tenggat >= sebulan
  /// ([showNeedRate]); di bawah itu hero menampilkan sisa + hitung mundur.
  final int? neededPerMonth;

  /// Estimasi hari menuju tercapai = ceil(sisa ÷ laju bulanan × 30).
  /// Null jika tidak bisa diproyeksikan.
  final int? etaDays;

  /// Estimasi tanggal tercapai (today + etaDays). Null jika tak ada ETA.
  final DateTime? projectedDate;

  final bool isOverdue;
  final bool isDueToday;

  bool get hasDeadline => daysRemaining != null;
  bool get showNeededPerMonth =>
      neededPerMonth != null && neededPerMonth! > 0;

  /// Rate kebutuhan hanya layak tampil bila tenggat >= sebulan penuh.
  bool get showNeedRate =>
      showNeededPerMonth && (daysRemaining ?? 0) >= 30;

  bool get showProjection => projectedDate != null && etaDays != null;

  /// Sisa waktu menuju deadline dalam bulanan: hari ini -> 'Tenggat bulan
  /// ini', di bawah sebulan -> 'kurang dari sebulan lagi', selebihnya ->
  /// 'sekitar N bulan lagi'. Null jika tanpa deadline atau sudah lewat.
  String? get deadlineDurationLabel {
    final days = daysRemaining;
    if (days == null || days <= 0) return null;
    if (days == 1 && isDueToday) return 'Tenggat bulan ini';
    if (days < 30) return 'kurang dari sebulan lagi';
    return 'sekitar ${(days / 30).round().clamp(1, 600)} bulan lagi';
  }

  /// Estimasi kasar durasi menuju tercapai, selalu dalam bulanan:
  /// di bawah sebulan -> 'kurang dari sebulan lagi',
  /// selebihnya -> 'sekitar N bulan lagi'.
  String? get etaDurationLabel {
    final eta = etaDays;
    if (eta == null) return null;
    if (eta < 30) return 'kurang dari sebulan lagi';
    return 'sekitar ${(eta / 30).round().clamp(1, 600)} bulan lagi';
  }

  static SavingInsight compute({
    required SavingPlan plan,
    required List<JournalEntry> journals,
    required DateTime now,
  }) {
    final today = DateTime(now.year, now.month, now.day);

    final remaining = plan.hasTarget ? plan.remaining : 0;

    if (plan.hasTarget && remaining <= 0) {
      final topupStats = _topupStats(
        plan: plan,
        journals: journals,
        now: now,
        today: today,
      );
      return SavingInsight(
        status: SavingInsightStatus.reached,
        totalTopup: topupStats.total,
        topupCount: topupStats.count,
        addedThisMonth: topupStats.addedThisMonth,
        monthsElapsed: topupStats.monthsElapsed,
        avgPerMonth: topupStats.avgPerMonth,
        remaining: remaining,
        daysRemaining: _daysRemaining(plan.targetDateTime, today),
        neededPerMonth: null,
        etaDays: null,
        projectedDate: null,
        isOverdue: _isOverdue(plan.targetDateTime, today),
        isDueToday: _isDueToday(plan.targetDateTime, today),
      );
    }

    if (!plan.hasTarget) {
      final topupStats = _topupStats(
        plan: plan,
        journals: journals,
        now: now,
        today: today,
      );
      return SavingInsight(
        status: SavingInsightStatus.noTarget,
        totalTopup: topupStats.total,
        topupCount: topupStats.count,
        addedThisMonth: topupStats.addedThisMonth,
        monthsElapsed: topupStats.monthsElapsed,
        avgPerMonth: topupStats.avgPerMonth,
        remaining: 0,
        daysRemaining: null,
        neededPerMonth: null,
        etaDays: null,
        projectedDate: null,
        isOverdue: false,
        isDueToday: false,
      );
    }

    // Punya target & sisa > 0.
    final topupStats = _topupStats(
      plan: plan,
      journals: journals,
      now: now,
      today: today,
    );
    final days = _daysRemaining(plan.targetDateTime, today);
    final overdue = _isOverdue(plan.targetDateTime, today);
    final dueToday = _isDueToday(plan.targetDateTime, today);

    int? neededPerMonth;
    if (days != null && days > 0 && remaining > 0) {
      neededPerMonth = (remaining * 30 / days).ceil();
    }

    int? etaDays;
    DateTime? projectedDate;
    final hasEnoughHistory =
        topupStats.count >= 2 && topupStats.avgPerMonth > 0;
    if (hasEnoughHistory && remaining > 0) {
      etaDays = (remaining / topupStats.avgPerMonth * 30).ceil();
      projectedDate = today.add(Duration(days: etaDays));
    }

    final status = hasEnoughHistory || neededPerMonth != null
        ? SavingInsightStatus.projected
        : SavingInsightStatus.notEnoughData;

    return SavingInsight(
      status: status,
      totalTopup: topupStats.total,
      topupCount: topupStats.count,
      addedThisMonth: topupStats.addedThisMonth,
      monthsElapsed: topupStats.monthsElapsed,
      avgPerMonth: topupStats.avgPerMonth,
      remaining: remaining,
      daysRemaining: days,
      neededPerMonth: neededPerMonth,
      etaDays: etaDays,
      projectedDate: projectedDate,
      isOverdue: overdue,
      isDueToday: dueToday,
    );
  }

  /// Sisa hari inklusif: deadline hari ini = 1, lewat = 0, null = tanpa deadline.
  static int? _daysRemaining(DateTime? targetDate, DateTime today) {
    if (targetDate == null) return null;
    final targetDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final diff = targetDay.difference(today).inDays;
    if (diff < 0) return 0;
    return diff + 1;
  }

  static bool _isOverdue(DateTime? targetDate, DateTime today) {
    if (targetDate == null) return false;
    final targetDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    return targetDay.isBefore(today);
  }

  static bool _isDueToday(DateTime? targetDate, DateTime today) {
    if (targetDate == null) return false;
    final targetDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    return targetDay == today;
  }

  static _TopupStats _topupStats({
    required SavingPlan plan,
    required List<JournalEntry> journals,
    required DateTime now,
    required DateTime today,
  }) {
    var total = 0;
    var count = 0;
    var addedThisMonth = 0;

    for (final journal in journals) {
      final tx = _savingTxOf(journal, plan.accountId);
      if (tx != SavingTxType.topup) continue;
      final amount = journal.amount;
      if (amount <= 0) continue;
      count++;
      total += amount;
      final entryDay = DateTime.fromMillisecondsSinceEpoch(
        journal.entryDate * 1000,
      );
      if (entryDay.year == now.year && entryDay.month == now.month) {
        addedThisMonth += amount;
      }
    }

    final monthsElapsed = _monthsSinceCreated(
      createdAtEpochSec: plan.createdAt,
      journals: journals,
      today: today,
    );
    final avgPerMonth = (total / monthsElapsed).round();

    return _TopupStats(
      total: total,
      count: count,
      addedThisMonth: addedThisMonth,
      monthsElapsed: monthsElapsed,
      avgPerMonth: avgPerMonth,
    );
  }

  /// Bulan kalender sejak dibuat (inklusif, min 1).
  /// Contoh: dibuat Januari, sekarang Maret -> 3 (Jan, Feb, Mar),
  /// termasuk bulan tanpa alokasi. Jika [createdAtEpochSec] kosong (0),
  /// fallback ke jurnal tertua; tanpa jurnal = 1.
  static int _monthsSinceCreated({
    required int createdAtEpochSec,
    required List<JournalEntry> journals,
    required DateTime today,
  }) {
    DateTime? startMonth;
    if (createdAtEpochSec > 0) {
      final created = DateTime.fromMillisecondsSinceEpoch(
        createdAtEpochSec * 1000,
      );
      startMonth = DateTime(created.year, created.month);
    } else if (journals.isNotEmpty) {
      var oldest = journals.first.entryDate;
      for (final journal in journals) {
        if (journal.entryDate < oldest) oldest = journal.entryDate;
      }
      final oldestDay = DateTime.fromMillisecondsSinceEpoch(oldest * 1000);
      startMonth = DateTime(oldestDay.year, oldestDay.month);
    }
    if (startMonth == null) return 1;
    final currentMonth = DateTime(today.year, today.month);
    if (startMonth.isAfter(currentMonth)) return 1;
    return (currentMonth.year - startMonth.year) * 12 +
        (currentMonth.month - startMonth.month) +
        1;
  }

  /// Klasifikasi TOPUP khusus pocket ini via metadata JSON.
  /// Non-topup, pocket lain, atau metadata rusak -> null (diabaikan).
  static SavingTxType? _savingTxOf(JournalEntry journal, int pocketId) {
    final meta = journal.metadata;
    if (meta == null || meta.isEmpty) return null;
    try {
      final json = jsonDecode(meta);
      if (json is! Map) return null;
      if (json['saving_tx'] != SavingTxType.topup.value) return null;
      final id = json['pocket_id'];
      if (id is! int || id != pocketId) return null;
      return SavingTxType.topup;
    } catch (_) {
      return null;
    }
  }
}

class _TopupStats {
  const _TopupStats({
    required this.total,
    required this.count,
    required this.addedThisMonth,
    required this.monthsElapsed,
    required this.avgPerMonth,
  });

  final int total;
  final int count;
  final int addedThisMonth;
  final int monthsElapsed;
  final int avgPerMonth;
}
