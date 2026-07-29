import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:sqflite/sqflite.dart';

class TransferRepository {
  final DbService _dbService;

  const TransferRepository(this._dbService);

  Future<void> transferBalance({required TransferForm form}) async {
    final db = await _dbService.database;

    if (form.amount == null ||
        form.accountSourceId == null ||
        form.accountDestinationId == null) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }

    await db.transaction((txn) async {
      await _recordTransfer(txn, form: form);
    });
  }

  Future<int> updateTransfer({
    required TransferForm form,
    required int id,
  }) async {
    final db = await _dbService.database;

    if (form.amount == null ||
        form.accountSourceId == null ||
        form.accountDestinationId == null) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }

    final journalId = await db.transaction((txn) async {
      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.voided.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [id],
      );

      return await _recordTransfer(txn, form: form);
    });

    return journalId;
  }

  Future<int> _recordTransfer(
    Transaction txn, {
    required TransferForm form,
  }) async {
    final date = form.date ?? DateTime.now();

    final journalEntryId = await txn.rawInsert(
      '''
        INSERT INTO $journalEntryTable (
          ${JournalEntryKey.description},
          ${JournalEntryKey.entryDate},
          ${JournalEntryKey.source},
          ${JournalEntryKey.status}
        ) VALUES (?,?,?,?)
      ''',
      [
        form.note,
        date.secondsSinceEpoch,
        JournalSource.transfer.value,
        JournalStatus.draft.name,
      ],
    );

    await txn.rawInsert(
      '''
        INSERT INTO $journalLineTable (
          ${JournalLineKey.accountId},
          ${JournalLineKey.creditAmount},
          ${JournalLineKey.debitAmount},
          ${JournalLineKey.journalEntryId},
          ${JournalLineKey.lineOrder},
          ${JournalLineKey.note}
        ) VALUES (?,?,?,?,?,?), (?,?,?,?,?,?)
      ''',
      [
        // Source
        form.accountSourceId,
        form.amount,
        0,
        journalEntryId,
        1,
        'Pindah dana ke ${form.accountDestinationName}',

        // Destination
        form.accountDestinationId,
        0,
        form.amount,
        journalEntryId,
        0,
        'Pindah dana dari ${form.accountSourceName}',
      ],
    );

    await txn.update(
      journalEntryTable,
      {JournalEntryKey.status: JournalStatus.posted.name},
      where: '${JournalEntryKey.id} = ?',
      whereArgs: [journalEntryId],
    );

    return journalEntryId;
  }
}
