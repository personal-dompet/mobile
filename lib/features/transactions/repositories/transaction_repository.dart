import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:sqflite/sqflite.dart';

class TransactionRepository {
  final DbService _dbService;

  const TransactionRepository(this._dbService);

  Future<void> recordTransaction({
    required TransactionForm form,
    required TransactionType type,
  }) async {
    final db = await _dbService.database;

    if (form.categories.any((element) => element.amount == null) ||
        form.assetId == null) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }

    await db.transaction((txn) async {
      await _recordTransaction(txn, form: form, type: type);
    });
  }

  Future<int> updateTransaction({
    required int id,
    required TransactionForm form,
    required TransactionType type,
  }) async {
    final db = await _dbService.database;

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

  Future<int> _recordTransaction(
    Transaction txn, {
    required TransactionForm form,
    required TransactionType type,
  }) async {
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
        type == .expense
            ? AccountTypeName.expense.value
            : AccountTypeName.income.value,
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
