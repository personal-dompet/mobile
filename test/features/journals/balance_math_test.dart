import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../helpers/test_db.dart';

void main() {
  late DbService dbService;
  late Database db;

  setUp(() async {
    dbService = await createTestDbService();
    db = await dbService.database;
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  Future<int> insertJournal({
    required String status,
    required List<(int accountId, int debit, int credit)> lines,
  }) async {
    final id = await db.insert(journalEntryTable, {
      JournalEntryKey.entryDate:
          DateTime(2026, 8, 8).millisecondsSinceEpoch ~/ 1000,
      JournalEntryKey.source: JournalSource.transaction.value,
      JournalEntryKey.description: 'test entry',
      JournalEntryKey.status: status,
    });

    for (final (index, (accountId, debit, credit)) in lines.indexed) {
      await db.insert(journalLineTable, {
        JournalLineKey.journalEntryId: id,
        JournalLineKey.accountId: accountId,
        JournalLineKey.debitAmount: debit,
        JournalLineKey.creditAmount: credit,
        JournalLineKey.lineOrder: index,
      });
    }

    return id;
  }

  Future<int> accountIdByCode(String code) async {
    final result = await db.query(
      accountTable,
      where: '${AccountKey.code} = ?',
      whereArgs: [code],
      limit: 1,
    );
    expect(result, isNotEmpty, reason: 'seeded account $code should exist');
    return result.first[AccountKey.id] as int;
  }

  Future<int> balanceOf(int accountId) async {
    final result = await db.query(
      accountBalanceView,
      where: '${AccountKey.id} = ?',
      whereArgs: [accountId],
      limit: 1,
    );
    expect(result, isNotEmpty);
    return result.first[AccountKey.balance] as int;
  }

  test('seeded presets exist and all balances start at zero', () async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $accountTable'),
    );
    expect(count, greaterThan(0));

    final rows = await db.query(accountBalanceView);
    for (final row in rows) {
      expect(row[AccountKey.balance], 0,
          reason: 'fresh ledger should have zero balances');
    }
  });

  test('posted expense decreases asset and increases expense account',
      () async {
    final assetId = await accountIdByCode(AccountPreset.cash.code);
    final expenseId = await accountIdByCode(AccountPreset.food.code);

    await insertJournal(
      status: JournalStatus.posted.name,
      lines: [
        (assetId, 0, 5000),
        (expenseId, 5000, 0),
      ],
    );

    expect(await balanceOf(assetId), -5000,
        reason: 'asset is DEBIT-normal, credit of 5000 lowers balance');
    expect(await balanceOf(expenseId), 5000,
        reason: 'expense is DEBIT-normal, debit of 5000 raises balance');
  });

  test('posted income increases asset and income account', () async {
    final assetId = await accountIdByCode(AccountPreset.cash.code);
    final incomeId = await accountIdByCode(AccountPreset.salary.code);

    await insertJournal(
      status: JournalStatus.posted.name,
      lines: [
        (assetId, 10000, 0),
        (incomeId, 0, 10000),
      ],
    );

    expect(await balanceOf(assetId), 10000);
    expect(await balanceOf(incomeId), 10000,
        reason: 'income is CREDIT-normal, credit of 10000 raises balance');
  });

  test('draft entries never affect balances', () async {
    final assetId = await accountIdByCode(AccountPreset.cash.code);
    final expenseId = await accountIdByCode(AccountPreset.food.code);

    await insertJournal(
      status: JournalStatus.draft.name,
      lines: [
        (assetId, 0, 5000),
        (expenseId, 5000, 0),
      ],
    );

    expect(await balanceOf(assetId), 0);
    expect(await balanceOf(expenseId), 0);
  });

  test('voiding a posted entry reverts its balance effect', () async {
    final assetId = await accountIdByCode(AccountPreset.cash.code);
    final expenseId = await accountIdByCode(AccountPreset.food.code);

    final journalId = await insertJournal(
      status: JournalStatus.posted.name,
      lines: [
        (assetId, 0, 5000),
        (expenseId, 5000, 0),
      ],
    );

    expect(await balanceOf(assetId), -5000);

    await db.update(
      journalEntryTable,
      {JournalEntryKey.status: JournalStatus.voided.name},
      where: '${JournalEntryKey.id} = ?',
      whereArgs: [journalId],
    );

    expect(await balanceOf(assetId), 0,
        reason: 'voided entries must not count toward balances');
    expect(await balanceOf(expenseId), 0);
  });

  test('every posted journal entry is balanced (sum debit == sum credit)',
      () async {
    final assetId = await accountIdByCode(AccountPreset.cash.code);
    final expenseId = await accountIdByCode(AccountPreset.food.code);
    final incomeId = await accountIdByCode(AccountPreset.salary.code);

    await insertJournal(
      status: JournalStatus.posted.name,
      lines: [
        (assetId, 0, 15000),
        (expenseId, 10000, 0),
        (incomeId, 5000, 0), // balanced: credit 15000 == debit 10000 + 5000
      ],
    );

    final rows = await db.rawQuery('''
      SELECT
        ${JournalLineKey.journalEntryId},
        SUM(${JournalLineKey.debitAmount}) AS total_debit,
        SUM(${JournalLineKey.creditAmount}) AS total_credit
      FROM $journalLineTable
      GROUP BY ${JournalLineKey.journalEntryId}
    ''');

    for (final row in rows) {
      expect(row['total_debit'], row['total_credit'],
          reason:
              'journal entry ${row[JournalLineKey.journalEntryId]} must balance');
    }
  });
}
