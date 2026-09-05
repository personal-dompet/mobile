import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';

import '../../helpers/test_db.dart';

export '../../helpers/test_db.dart';

int sec(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

/// Dependensi umum test reporting: database + id akun seed yang sering dipakai.
class ReportTestDeps {
  ReportTestDeps._(
    this.db, {
    required this.cashId,
    required this.salaryId,
    required this.foodId,
  });

  final DbService db;
  final int cashId;
  final int salaryId;
  final int foodId;

  Future<void> dispose() => disposeTestDbService(db);
}

Future<ReportTestDeps> createReportTestDeps() async {
  final db = await createTestDbService();
  return ReportTestDeps._(
    db,
    cashId: await accountId(db, '101.0001'),
    salaryId: await accountId(db, '401.0001'),
    foodId: await accountId(db, '501.0001'),
  );
}

Future<int> accountId(DbService db, String code) async {
  final conn = await db.database;
  final rows = await conn.query(
    accountTable,
    where: '${AccountKey.code} = ?',
    whereArgs: [code],
  );
  return rows.first[AccountKey.id] as int;
}

/// Sisipkan satu jurnal transaksi: 1 baris aset + 1 baris kategori.
///
/// Untuk expense: debit kategori, kredit aset.
/// Untuk income: debit aset, kredit kategori.
Future<void> insertTransaction({
  required DbService db,
  required DateTime date,
  required int assetId,
  required int categoryId,
  required int amount,
  required bool isExpense,
  JournalSource source = JournalSource.transaction,
}) async {
  final conn = await db.database;
  final journalId = await conn.rawInsert(
    '''
    INSERT INTO $journalEntryTable (
      ${JournalEntryKey.entryDate},
      ${JournalEntryKey.source},
      ${JournalEntryKey.description},
      ${JournalEntryKey.status}
    ) VALUES (?,?,?,?)
    ''',
    [sec(date), source.value, 'test', JournalStatus.posted.name],
  );
  if (isExpense) {
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
      [
        journalId, categoryId, amount, 0, 0,
        journalId, assetId, 0, amount, 1,
      ],
    );
  } else {
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
      [
        journalId, assetId, amount, 0, 0,
        journalId, categoryId, 0, amount, 1,
      ],
    );
  }
}

/// Pocket tabungan non-likuid seperti yang dibuat SavingRepository
/// (kode child 101.0006.xxxx, isLiquid 0).
Future<int> createPocketAccount(DbService db) async {
  final conn = await db.database;
  return conn.rawInsert(
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
}

/// Sisipkan satu jurnal tabungan mengikuti struktur SavingRepository:
/// TOPUP = kredit aset + debit pocket, WITHDRAW sebaliknya,
/// SPEND = kredit pocket + debit kategori expense.
Future<void> insertSaving({
  required DbService db,
  required DateTime date,
  required int pocketId,
  int? assetId,
  int? categoryId,
  required int amount,
  required SavingTxType tx,
}) async {
  final conn = await db.database;
  final journalId = await conn.rawInsert(
    '''
    INSERT INTO $journalEntryTable (
      ${JournalEntryKey.entryDate},
      ${JournalEntryKey.source},
      ${JournalEntryKey.description},
      ${JournalEntryKey.status},
      ${JournalEntryKey.metadata}
    ) VALUES (?,?,?,?,?)
    ''',
    [
      sec(date),
      JournalSource.saving.value,
      'test saving',
      JournalStatus.posted.name,
      jsonEncode({'saving_tx': tx.value, 'pocket_id': pocketId}),
    ],
  );

  late List<Object?> args;
  switch (tx) {
    case SavingTxType.topup:
      args = [
        journalId, assetId, 0, amount, 0,
        journalId, pocketId, amount, 0, 1,
      ];
    case SavingTxType.withdraw:
      args = [
        journalId, pocketId, 0, amount, 0,
        journalId, assetId, amount, 0, 1,
      ];
    case SavingTxType.spend:
      args = [
        journalId, pocketId, 0, amount, 0,
        journalId, categoryId, amount, 0, 1,
      ];
  }

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
    args,
  );
}
