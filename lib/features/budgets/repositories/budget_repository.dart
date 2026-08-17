import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/budgets/models/budget_filter.dart';

class BudgetRepository {
  final DbService _dbService;

  const BudgetRepository(this._dbService);

  Future<List<Budget>> getBudgets(BudgetFilter filter) async {
    final db = await _dbService.database;

    final clauses = ['${BudgetKey.closedAt} IS NULL'];

    final List<dynamic> args = [];

    if (filter.accountName != null && filter.accountName!.isNotEmpty) {
      clauses.addAll(filter.whereClauses);
      args.addAll(filter.arguments);
    }

    final budgetResults = await db.rawQuery('''
      SELECT *
      FROM $budgetTrackerView
      WHERE ${clauses.join(' AND ')}
    ''', args);

    final budgets = budgetResults
        .map((budget) => Budget.fromJson(budget))
        .toList();

    return budgets;
  }
}
