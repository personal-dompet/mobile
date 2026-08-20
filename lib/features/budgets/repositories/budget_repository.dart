import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/budgets/models/account_budget_status.dart';
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

  Future<AccountBudgetStatus> getAccountStatuses() async {
    final db = await _dbService.database;

    final activeBudgetRows = await db.rawQuery('''
      SELECT DISTINCT ${BudgetKey.accountId}
      FROM $budgetTable
      WHERE ${BudgetKey.closedAt} IS NULL
    ''');

    final planRows = await db.rawQuery('''
      SELECT ${BudgetPlanKey.accountId}
      FROM $budgetPlanTable
      WHERE ${BudgetPlanKey.isDeleted} = 0
    ''');

    return AccountBudgetStatus(
      activeBudgetAccountIds: activeBudgetRows
          .map((row) => row[BudgetKey.accountId] as int)
          .toSet(),
      planAccountIds: planRows
          .map((row) => row[BudgetPlanKey.accountId] as int)
          .toSet(),
    );
  }

  Future<List<Budget>> getActiveBudgets(int accountId) async {
    final db = await _dbService.database;

    final rows = await db.rawQuery('''
      SELECT *
      FROM $budgetTrackerView
      WHERE ${BudgetKey.accountId} = ? AND ${BudgetKey.closedAt} IS NULL
      ORDER BY ${BudgetKey.periodStart} DESC
    ''', [accountId]);

    return rows.map((row) => Budget.fromJson(row)).toList();
  }

  Future<int> createBudget({
    required int accountId,
    required int amount,
    required DateTime periode,
  }) async {
    final db = await _dbService.database;

    return await db.rawInsert(
      '''
      INSERT INTO $budgetTable (
        ${BudgetKey.accountId},
        ${BudgetKey.periodStart},
        ${BudgetKey.periodEnd},
        ${BudgetKey.budgetedAmount},
        ${BudgetKey.carryAmount},
        ${BudgetKey.leftover}
      ) VALUES (?, ?, ?, ?, 0, 0)
      ON CONFLICT(${BudgetKey.accountId}, ${BudgetKey.periodStart}) DO UPDATE SET
        ${BudgetKey.budgetedAmount} = excluded.${BudgetKey.budgetedAmount},
        ${BudgetKey.carryAmount} = 0,
        ${BudgetKey.leftover} = 0,
        ${BudgetKey.closedAt} = NULL
      ''',
      [
        accountId,
        periode.startOfMonth.secondsSinceEpoch,
        periode.endOfMonth.secondsSinceEpoch,
        amount,
      ],
    );
  }

  Future<void> closeActiveBudgets(int accountId) async {
    final db = await _dbService.database;

    await db.update(
      budgetTable,
      {BudgetKey.closedAt: DateTime.now().secondsSinceEpoch},
      where: '${BudgetKey.accountId} = ? AND ${BudgetKey.closedAt} IS NULL',
      whereArgs: [accountId],
    );
  }
}
