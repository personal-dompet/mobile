import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/core/models/pagination_meta.dart';
import 'package:dompet_app/core/models/pagination_result.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';
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

    // FIX-04: sertakan jurnal `setup` (saldo awal) di semua list
    // aktivitas. Agregat (dashboard summary, report, budget) punya query
    // sendiri yang tetap mengecualikan `setup`.
    final clauses = [
      '$journalEntryTable.${JournalEntryKey.status} = ?',
    ];

    final List<dynamic> args = [JournalStatus.posted.name];

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

  Future<List<JournalEntry>> getJournalsByFilter(JournalFilter? filter) async {
    final db = await _dbService.database;

    // FIX-04: sama seperti getJournals — sertakan `setup`.
    final clauses = [
      '$journalEntryTable.${JournalEntryKey.status} = ?',
    ];

    final List<dynamic> args = [JournalStatus.posted.name];

    if (filter != null) {
      clauses.addAll(filter.whereClauses);
      args.addAll(filter.arguments);
    }

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
        ) AS ${JournalEntryKey.lines}
      FROM $journalEntryTable
      INNER JOIN $journalLineTable ON $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
      INNER JOIN $accountBalanceView ON $accountBalanceView.${AccountKey.id} = $journalLineTable.${JournalLineKey.accountId}
      WHERE ${clauses.join(' AND ')}
      GROUP BY $journalEntryTable.${JournalEntryKey.id}
      ORDER BY $journalEntryTable.${JournalEntryKey.entryDate} DESC
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

    return journals;
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

    await db.transaction((txn) async {
      final rows = await txn.query(
        journalEntryTable,
        columns: [
          JournalEntryKey.source,
          JournalEntryKey.sourceId,
          JournalEntryKey.metadata,
        ],
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [id],
        limit: 1,
      );
      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.voided.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [id],
      );
      // Void pembayaran tagihan = batal lunas: kembalikan bill ke unpaid
      // agar bisa dibayar ulang (TC-BINT-006). Hanya bila masih paid agar
      // pembayaran pengganti yang lebih baru tidak ikut terbuka.
      if (rows.isNotEmpty &&
          rows.first[JournalEntryKey.source] ==
              JournalSource.billPayment.value &&
          rows.first[JournalEntryKey.sourceId] != null) {
        await txn.update(
          billTable,
          {BillKey.status: BillStatus.unpaid.value},
          where: '${BillKey.id} = ? AND ${BillKey.status} = ?',
          whereArgs: [
            rows.first[JournalEntryKey.sourceId],
            BillStatus.paid.value,
          ],
        );
      }
      // Void kaki withdraw bayar-dari-Target (J1) = undo penuh: ikut void
      // J2 payment + buka kunci bill (TC-BINT-010). Withdraw biasa
      // (tanpa bill_id) tidak tersentuh.
      final linkedBillId = rows.isEmpty
          ? null
          : _linkedWithdrawBillId(
              rows.first[JournalEntryKey.metadata] as String?,
            );
      if (rows.isNotEmpty && linkedBillId != null) {
        await txn.update(
          journalEntryTable,
          {JournalEntryKey.status: JournalStatus.voided.name},
          where:
              '${JournalEntryKey.source} = ? AND ${JournalEntryKey.sourceId} = ? AND ${JournalEntryKey.status} = ?',
          whereArgs: [
            JournalSource.billPayment.value,
            linkedBillId,
            JournalStatus.posted.name,
          ],
        );
        await txn.update(
          billTable,
          {BillKey.status: BillStatus.unpaid.value},
          where: '${BillKey.id} = ? AND ${BillKey.status} = ?',
          whereArgs: [linkedBillId, BillStatus.paid.value],
        );
      }
      // Void pasangan hybrid spend (belanja dari Target J1<->J2): hapus
      // satu kaki void keduanya agar tak ada jurnal hantu (+liquid hantu).
      // Hanya bila pasangan masih posted (idempoten, tanpa rekursi).
      final pairId = rows.isEmpty
          ? null
          : _linkedSpendPairId(
              rows.first[JournalEntryKey.metadata] as String?,
            );
      if (pairId != null) {
        await txn.update(
          journalEntryTable,
          {JournalEntryKey.status: JournalStatus.voided.name},
          where: '${JournalEntryKey.id} = ? AND ${JournalEntryKey.status} = ?',
          whereArgs: [pairId, JournalStatus.posted.name],
        );
      }
    });
    return;
  }

  /// `paired_entry_id` dari metadata pasangan hybrid spend (J1/J2
  /// belanja dari Target). Null untuk jurnal biasa atau metadata rusak.
  int? _linkedSpendPairId(String? meta) {
    if (meta == null || meta.isEmpty) return null;
    try {
      final json = jsonDecode(meta);
      if (json is! Map) return null;
      final isSpendLeg =
          (json['hybrid'] == true &&
              SavingTxType.tryParse(json['saving_tx']) ==
                  SavingTxType.spend) ||
          json['hybrid_expense'] == true;
      if (!isSpendLeg) return null;
      final id = json['paired_entry_id'];
      return id is int ? id : null;
    } catch (_) {
      return null;
    }
  }

  /// `bill_id` dari metadata kaki withdraw bayar-dari-Target (J1).
  /// Null untuk withdraw biasa, jurnal lama, atau metadata rusak.
  int? _linkedWithdrawBillId(String? meta) {
    if (meta == null || meta.isEmpty) return null;
    try {
      final json = jsonDecode(meta);
      if (json is! Map) return null;
      if (SavingTxType.tryParse(json['saving_tx']) !=
          SavingTxType.withdraw) {
        return null;
      }
      final id = json['bill_id'];
      return id is int ? id : null;
    } catch (_) {
      return null;
    }
  }
}
