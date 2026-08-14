import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/transactions/forms/balance_adjustment_form.dart';
import 'package:dompet_app/features/transactions/models/balance_adjustment.dart';

class BalanceAdjustmentRepository {
  final DbService _dbService;

  BalanceAdjustmentRepository(this._dbService);

  Future<void> adjustBalance({required BalanceAdjustmentForm form}) async {
    final db = await _dbService.database;

    if (form.invalid) {
      throw Exception('Terjadi kesalahan data: Form invalid');
    }

    await db.transaction((txn) async {
      final now = DateTime.now();

      final [assetResult, equityResult] = await Future.wait([
        txn.rawQuery(
          '''
        SELECT *
        FROM $accountBalanceView
        WHERE ${AccountKey.id} = ?
      ''',
          [form.account!.id],
        ),
        txn.rawQuery(
          '''
        SELECT *
        FROM $accountBalanceView
        WHERE ${AccountKey.code} = ?
      ''',
          [AccountPreset.balanceAdjustment.code],
        ),
      ]);

      if (assetResult.isEmpty || equityResult.isEmpty) {
        throw Exception('Terjadi kesalahan data: Akun tidak ditemukan');
      }

      final assetAccount = Account.fromJson(assetResult.first);
      final equityAccount = Account.fromJson(equityResult.first);

      final balanceAdjustment = BalanceAdjustment(
        currentBalance: form.amount ?? 0,
        previousBalance: assetAccount.balance,
      );

      final journalEntryId = await txn.insert(journalEntryTable, {
        JournalEntryKey.entryDate: now.secondsSinceEpoch,
        JournalEntryKey.source: JournalSource.adjustment.value,
        JournalEntryKey.status: JournalStatus.draft.name,
        JournalEntryKey.metadata: jsonEncode(balanceAdjustment.toJson()),
      });

      await Future.wait([
        txn.insert(journalLineTable, {
          JournalLineKey.journalEntryId: journalEntryId,
          JournalLineKey.creditAmount: 0,
          JournalLineKey.debitAmount: balanceAdjustment.difference.abs(),
          JournalLineKey.lineOrder: 0,
          JournalLineKey.accountId: balanceAdjustment.difference > 0
              ? assetAccount.id
              : equityAccount.id,
        }),
        txn.insert(journalLineTable, {
          JournalLineKey.journalEntryId: journalEntryId,
          JournalLineKey.creditAmount: balanceAdjustment.difference.abs(),
          JournalLineKey.debitAmount: 0,
          JournalLineKey.lineOrder: 1,
          JournalLineKey.accountId: balanceAdjustment.difference > 0
              ? equityAccount.id
              : assetAccount.id,
        }),
      ]);

      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.posted.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [journalEntryId],
      );
    });
  }
}
