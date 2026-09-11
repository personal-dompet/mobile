import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
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
    this.linkedBill,
    this.liquidAssets = const [],
  });

  final SavingPlan plan;
  final SavingInsight insight;
  final List<JournalEntry> activities;

  /// Tagihan kemunculan ter-link (hanya untuk target sisihan).
  /// Null bila target biasa atau tagihan belum tergenerate.
  final Bill? linkedBill;

  /// Dompet cair untuk dialog hapus/bayar (aturan 5: dalam state flow).
  final List<Account> liquidAssets;

  int get transactionCount => activities.length;

  factory SavingDetail.compute({
    required SavingPlan plan,
    required List<JournalEntry> activities,
    required DateTime now,
    Bill? linkedBill,
    List<Account> liquidAssets = const [],
  }) {
    return SavingDetail(
      plan: plan,
      insight: SavingInsight.compute(
        plan: plan,
        journals: activities,
        now: now,
      ),
      activities: activities,
      linkedBill: linkedBill,
      liquidAssets: liquidAssets,
    );
  }
}
