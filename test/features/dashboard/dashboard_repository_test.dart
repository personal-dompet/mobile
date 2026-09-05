import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

int _sec(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

Future<int> _accountId(DbService db, String code) async {
  final conn = await db.database;
  final rows = await conn.query(
    accountTable,
    where: '${AccountKey.code} = ?',
    whereArgs: [code],
  );
  return rows.first[AccountKey.id] as int;
}

void main() {
  group('DashboardRepository.getTransactionSummary', () {
    test('belanja dari pocket hari ini ikut Ringkasan Hari Ini', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = DashboardRepository(db);

      final cash = await _accountId(db, '101.0001');
      final food = await _accountId(db, '501.0001');
      final conn = await db.database;
      final pocket = await conn.rawInsert(
        '''
        INSERT INTO $accountTable (
          ${AccountKey.code},
          ${AccountKey.name},
          ${AccountKey.type},
          ${AccountKey.normalBalance},
          ${AccountKey.isLiquid},
          ${AccountKey.isSystem}
        ) VALUES (?,?,?,?,?,?)
        ''',
        [
          '101.0006.0001',
          'Pocket Test',
          AccountType.asset.value,
          AccountType.asset.balanceType.value,
          0,
          0,
        ],
      );

      final now = DateTime.now();
      // Pengeluaran biasa hari ini.
      final txJournal = await conn.rawInsert(
        '''
        INSERT INTO $journalEntryTable (
          ${JournalEntryKey.entryDate},
          ${JournalEntryKey.source},
          ${JournalEntryKey.status}
        ) VALUES (?,?,?)
        ''',
        [_sec(now), JournalSource.transaction.value, JournalStatus.posted.name],
      );
      await conn.rawInsert(
        '''
        INSERT INTO $journalLineTable (
          ${JournalLineKey.journalEntryId},
          ${JournalLineKey.accountId},
          ${JournalLineKey.debitAmount},
          ${JournalLineKey.creditAmount},
          ${JournalLineKey.lineOrder}
        ) VALUES (?,?,?,?,?), (?,?,?,?,?)
        ''',
        [txJournal, food, 100000, 0, 0, txJournal, cash, 0, 100000, 1],
      );

      // Belanja 50rb langsung dari pocket hari ini.
      final spendJournal = await conn.rawInsert(
        '''
        INSERT INTO $journalEntryTable (
          ${JournalEntryKey.entryDate},
          ${JournalEntryKey.source},
          ${JournalEntryKey.status},
          ${JournalEntryKey.metadata}
        ) VALUES (?,?,?,?)
        ''',
        [
          _sec(now),
          JournalSource.saving.value,
          JournalStatus.posted.name,
          jsonEncode({
            'saving_tx': SavingTxType.spend.value,
            'pocket_id': pocket,
          }),
        ],
      );
      await conn.rawInsert(
        '''
        INSERT INTO $journalLineTable (
          ${JournalLineKey.journalEntryId},
          ${JournalLineKey.accountId},
          ${JournalLineKey.debitAmount},
          ${JournalLineKey.creditAmount},
          ${JournalLineKey.lineOrder}
        ) VALUES (?,?,?,?,?), (?,?,?,?,?)
        ''',
        [spendJournal, pocket, 0, 50000, 0, spendJournal, food, 50000, 0, 1],
      );

      // Topup 2jt hari ini: tidak boleh menggelembungkan expense.
      final topupJournal = await conn.rawInsert(
        '''
        INSERT INTO $journalEntryTable (
          ${JournalEntryKey.entryDate},
          ${JournalEntryKey.source},
          ${JournalEntryKey.status},
          ${JournalEntryKey.metadata}
        ) VALUES (?,?,?,?)
        ''',
        [
          _sec(now),
          JournalSource.saving.value,
          JournalStatus.posted.name,
          jsonEncode({
            'saving_tx': SavingTxType.topup.value,
            'pocket_id': pocket,
          }),
        ],
      );
      await conn.rawInsert(
        '''
        INSERT INTO $journalLineTable (
          ${JournalLineKey.journalEntryId},
          ${JournalLineKey.accountId},
          ${JournalLineKey.debitAmount},
          ${JournalLineKey.creditAmount},
          ${JournalLineKey.lineOrder}
        ) VALUES (?,?,?,?,?), (?,?,?,?,?)
        ''',
        [topupJournal, cash, 0, 2000000, 0, topupJournal, pocket, 2000000, 0, 1],
      );

      final summary = await repo.getTransactionSummary();
      expect(summary.expense, 150000);
      expect(summary.income, 0);
    });
  });
}
