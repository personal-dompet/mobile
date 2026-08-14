import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/dashboard/models/transaction_summary.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';

class DashboardRepository {
  final DbService _dbService;

  const DashboardRepository(this._dbService);

  Future<int> getTotalLiquidBalance() async {
    final db = await _dbService.database;

    final queryResult = await db.rawQuery(
      '''
      SELECT SUM(
        CASE WHEN ${AccountKey.type} = ?
        THEN -1 * ${AccountKey.balance}
        ELSE ${AccountKey.balance}
        END
      ) AS ${AccountKey.balance}
      FROM $accountBalanceView
      WHERE ${AccountKey.isLiquid} = 1
        AND ${AccountKey.isDeleted} = 0
    ''',
      [AccountType.liability.value],
    );

    final balance = queryResult.first[AccountKey.balance] as int;

    return balance;
  }

  Future<TransactionSummary> getTransactionSummary() async {
    final db = await _dbService.database;

    final now = DateTime.now();

    final startDate = now.startOfDay;
    final endDate = now.endOfDay;

    final queryResult = await db.rawQuery(
      '''
      SELECT
        SUM(CASE WHEN $accountTable.${AccountKey.type} = ? THEN $journalLineTable.${JournalLineKey.creditAmount} ELSE 0 END) AS income,
        SUM(CASE WHEN $accountTable.${AccountKey.type} = ? THEN $journalLineTable.${JournalLineKey.debitAmount} ELSE 0 END) AS expense
      FROM $journalEntryTable
      INNER JOIN $journalLineTable
        ON $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
      INNER JOIN $accountTable 
        ON $journalLineTable.${JournalLineKey.accountId} = $accountTable.${AccountKey.id}
      WHERE $journalEntryTable.${JournalEntryKey.source} = ?
        AND $journalEntryTable.${JournalEntryKey.status} = ?
        AND ($journalEntryTable.${JournalEntryKey.entryDate} BETWEEN ? AND ?)
    ''',
      [
        AccountType.income.value,
        AccountType.expense.value,
        JournalSource.transaction.value,
        JournalStatus.posted.name,
        startDate.secondsSinceEpoch,
        endDate.secondsSinceEpoch,
      ],
    );

    final summaries = queryResult
        .map((e) => TransactionSummary.fromJson(e))
        .toList();

    return summaries.first;
  }
}
