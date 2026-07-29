import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/core/models/pagination_meta.dart';
import 'package:dompet_app/core/models/pagination_result.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:dompet_app/features/journals/models/journal_line.dart';

class JournalRepository {
  final DbService _dbService;

  const JournalRepository(this._dbService);

  Future<PaginationResult<JournalEntry>> getJournals({
    required Pagination pagination,
    JournalFilter? filter,
  }) async {
    final db = await _dbService.database;

    final clauses = [
      '$journalEntryTable.${JournalEntryKey.source} != ?',
      '$journalEntryTable.${JournalEntryKey.status} = ?',
    ];

    final List<dynamic> args = [
      JournalSource.setup.value,
      JournalStatus.posted.name,
    ];

    if (filter != null) {
      clauses.addAll(filter.whereClauses);
      args.addAll(filter.arguments);
    }

    args.addAll([pagination.limit, pagination.offset]);

    final journalResults = await db.rawQuery('''
      SELECT 
        $journalEntryTable.${JournalEntryKey.id},
        $journalEntryTable.${JournalEntryKey.entryDate},
        $journalEntryTable.${JournalEntryKey.description},
        $journalEntryTable.${JournalEntryKey.reference},
        $journalEntryTable.${JournalEntryKey.source},
        $journalEntryTable.${JournalEntryKey.status},
        $journalEntryTable.${JournalEntryKey.sourceId},
        $journalEntryTable.${JournalEntryKey.metadata},
        json_group_array(
          json_object(
            '${JournalLineKey.id}', $journalLineTable.${JournalLineKey.id},
            '${JournalLineKey.journalEntryId}', $journalLineTable.${JournalLineKey.journalEntryId},
            '${JournalLineKey.accountId}', $journalLineTable.${JournalLineKey.accountId},
            '${JournalLineKey.accountName}', $accountBalanceView.${AccountKey.name},
            '${JournalLineKey.accountType}', $accountBalanceView.${AccountKey.type},
            '${JournalLineKey.accountBalance}', $accountBalanceView.${AccountKey.balance},
            '${JournalLineKey.accountNormalBalance}', $accountBalanceView.${AccountKey.normalBalance},
            '${JournalLineKey.debitAmount}', $journalLineTable.${JournalLineKey.debitAmount},
            '${JournalLineKey.creditAmount}', $journalLineTable.${JournalLineKey.creditAmount},
            '${JournalLineKey.lineOrder}', $journalLineTable.${JournalLineKey.lineOrder},
            '${JournalLineKey.note}', $journalLineTable.${JournalLineKey.note}
          )
        ) AS ${JournalEntryKey.lines},
        COUNT(*) OVER() AS total
      FROM $journalEntryTable
      INNER JOIN $journalLineTable ON $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
      INNER JOIN $accountBalanceView ON $accountBalanceView.${AccountKey.id} = $journalLineTable.${JournalLineKey.accountId}
      WHERE ${clauses.join(' AND ')}
      GROUP BY $journalEntryTable.${JournalEntryKey.id}
      ORDER BY $journalEntryTable.${JournalEntryKey.entryDate} DESC
      LIMIT ? OFFSET ?
    ''', args);

    final journals = journalResults.map((journalResult) {
      final result = {...journalResult};

      final List<dynamic> journalLines = jsonDecode(
        result[JournalEntryKey.lines] as String,
      );

      result.remove(JournalEntryKey.lines);

      final journal = JournalEntry.fromJson(result);

      return journal.copyWith(
        lines: journalLines.map((line) => JournalLine.fromJson(line)).toList(),
      );
    }).toList();

    final total = journalResults.isEmpty
        ? 0
        : journalResults.first['total'] as int;

    return PaginationResult(
      items: journals,
      meta: PaginationMeta(
        total: total,
        limit: pagination.limit,
        page: pagination.page,
      ),
    );
  }

  Future<JournalEntry> getJournal(int id) async {
    final db = await _dbService.database;

    final journalResults = await db.rawQuery(
      '''
      SELECT
        $journalEntryTable.${JournalEntryKey.id},
        $journalEntryTable.${JournalEntryKey.entryDate},
        $journalEntryTable.${JournalEntryKey.description},
        $journalEntryTable.${JournalEntryKey.reference},
        $journalEntryTable.${JournalEntryKey.source},
        $journalEntryTable.${JournalEntryKey.status},
        $journalEntryTable.${JournalEntryKey.metadata},
        $journalEntryTable.${JournalEntryKey.sourceId},
        json_group_array(
          json_object(
            '${JournalLineKey.id}', $journalLineTable.${JournalLineKey.id},
            '${JournalLineKey.journalEntryId}', $journalLineTable.${JournalLineKey.journalEntryId},
            '${JournalLineKey.accountId}', $journalLineTable.${JournalLineKey.accountId},
            '${JournalLineKey.accountName}', $accountBalanceView.${AccountKey.name},
            '${JournalLineKey.accountType}', $accountBalanceView.${AccountKey.type},
            '${JournalLineKey.accountBalance}', $accountBalanceView.${AccountKey.balance},
            '${JournalLineKey.accountNormalBalance}', $accountBalanceView.${AccountKey.normalBalance},
            '${JournalLineKey.debitAmount}', $journalLineTable.${JournalLineKey.debitAmount},
            '${JournalLineKey.creditAmount}', $journalLineTable.${JournalLineKey.creditAmount},
            '${JournalLineKey.lineOrder}', $journalLineTable.${JournalLineKey.lineOrder},
            '${JournalLineKey.note}', $journalLineTable.${JournalLineKey.note}
          )
        ) AS ${JournalEntryKey.lines}
      FROM $journalEntryTable
      INNER JOIN $journalLineTable ON $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
      INNER JOIN $accountBalanceView ON $accountBalanceView.${AccountKey.id} = $journalLineTable.${JournalLineKey.accountId}
      WHERE $journalEntryTable.${JournalEntryKey.id} = ?
      GROUP BY $journalEntryTable.${JournalEntryKey.id}
    ''',
      [id],
    );

    if (journalResults.isEmpty) {
      throw Exception('Aktivitas tidak ditemukan');
    }

    final journalJson = {...journalResults.first};

    final List<dynamic> journalLines = jsonDecode(
      journalJson[JournalEntryKey.lines] as String,
    );

    journalJson.remove(JournalEntryKey.lines);

    final journal = JournalEntry.fromJson(journalJson);

    return journal.copyWith(
      lines: journalLines.map((line) => JournalLine.fromJson(line)).toList(),
    );
  }

  Future<void> deleteJournal(int id) async {
    final db = await _dbService.database;

    await db.update(
      journalEntryTable,
      {JournalEntryKey.status: JournalStatus.voided.name},
      where: '${JournalEntryKey.id} = ?',
      whereArgs: [id],
    );
    return;
  }
}
