import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/accounts/model/account_filter.dart';
import 'package:sqflite/sqflite.dart';

class AccountRepository {
  final DbService _dbService;

  const AccountRepository(this._dbService);

  Future<List<Account>> getAccounts(AccountFilter filter) async {
    final db = await _dbService.database;

    final whereClauses = [
      '${AccountKey.isDeleted} = ?',
      ...filter.whereClauses,
    ];

    final arguments = [0, ...filter.arguments];

    final result = await db.rawQuery('''
      SELECT *
      FROM $accountBalanceView
      WHERE ${whereClauses.join(' AND ')}
      ORDER BY ${AccountKey.counter} DESC, ${AccountKey.name} ASC
    ''', arguments);

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

  Future<bool> checkUserAccount() async {
    final db = await _dbService.database;

    final result = await db.rawQuery('''
      SELECT COUNT(*) FROM $accountTable WHERE ${AccountKey.isSystem} = 0
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
