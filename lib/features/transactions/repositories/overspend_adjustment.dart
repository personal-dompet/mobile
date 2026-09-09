import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/transactions/models/balance_adjustment.dart';
import 'package:sqflite/sqflite.dart';

/// Helper bersama FIX-07 (IMP-1): sisip jurnal penyesuaian selisih ke dalam
/// transaksi DB yang sedang berjalan (jangan buka `db.transaction` baru).
///
/// Dipakai saat pengeluaran/transfer melebihi saldo efektif:
/// Jurnal 1 menaikkan saldo aset ke `effectiveBalance + shortfall`
/// (= nominal yang diminta), lalu pemanggil mencatat Jurnal 2 biasa.
/// `shortfall` harus > 0; `==saldo` (shortfall 0) tidak lewat sini.
Future<void> insertShortfallAdjustment(
  Transaction txn, {
  required int assetId,
  required int effectiveBalance,
  required int shortfall,
  required DateTime date,
}) async {
  assert(shortfall > 0, 'shortfall must be positive (FIX-07)');

  final equityResult = await txn.rawQuery(
    '''
      SELECT ${AccountKey.id}
      FROM $accountBalanceView
      WHERE ${AccountKey.code} = ?
      LIMIT 1
    ''',
    [AccountPreset.balanceAdjustment.code],
  );
  if (equityResult.isEmpty) {
    throw Exception('Terjadi kesalahan data pada aplikasi');
  }
  final equityId = equityResult.first[AccountKey.id] as int;

  final adjustment = BalanceAdjustment(
    previousBalance: effectiveBalance,
    currentBalance: effectiveBalance + shortfall,
  );

  final journalEntryId = await txn.insert(journalEntryTable, {
    JournalEntryKey.entryDate: date.secondsSinceEpoch,
    JournalEntryKey.source: JournalSource.adjustment.value,
    JournalEntryKey.status: JournalStatus.draft.name,
    JournalEntryKey.metadata: jsonEncode(adjustment.toJson()),
  });

  await txn.rawInsert(
    '''
      INSERT INTO $journalLineTable (
        ${JournalLineKey.journalEntryId},
        ${JournalLineKey.accountId},
        ${JournalLineKey.debitAmount},
        ${JournalLineKey.creditAmount},
        ${JournalLineKey.lineOrder}
      ) VALUES (?,?,?,?,?), (?,?,?,?,?)
    ''',
    [
      journalEntryId,
      assetId,
      shortfall,
      0,
      0,
      journalEntryId,
      equityId,
      0,
      shortfall,
      1,
    ],
  );

  await txn.update(
    journalEntryTable,
    {JournalEntryKey.status: JournalStatus.posted.name},
    where: '${JournalEntryKey.id} = ?',
    whereArgs: [journalEntryId],
  );
}

/// Saldo live satu akun dari dalam transaksi berjalan.
Future<int> liveBalanceOf(Transaction txn, int accountId) async {
  final rows = await txn.rawQuery(
    '''
      SELECT ${AccountKey.balance}
      FROM $accountBalanceView
      WHERE ${AccountKey.id} = ?
      LIMIT 1
    ''',
    [accountId],
  );
  if (rows.isEmpty) {
    throw Exception('Terjadi kesalahan data pada aplikasi');
  }
  return (rows.first[AccountKey.balance] as num?)?.toInt() ?? 0;
}
