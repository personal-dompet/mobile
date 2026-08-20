import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/features/budgets/models/budget_plan.dart';

class BudgetPlanRepository {
  final DbService _dbService;

  const BudgetPlanRepository(this._dbService);

  Future<BudgetPlan?> getByAccountId(int accountId) async {
    final db = await _dbService.database;

    final rows = await db.query(
      budgetPlanTable,
      where:
          '${BudgetPlanKey.accountId} = ? AND ${BudgetPlanKey.isDeleted} = 0',
      whereArgs: [accountId],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return BudgetPlan.fromJson(rows.first);
  }

  Future<void> upsert({
    required int accountId,
    required int amount,
    required String? note,
  }) async {
    final db = await _dbService.database;

    await db.rawInsert('''
      INSERT INTO $budgetPlanTable (
        ${BudgetPlanKey.accountId},
        ${BudgetPlanKey.amount},
        ${BudgetPlanKey.note},
        ${BudgetPlanKey.isDeleted}
      ) VALUES (?, ?, ?, 0)
      ON CONFLICT(${BudgetPlanKey.accountId}) DO UPDATE SET
        ${BudgetPlanKey.amount} = excluded.${BudgetPlanKey.amount},
        ${BudgetPlanKey.note} = excluded.${BudgetPlanKey.note},
        ${BudgetPlanKey.isDeleted} = 0
    ''', [accountId, amount, note]);
  }

  Future<void> delete(int accountId) async {
    final db = await _dbService.database;

    await db.update(
      budgetPlanTable,
      {BudgetPlanKey.isDeleted: 1},
      where: '${BudgetPlanKey.accountId} = ?',
      whereArgs: [accountId],
    );
  }
}