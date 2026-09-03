import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';

enum PaceStatus {
  onTrack,
  slightlyAbove,
  above,
  farAbove,
  slightlyBelow,
  below,
  farBelow,
  noData,
}

/// Threshold bertingkat untuk ritme (delta absolut |useage - elapsed|).
/// Bulat & rasional (bukan loncat 5% uniform):
/// - 5%  = toleransi normal (1-2 hari variansi, masih "Sesuai")
/// - 10% = sedikit (3 hari, mulai terasa)
/// - 25% = batas "Di atas/Di bawah" (seminggu, signifikan)
/// - >25% = "Jauh" (ekstrem, 1,8× di awal bulan masuk sini)
/// Spacing melebar 5 → 10 → 15 agar sensitivitas menurun untuk deviasi besar.
const double kPaceTolerance = 0.05;
const double kPaceSlight = 0.10;
const double kPaceAbove = 0.25;

class BudgetDetail {
  const BudgetDetail({
    required this.budget,
    required this.category,
    this.activities = const [],
    this.totalCount = 0,
  });

  final Budget budget;
  final Account category;
  final List<JournalEntry> activities;
  final int totalCount;

  int get transactionCount => totalCount;

  int get averageSpend =>
      transactionCount == 0 ? 0 : budget.actualSpend ~/ transactionCount;

  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDay = DateTime(
      budget.periodEndDate.year,
      budget.periodEndDate.month,
      budget.periodEndDate.day,
    );
    final diff = endDay.difference(today).inDays;
    if (diff < 0) return 0;
    return diff + 1;
  }

  int get dailyAllowance {
    if (budget.remaining <= 0) return 0;
    if (daysRemaining <= 0) return 0;
    return budget.remaining ~/ daysRemaining;
  }

  bool get canClose {
    final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return nowSec > budget.periodEnd;
  }

  bool get isOverBudget => budget.remaining < 0;

  // --- Ritme pengeluaran (control harian) ---
  int get totalDays {
    final s = DateTime(
      budget.periodStartDate.year,
      budget.periodStartDate.month,
      budget.periodStartDate.day,
    );
    final e = DateTime(
      budget.periodEndDate.year,
      budget.periodEndDate.month,
      budget.periodEndDate.day,
    );
    final diff = e.difference(s).inDays + 1;
    return diff <= 0 ? 1 : diff;
  }

  int elapsedDaysAt(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final s = DateTime(
      budget.periodStartDate.year,
      budget.periodStartDate.month,
      budget.periodStartDate.day,
    );
    final e = DateTime(
      budget.periodEndDate.year,
      budget.periodEndDate.month,
      budget.periodEndDate.day,
    );
    if (today.isBefore(s)) return 0;
    if (today.isAfter(e)) return totalDays;
    return today.difference(s).inDays + 1;
  }

  int get elapsedDays => elapsedDaysAt(DateTime.now());

  double elapsedRatioAt(DateTime now) {
    if (totalDays == 0) return 0;
    return elapsedDaysAt(now) / totalDays;
  }

  double get elapsedRatio => elapsedRatioAt(DateTime.now());

  double paceDeltaAt(DateTime now) {
    if (budget.actualBudgetAmount == 0) return 0;
    return budget.useageRatio - elapsedRatioAt(now);
  }

  double get paceDelta => paceDeltaAt(DateTime.now());

  PaceStatus paceStatusAt(DateTime now) {
    if (isOverBudget) return PaceStatus.noData;
    if (daysRemaining == 0) return PaceStatus.noData;
    if (budget.actualBudgetAmount == 0) return PaceStatus.noData;
    final elapsed = elapsedDaysAt(now);
    if (elapsed == 0) return PaceStatus.noData;
    // Belum ada pengeluaran di hari pertama: jangan tampilkan ritme dulu
    if (budget.actualSpend == 0 && elapsed <= 1) return PaceStatus.noData;
    final delta = paceDeltaAt(now);
    final abs = delta.abs();
    if (abs <= kPaceTolerance) return PaceStatus.onTrack;
    if (abs <= kPaceSlight) {
      return delta > 0 ? PaceStatus.slightlyAbove : PaceStatus.slightlyBelow;
    }
    if (abs <= kPaceAbove) {
      return delta > 0 ? PaceStatus.above : PaceStatus.below;
    }
    return delta > 0 ? PaceStatus.farAbove : PaceStatus.farBelow;
  }

  PaceStatus get paceStatus => paceStatusAt(DateTime.now());

  String paceLabelAt(DateTime now) {
    return switch (paceStatusAt(now)) {
      PaceStatus.onTrack => 'Sesuai ritme',
      PaceStatus.slightlyAbove => 'Sedikit di atas ritme',
      PaceStatus.above => 'Di atas ritme',
      PaceStatus.farAbove => 'Jauh di atas ritme',
      PaceStatus.slightlyBelow => 'Sedikit di bawah ritme',
      PaceStatus.below => 'Di bawah ritme',
      PaceStatus.farBelow => 'Jauh di bawah ritme',
      PaceStatus.noData => '',
    };
  }

  String get paceLabel => paceLabelAt(DateTime.now());
}
