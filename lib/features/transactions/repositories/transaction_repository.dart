import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/transactions/effective_balance.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/repositories/overspend_adjustment.dart';
import 'package:sqflite/sqflite.dart';

class TransactionRepository {
  final DbService _dbService;

  const TransactionRepository(this._dbService);

  Future<void> recordTransaction({
    required TransactionForm form,
    required TransactionType type,
  }) async {
    final db = await _dbService.database;

    // FIX-01: min 1 global — 0/null must never reach the journal.
    _assertPositiveAmounts(form);
    if (form.assetId == null) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }

    await db.transaction((txn) async {
      await _recordTransaction(txn, form: form, type: type);
    });
  }

  /// FIX-07 (IMP-1): catat dengan penyesuaian selisih otomatis bila
  /// pengeluaran melebihi saldo efektif. Satu `db.transaction` atomik:
  /// Jurnal 1 penyesuaian selisih + Jurnal 2 transaksi biasa.
  /// `nominal == effectiveBalance` langsung Jurnal 2 tanpa dialog/adjustment.
  /// Pemasukan selalu langsung Jurnal 2 (tanpa cek saldo).
  Future<void> recordTransactionAuto({
    required TransactionForm form,
    required TransactionType type,
    int? previousAmount,
    int? previousAssetId,
  }) async {
    final db = await _dbService.database;

    // FIX-01: min 1 global — 0/null must never reach the journal.
    _assertPositiveAmounts(form);
    if (form.assetId == null) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }

    await db.transaction((txn) async {
      if (type == .expense) {
        final live = await liveBalanceOf(txn, form.assetId!);
        final effective = computeEffectiveBalance(
          currentBalance: live,
          type: type,
          previousAmount: previousAmount,
          previousAssetId: previousAssetId,
          currentAssetId: form.assetId,
        );
        final shortfall = (form.totalAmount ?? 0) - effective;
        if (shortfall > 0) {
          await insertShortfallAdjustment(
            txn,
            assetId: form.assetId!,
            effectiveBalance: effective,
            shortfall: shortfall,
            date: form.date ?? DateTime.now(),
          );
        }
      }
      await _recordTransaction(txn, form: form, type: type);
    });
  }

  /// FIX-07 edit flow: void jurnal lama, lalu sama seperti [recordTransactionAuto].
  Future<int> updateTransactionAuto({
    required int id,
    required TransactionForm form,
    required TransactionType type,
    int? previousAmount,
    int? previousAssetId,
  }) async {
    final db = await _dbService.database;

    // FIX-01: edit flow is guarded exactly like create (TC-IN-005/OUT-005).
    _assertPositiveAmounts(form);

    final journalId = await db.transaction((txn) async {
      // Baca saldo SEBELUM void: jurnal lama masih posted sehingga
      // `previousAmount` tetap perlu ditambahkan kembali (sama-semantik
      // dengan halaman edit). Void dulu baru baca = double-count.
      int shortfall = 0;
      int effective = 0;
      if (type == .expense) {
        final live = await liveBalanceOf(txn, form.assetId!);
        effective = computeEffectiveBalance(
          currentBalance: live,
          type: type,
          previousAmount: previousAmount,
          previousAssetId: previousAssetId,
          currentAssetId: form.assetId,
        );
        shortfall = (form.totalAmount ?? 0) - effective;
      }

      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.voided.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [id],
      );

      if (shortfall > 0) {
        await insertShortfallAdjustment(
          txn,
          assetId: form.assetId!,
          effectiveBalance: effective,
          shortfall: shortfall,
          date: form.date ?? DateTime.now(),
        );
      }
      return await _recordTransaction(txn, form: form, type: type);
    });

    return journalId;
  }

  Future<int> updateTransaction({
    required int id,
    required TransactionForm form,
    required TransactionType type,
  }) async {
    final db = await _dbService.database;

    // FIX-01: edit flow is guarded exactly like create (TC-IN-005/OUT-005).
    _assertPositiveAmounts(form);

    final journalId = await db.transaction((txn) async {
      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.voided.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [id],
      );

      return await _recordTransaction(txn, form: form, type: type);
    });

    return journalId;
  }

  /// Rejects categories archived after the form was opened (stale selection).
  /// Selectors already exclude archived accounts; this guards the race.
  Future<void> _assertCategoriesNotArchived(
    Transaction txn,
    TransactionForm form,
  ) async {
    final ids = {
      for (final category in form.normalizedCategories)
        if (category.categoryId != null) category.categoryId!,
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
        'Kategori "$name" sudah diarsipkan, pilih kategori lain atau buat yang baru.',
      );
    }
  }

  /// FIX-14: tolak dompet arsip pada transaksi baru. Null = biar
  /// validasi presence yang bicara (jangan dobel pesan).
  Future<void> _assertAssetActive(Transaction txn, int? assetId) async {
    if (assetId == null) return;
    final rows = await txn.query(
      accountTable,
      columns: [AccountKey.id, AccountKey.name],
      where: '${AccountKey.id} = ? AND ${AccountKey.isDeleted} = 1',
      whereArgs: [assetId],
      limit: 1,
    );
    if (rows.isNotEmpty) {
      final name = rows.first[AccountKey.name];
      throw Exception(
        'Dompet "$name" sudah diarsipkan, pilih dompet aktif lain.',
      );
    }
  }

  /// Rejects null/zero/negative amounts per item and in total.
  void _assertPositiveAmounts(TransactionForm form) {
    final amounts = [
      form.totalAmount,
      for (final category in form.categories) category.amount,
    ];
    if (amounts.any((amount) => amount == null || amount <= 0)) {
      throw Exception('Nominal harus lebih dari 0');
    }
  }

  Future<int> _recordTransaction(
    Transaction txn, {
    required TransactionForm form,
    required TransactionType type,
  }) async {
    // FIX-12: tolak lembut kategori arsip — histori tetap jalan,
    // transaksi baru harus pilih kategori lain atau buat yang baru.
    // FIX-14: dompet arsip juga ditolak (selector sudah eksklusikan,
    // ini guard balapan stale selection).
    await _assertCategoriesNotArchived(txn, form);
    await _assertAssetActive(txn, form.assetId);

    final journalEntryId = await txn.rawInsert(
      '''
          INSERT INTO $journalEntryTable (
            ${JournalEntryKey.entryDate},
            ${JournalEntryKey.source},
            ${JournalEntryKey.description},
            ${JournalEntryKey.status}
          ) VALUES (?,?,?,?)
        ''',
      [
        (form.date ?? DateTime.now()).secondsSinceEpoch,
        JournalSource.transaction.value,
        form.note,
        JournalStatus.draft.name,
      ],
    );

    final accountResult = await txn.rawQuery(
      '''
          SELECT * FROM $accountBalanceView
          WHERE ${AccountKey.code} = ? AND ${AccountKey.type} = ?
          LIMIT 1
        ''',
      [
        type == .expense
            ? AccountPreset.otherExpense.code
            : AccountPreset.otherIncome.code,
        type == .expense ? AccountType.expense.value : AccountType.income.value,
      ],
    );

    if (accountResult.isEmpty) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }

    final otherAccount = Account.fromJson(accountResult.first);

    late List<Object?> arguments;
    if (type == .expense) {
      arguments = [
        journalEntryId,
        form.assetId,
        0,
        form.totalAmount,
        form.categories.length,
        null,
      ];
    } else {
      arguments = [journalEntryId, form.assetId, form.totalAmount, 0, 0, null];
    }

    for (final record in form.normalizedCategories.indexed) {
      final (index, category) = record;
      if (type == .expense) {
        arguments = [
          journalEntryId,
          category.categoryId ?? otherAccount.id,
          category.amount,
          0,
          index,
          category.note,

          ...arguments,
        ];
      } else {
        arguments = [
          ...arguments,

          journalEntryId,
          category.categoryId ?? otherAccount.id,
          0,
          category.amount,
          index + 1,
          category.note,
        ];
      }
    }

    final placeholder = List.generate(
      form.normalizedCategories.length + 1,
      (index) => '(?,?,?,?,?,?)',
    );

    await txn.rawInsert('''
        INSERT INTO $journalLineTable (
          ${JournalLineKey.journalEntryId},
          ${JournalLineKey.accountId},
          ${JournalLineKey.debitAmount},
          ${JournalLineKey.creditAmount},
          ${JournalLineKey.lineOrder},
          ${JournalLineKey.note}
        ) VALUES ${placeholder.join(', ')}
      ''', arguments);

    await txn.update(
      journalEntryTable,
      {JournalEntryKey.status: JournalStatus.posted.name},
      where: '${JournalEntryKey.id} = ?',
      whereArgs: [journalEntryId],
    );

    return journalEntryId;
  }
}
