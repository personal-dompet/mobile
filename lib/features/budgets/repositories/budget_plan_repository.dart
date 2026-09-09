import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
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

  /// FIX-12 (IMP-9): semua rencana aktif + kategorinya untuk list rencana.
  /// TC2-BGT-002: kategori yang sudah diarsipkan disembunyikan dari list
  /// (berbeda dengan list anggaran aktif yang tetap tampil + badge).
  /// Tanpa N+1 via satu IN-query.
  Future<List<({BudgetPlan plan, Account category})>>
  getPlansWithCategories() async {
    final db = await _dbService.database;

    final planRows = await db.query(
      budgetPlanTable,
      where: '${BudgetPlanKey.isDeleted} = 0',
    );
    if (planRows.isEmpty) return [];

    final plans = planRows.map(BudgetPlan.fromJson).toList();
    final ids = {for (final plan in plans) plan.accountId}.toList();
    final placeholders = List.filled(ids.length, '?').join(',');
    final accountRows = await db.query(
      accountTable,
      where:
          '${AccountKey.id} IN ($placeholders) AND ${AccountKey.isDeleted} = 0',
      whereArgs: ids,
      orderBy: '${AccountKey.name} ASC',
    );
    final accounts = {
      for (final row in accountRows)
        (row[AccountKey.id] as int): Account.fromJson(row),
    };
    final result = [
      for (final plan in plans)
        if (accounts.containsKey(plan.accountId))
          (plan: plan, category: accounts[plan.accountId]!),
    ];
    result.sort((a, b) => a.category.name.compareTo(b.category.name));
    return result;
  }

  Future<void> upsert({
    required int accountId,
    required int amount,
    required String? note,
  }) async {
    // FIX-01: min 1 global (TC-BGT-005, plan form shares this repo).
    if (amount <= 0) {
      throw Exception('Nominal harus lebih dari 0');
    }

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