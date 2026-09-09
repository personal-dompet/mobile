import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:sqflite/sqflite.dart';

class AccountRepository {
  final DbService _dbService;

  const AccountRepository(this._dbService);

  Future<List<Account>> getAccounts({
    required AccountFilter filter,
    bool withBudget = false,
  }) async {
    final db = await _dbService.database;

    final whereClauses = [
      '$accountBalanceView.${AccountKey.isDeleted} = 0',
      ...filter.whereClauses,
    ];

    final arguments = filter.arguments;

    final result = withBudget
        ? await db.rawQuery('''
      SELECT $accountBalanceView.*, 
        COUNT($budgetTable.${BudgetKey.accountId}) AS ${AccountKey.activeBudgetCount},
        COUNT($budgetPlanTable.${BudgetPlanKey.accountId}) AS ${AccountKey.activeBudgetPlanCount}
      FROM $accountBalanceView
      LEFT JOIN $budgetTable ON $accountBalanceView.${AccountKey.id} = $budgetTable.${BudgetKey.accountId} 
          AND $budgetTable.${BudgetKey.closedAt} IS NULL
      LEFT JOIN $budgetPlanTable 
        ON $accountBalanceView.${AccountKey.id} = $budgetPlanTable.${BudgetPlanKey.accountId}
        AND $budgetPlanTable.${BudgetPlanKey.isDeleted} = 0
      WHERE ${whereClauses.join(' AND ')}
      GROUP BY $accountBalanceView.${AccountKey.id}
      ORDER BY ${AccountKey.counter} DESC, ${AccountKey.name} ASC
    ''', arguments)
        : await db.rawQuery('''
      SELECT *
      FROM $accountBalanceView
      WHERE ${whereClauses.join(' AND ')}
      ORDER BY ${AccountKey.counter} DESC, ${AccountKey.name} ASC
    ''', arguments);

    return result.map((e) => Account.fromJson(e)).toList();
  }

  /// FIX-14 (IMP-2/IMP-3): list akun arsip (isDeleted=1), mirror
  /// [getAccounts] tapi sisi arsip. Dipakai grid dompet arsip +
  /// list kategori arsip. List aktif tak tersentuh (tetap =0).
  Future<List<Account>> getArchivedAccounts({
    required AccountFilter filter,
  }) async {
    final db = await _dbService.database;

    final whereClauses = [
      '$accountBalanceView.${AccountKey.isDeleted} = 1',
      ...filter.whereClauses,
    ];

    final result = await db.rawQuery('''
      SELECT *
      FROM $accountBalanceView
      WHERE ${whereClauses.join(' AND ')}
      ORDER BY ${AccountKey.counter} DESC, ${AccountKey.name} ASC
    ''', filter.arguments);

    return result.map((e) => Account.fromJson(e)).toList();
  }

  Future<Account?> getAccount(int id) async {
    final db = await _dbService.database;

    final result = await db.rawQuery(
      '''
      SELECT *
      FROM $accountBalanceView
      WHERE ${AccountKey.id} = ?
    ''',
      [id],
    );

    final accounts = result.map((e) => Account.fromJson(e)).toList();

    return accounts.firstOrNull;
  }

  Future<bool> checkUserAssetAccount() async {
    final db = await _dbService.database;

    final result = await db.rawQuery('''
      SELECT COUNT(*) FROM $accountTable 
        WHERE ${AccountKey.isSystem} = 0 
          AND ${AccountKey.type} = '${AccountType.asset.value}'
          AND ${AccountKey.isDeleted} = 0
    ''');

    final int? count = Sqflite.firstIntValue(result);

    return count is int && count > 0;
  }

  Future<void> archiveAccount(int id) async {
    final db = await _dbService.database;

    await db.update(
      accountTable,
      {AccountKey.isDeleted: 1},
      where: '${AccountKey.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> unarchiveAccount(int id) async {
    final db = await _dbService.database;

    await db.update(
      accountTable,
      {AccountKey.isDeleted: 0},
      where: '${AccountKey.id} = ?',
      whereArgs: [id],
    );
  }
}
