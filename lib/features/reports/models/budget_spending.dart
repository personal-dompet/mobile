import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/reports/models/period_comparison.dart';

/// Satu baris "Anggaran vs aktual": rencana ([Budget]) + realisasi bulan
/// berjalan + konteks bulan lalu.
///
/// - [spent] diambil dari [Budget.actualSpend] (single source of truth,
///   sama seperti halaman Detail Anggaran).
/// - [previousSpent] dari agregasi laporan (definisi expense laporan),
///   agar perbandingan MoM selalu konsisten dengan kartu kategori.
class BudgetSpending {
  const BudgetSpending({required this.budget, this.previousSpent = 0});

  final Budget budget;
  final int previousSpent;

  int get accountId => budget.accountId;
  String get categoryName => budget.accountName;
  int get budgetAmount => budget.actualBudgetAmount;
  int get spent => budget.actualSpend;

  double get usagePercent =>
      budgetAmount == 0 ? 0 : spent / budgetAmount * 100;

  bool get isOver => spent > budgetAmount;

  double? get momChangePercent => PeriodComparison.changePercent(
    current: spent,
    previous: previousSpent,
  );

  /// Label MoM Bahasa Indonesia, atau konteks netral bila tak terdefinisi.
  String? get momLabel {
    final change = momChangePercent;
    if (change == null) {
      return previousSpent == 0 && spent > 0
          ? 'baru dianggarkan bulan ini'
          : null;
    }
    if (change == 0) return 'sama seperti bulan lalu';
    return '${PeriodComparison.changeLabel(change)} dibanding bulan lalu';
  }
}
