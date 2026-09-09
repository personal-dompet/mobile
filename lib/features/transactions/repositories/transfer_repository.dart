import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:dompet_app/features/transactions/repositories/overspend_adjustment.dart';
import 'package:sqflite/sqflite.dart';

class TransferRepository {
  final DbService _dbService;

  const TransferRepository(this._dbService);

  Future<void> transferBalance({required TransferForm form}) async {
    final db = await _dbService.database;

    // FIX-01: min 1 global (TC-TRF-004) — checked before account presence
    // so a zero nominal always fails with the amount message.
    _assertPositiveAmount(form);
    if (form.accountSourceId == null ||
        form.accountDestinationId == null) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }

    await db.transaction((txn) async {
      await _recordTransfer(txn, form: form);
    });
  }

  /// FIX-07 (IMP-1): pindah dana dengan penyesuaian selisih otomatis bila
  /// nominal melebihi saldo efektif aset sumber. Satu `db.transaction`:
  /// Jurnal 1 penyesuaian selisih (sumber) + Jurnal 2 transfer biasa.
  /// Hanya aset sumber yang dilihat; `==saldo` langsung Jurnal 2.
  /// Q4: ganti aset sumber saat edit = tanpa previous (efektif = live).
  Future<void> transferBalanceAuto({
    required TransferForm form,
    int? previousAmount,
    int? previousSourceId,
  }) async {
    final db = await _dbService.database;

    // FIX-01: min 1 global (TC-TRF-004).
    _assertPositiveAmount(form);
    if (form.accountSourceId == null ||
        form.accountDestinationId == null) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }

    await db.transaction((txn) async {
      final live = await liveBalanceOf(txn, form.accountSourceId!);
      final effective = _effectiveSourceBalance(
        live: live,
        currentSourceId: form.accountSourceId!,
        previousAmount: previousAmount,
        previousSourceId: previousSourceId,
      );
      final shortfall = (form.amount ?? 0) - effective;
      if (shortfall > 0) {
        await insertShortfallAdjustment(
          txn,
          assetId: form.accountSourceId!,
          effectiveBalance: effective,
          shortfall: shortfall,
          date: form.date ?? DateTime.now(),
        );
      }
      await _recordTransfer(txn, form: form);
    });
  }

  /// FIX-07 edit flow: baca saldo sebelum void (hindari double-count),
  /// lalu void + penyesuaian selisih + catat baru dalam satu transaksi.
  Future<int> updateTransferAuto({
    required TransferForm form,
    required int id,
    int? previousAmount,
    int? previousSourceId,
  }) async {
    final db = await _dbService.database;

    // FIX-01: edit flow is guarded exactly like create (TC-TRF-004).
    _assertPositiveAmount(form);
    if (form.accountSourceId == null ||
        form.accountDestinationId == null) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }

    final journalId = await db.transaction((txn) async {
      final live = await liveBalanceOf(txn, form.accountSourceId!);
      final effective = _effectiveSourceBalance(
        live: live,
        currentSourceId: form.accountSourceId!,
        previousAmount: previousAmount,
        previousSourceId: previousSourceId,
      );
      final shortfall = (form.amount ?? 0) - effective;

      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.voided.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [id],
      );

      if (shortfall > 0) {
        await insertShortfallAdjustment(
          txn,
          assetId: form.accountSourceId!,
          effectiveBalance: effective,
          shortfall: shortfall,
          date: form.date ?? DateTime.now(),
        );
      }
      return await _recordTransfer(txn, form: form);
    });

    return journalId;
  }

  /// Saldo efektif sumber: previous hanya dihitung bila sumber tak berganti.
  int _effectiveSourceBalance({
    required int live,
    required int currentSourceId,
    int? previousAmount,
    int? previousSourceId,
  }) {
    if (previousAmount != null &&
        previousSourceId != null &&
        previousSourceId == currentSourceId) {
      return live + previousAmount;
    }
    return live;
  }

  Future<int> updateTransfer({
    required TransferForm form,
    required int id,
  }) async {
    final db = await _dbService.database;

    // FIX-01: edit flow is guarded exactly like create (TC-TRF-004).
    _assertPositiveAmount(form);
    if (form.accountSourceId == null ||
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

  /// FIX-14: sumber/tujuan arsip ditolak. Null = validasi presence.
  Future<void> _assertTransferAccountsActive(
    Transaction txn,
    TransferForm form,
  ) async {
    final ids = {
      if (form.accountSourceId != null) form.accountSourceId!,
      if (form.accountDestinationId != null) form.accountDestinationId!,
    };
    if (ids.isEmpty) return;
    final placeholders = List.filled(ids.length, '?').join(',');
    final rows = await txn.rawQuery(
      '''
      SELECT ${AccountKey.id}, ${AccountKey.name}
      FROM $accountTable
      WHERE ${AccountKey.id} IN ($placeholders)
        AND ${AccountKey.isDeleted} = 1
      ''',
      ids.toList(),
    );
    if (rows.isNotEmpty) {
      final name = rows.first[AccountKey.name];
      throw Exception(
        'Dompet "$name" sudah diarsipkan, pilih dompet aktif lain.',
      );
    }
  }

  void _assertPositiveAmount(TransferForm form) {
    if (form.amount == null || form.amount! <= 0) {
      throw Exception('Nominal harus lebih dari 0');
    }
  }

  Future<int> _recordTransfer(
    Transaction txn, {
    required TransferForm form,
  }) async {
    // FIX-14: tolak dompet arsip (sumber maupun tujuan).
    await _assertTransferAccountsActive(txn, form);
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
