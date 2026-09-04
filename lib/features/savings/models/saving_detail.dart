import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/savings/models/saving_insight.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';

/// Agregat Detail Target: status kini + insight + riwayat.
///
/// Meniru pola `BudgetDetail` agar halaman detail konsisten:
/// kondisi (plan) + analisis (insight) + aktivitas (journals).
class SavingDetail {
  const SavingDetail({
    required this.plan,
    required this.insight,
    this.activities = const [],
  });

  final SavingPlan plan;
  final SavingInsight insight;
  final List<JournalEntry> activities;

  int get transactionCount => activities.length;

  factory SavingDetail.compute({
    required SavingPlan plan,
    required List<JournalEntry> activities,
    required DateTime now,
  }) {
    return SavingDetail(
      plan: plan,
      insight: SavingInsight.compute(
        plan: plan,
        journals: activities,
        now: now,
      ),
      activities: activities,
    );
  }
}
