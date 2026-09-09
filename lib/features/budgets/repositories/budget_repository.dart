import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/budgets/models/account_budget_status.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/budgets/models/budget_filter.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:sqflite/sqflite.dart';

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

    return _withArchivedFlags(db, budgets);
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

  Future<Budget?> getBudgetById(int id) async {
    final db = await _dbService.database;

    final rows = await db.rawQuery(
      '''
      SELECT *
      FROM $budgetTrackerView
      WHERE ${BudgetKey.id} = ?
      LIMIT 1
    ''',
      [id],
    );

    if (rows.isEmpty) return null;

    // FIX-12: getBudgetById dipakai halaman detail — flag arsip ikut.
    final enriched = await _withArchivedFlags(db, [
      Budget.fromJson(rows.first),
    ]);
    return enriched.first;
  }

  /// FIX-12: tandai budget yang kategorinya sudah diarsipkan.
  /// View tetap LEFT JOIN sehingga baris arsip tak hilang (tanpa migrasi
  /// view); flag diambil dari accounts.is_deleted dalam panggilan sama.
  Future<List<Budget>> _withArchivedFlags(
    Database db,
    List<Budget> budgets,
  ) async {
    if (budgets.isEmpty) return budgets;
    final rows = await db.query(
      accountTable,
      columns: [AccountKey.id],
      where: '${AccountKey.isDeleted} = 1',
    );
    if (rows.isEmpty) return budgets;
    final archived = rows.map((row) => row[AccountKey.id] as int).toSet();
    return [
      for (final budget in budgets)
        archived.contains(budget.accountId)
            ? budget.copyWith(categoryArchived: true)
            : budget,
    ];
  }

  Future<Budget?> getActiveBudget(int accountId) async {
    final db = await _dbService.database;

    final rows = await db.rawQuery(
      '''
      SELECT *
      FROM $budgetTrackerView
      WHERE ${BudgetKey.accountId} = ? AND ${BudgetKey.closedAt} IS NULL
      LIMIT 1
    ''',
      [accountId],
    );

    if (rows.isEmpty) return null;

    // FIX-12: flag arsip ikut seperti getBudgetById.
    final enriched = await _withArchivedFlags(db, [
      Budget.fromJson(rows.first),
    ]);
    return enriched.first;
  }

  /// Anggaran yang periodenya tepat sebulan [period] (termasuk yang sudah
  /// ditutup, agar histori tetap bisa dilaporkan).
  ///
  /// Anggaran selalu dibuat sebulan penuh ([createBudget] memakai
  /// start/endOfMonth), jadi pencocokan exact aman dari periode parsial.
  /// [Budget.actualSpend] dihitung view dari jurnal posted pada periode
  /// tersebut — konsisten dengan definisi expense laporan
  /// (satu-satunya sumber yang menyentuh akun expense saat ini adalah
  /// transaction + saving spend).
  Future<List<Budget>> getBudgetsForMonth(ReportPeriod period) async {
    final db = await _dbService.database;

    final rows = await db.rawQuery(
      '''
      SELECT *
      FROM $budgetTrackerView
      WHERE ${BudgetKey.periodStart} = ? AND ${BudgetKey.periodEnd} = ?
      ORDER BY ${BudgetKey.accountName} ASC
    ''',
      [period.startEpoch, period.endEpoch],
    );

    return _withArchivedFlags(
      db,
      rows.map((row) => Budget.fromJson(row)).toList(),
    );
  }

  Future<List<Budget>> getAccountBudgets(int accountId) async {
    final db = await _dbService.database;

    final rows = await db.rawQuery(
      '''
      SELECT *
      FROM $budgetTrackerView
      WHERE ${BudgetKey.accountId} = ? AND ${BudgetKey.closedAt} IS NULL
      ORDER BY ${BudgetKey.periodStart} DESC
    ''',
      [accountId],
    );

    return _withArchivedFlags(
      db,
      rows.map((row) => Budget.fromJson(row)).toList(),
    );
  }

  Future<int> createBudget({
    required int accountId,
    required int amount,
    required DateTime periode,
    int carryAmount = 0,
  }) async {
    // FIX-01: min 1 global (TC-BGT-005).
    if (amount <= 0) {
      throw Exception('Nominal harus lebih dari 0');
    }

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
      ) VALUES (?, ?, ?, ?, ?, 0)
      ON CONFLICT(${BudgetKey.accountId}, ${BudgetKey.periodStart}) DO UPDATE SET
        ${BudgetKey.budgetedAmount} = excluded.${BudgetKey.budgetedAmount},
        ${BudgetKey.carryAmount} = excluded.${BudgetKey.carryAmount},
        ${BudgetKey.leftover} = 0,
        ${BudgetKey.closedAt} = NULL
      ''',
      [
        accountId,
        periode.startOfMonth.secondsSinceEpoch,
        periode.endOfMonth.secondsSinceEpoch,
        amount,
        carryAmount,
      ],
    );
  }

  Future<void> closeActiveBudgets(int accountId) async {
    final db = await _dbService.database;

    await db.transaction((txn) async {
      final budgetResult = await txn.rawQuery(
        '''
        SELECT *
        FROM $budgetTrackerView
        WHERE ${BudgetKey.accountId} = ? AND ${BudgetKey.closedAt} IS NULL
        ORDER BY ${BudgetKey.periodStart} DESC
      ''',
        [accountId],
      );

      if (budgetResult.isEmpty) return null;

      final budget = Budget.fromJson(budgetResult.first);

      await txn.update(
        budgetTable,
        {
          BudgetKey.closedAt: DateTime.now().secondsSinceEpoch,
          BudgetKey.leftover: budget.remaining,
        },
        where: '${BudgetKey.accountId} = ? AND ${BudgetKey.closedAt} IS NULL',
        whereArgs: [accountId],
      );
    });
  }
}
