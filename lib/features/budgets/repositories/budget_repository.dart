import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/core/models/pagination_meta.dart';
import 'package:dompet_app/core/models/pagination_result.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/budgets/models/budget_filter.dart';

class BudgetRepository {
  final DbService _dbService;

  const BudgetRepository(this._dbService);

  Future<PaginationResult<Budget>> getBudgets({
    required Pagination pagination,
    BudgetFilter? filter,
  }) async {
    final db = await _dbService.database;

    final clauses = ['${BudgetKey.closedAt} IS NULL'];

    final List<dynamic> args = [];

    if (filter != null) {
      clauses.addAll(filter.whereClauses);
      args.addAll(filter.arguments);
    }

    args.addAll([pagination.limit, pagination.offset]);

    final budgetResults = await db.rawQuery('''
      SELECT *,
        COUNT(*) OVER() AS total
      FROM $budgetTrackerView
      WHERE ${clauses.join(' AND ')}
      LIMIT ? OFFSET ?
    ''', args);

    final total = budgetResults.isEmpty
        ? 0
        : budgetResults.first['total'] as int;

    final budgets = budgetResults
        .map((budget) => Budget.fromJson(budget))
        .toList();

    return PaginationResult(
      items: budgets,
      meta: PaginationMeta(
        total: total,
        limit: pagination.limit,
        page: pagination.page,
      ),
    );
  }
}
