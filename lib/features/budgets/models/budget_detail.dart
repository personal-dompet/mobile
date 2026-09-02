import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';

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
}
