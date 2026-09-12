import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/activities/extensions/activity_detail.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../helpers/test_db.dart';

/// Hapus belanja Target (hybrid J1<->J2): void satu kaki void keduanya,
/// tanpa jurnal hantu. Diuji lawan DB in-memory sungguhan, tanpa mock.
void main() {
  late DbService dbService;
  late Database db;
  late SavingRepository savings;
  late JournalRepository journals;

  setUp(() async {
    dbService = await createTestDbService();
    db = await dbService.database;
    savings = SavingRepository(dbService);
    journals = JournalRepository(dbService);
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  Future<int> accountIdByCode(String code) async {
    final result = await db.query(
      accountTable,
      where: '${AccountKey.code} = ?',
      whereArgs: [code],
      limit: 1,
    );
    expect(result, isNotEmpty, reason: 'seeded account $code should exist');
    return result.first[AccountKey.id] as int;
  }

  Future<int> balanceOf(int accountId) async {
    final result = await db.query(
      accountBalanceView,
      where: '${AccountKey.id} = ?',
      whereArgs: [accountId],
      limit: 1,
    );
    expect(result, isNotEmpty);
    return (result.first[AccountKey.balance] as num).toInt();
  }

  Future<void> fundAsset(int assetId, int amount) async {
    final initialId = await accountIdByCode(AccountPreset.intialBalance.code);
    final entryId = await db.insert(journalEntryTable, {
      JournalEntryKey.entryDate:
          DateTime(2026, 1, 1).millisecondsSinceEpoch ~/ 1000,
      JournalEntryKey.source: JournalSource.setup.value,
      JournalEntryKey.description: 'fund test asset',
      JournalEntryKey.status: JournalStatus.posted.name,
    });
    await db.insert(journalLineTable, {
      JournalLineKey.journalEntryId: entryId,
      JournalLineKey.accountId: assetId,
      JournalLineKey.debitAmount: amount,
      JournalLineKey.creditAmount: 0,
      JournalLineKey.lineOrder: 0,
    });
    await db.insert(journalLineTable, {
      JournalLineKey.journalEntryId: entryId,
      JournalLineKey.accountId: initialId,
      JournalLineKey.debitAmount: 0,
      JournalLineKey.creditAmount: amount,
      JournalLineKey.lineOrder: 1,
    });
  }

  /// Tunai 10jt, pocket VGA topup 500rb. Kembali (pocket, tunai, makan).
  Future<(int, int, int)> seed() async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);
    final foodId = await accountIdByCode(AccountPreset.food.code);
    final plan = await savings.createPocket(name: 'VGA');
    await savings.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 500000,
    );
    return (plan.accountId, cashId, foodId);
  }

  int pairedIdOf(String? metadata) {
    final json = jsonDecode(metadata!) as Map;
    return json['paired_entry_id'] as int;
  }

  test('hapus J2 (expense) cascade void J1 + saldo pulih penuh', () async {
    final (pocketId, cashId, foodId) = await seed();
    final spendId = await savings.spend(
      pocketId: pocketId,
      assetId: cashId,
      categoryId: foodId,
      amount: 100000,
    );
    expect(await balanceOf(pocketId), 400000);
    expect(await balanceOf(cashId), 9500000);

    final j2 = await journals.getJournal(spendId);
    expect(j2.isHybridSpendLeg, isTrue);
    final j1id = pairedIdOf(j2.metadata);
    expect((await journals.getJournal(j1id)).isHybridSpendLeg, isTrue);

    await journals.deleteJournal(spendId);

    expect(
      (await journals.getJournal(spendId)).status,
      JournalStatus.voided,
    );
    expect((await journals.getJournal(j1id)).status, JournalStatus.voided);
    expect(await balanceOf(pocketId), 500000);
    expect(await balanceOf(cashId), 9500000);
  });

  test('hapus J1 (tarik pocket) cascade void J2 + saldo pulih penuh',
      () async {
    final (pocketId, cashId, foodId) = await seed();
    final spendId = await savings.spend(
      pocketId: pocketId,
      assetId: cashId,
      categoryId: foodId,
      amount: 100000,
    );
    final j1id = pairedIdOf((await journals.getJournal(spendId)).metadata);

    await journals.deleteJournal(j1id);

    expect((await journals.getJournal(j1id)).status, JournalStatus.voided);
    expect(
      (await journals.getJournal(spendId)).status,
      JournalStatus.voided,
    );
    expect(await balanceOf(pocketId), 500000);
    expect(await balanceOf(cashId), 9500000);
  });

  test('jurnal biasa bukan kaki hybrid', () async {
    final (pocketId, cashId, _) = await seed();
    final topupRows = await db.query(
      journalEntryTable,
      columns: [JournalEntryKey.id],
      where: '${JournalEntryKey.source} = ? AND ${JournalEntryKey.status} = ?',
      whereArgs: [JournalSource.saving.value, JournalStatus.posted.name],
      orderBy: '${JournalEntryKey.id} DESC',
      limit: 1,
    );
    final topupId = topupRows.first[JournalEntryKey.id] as int;
    expect((await journals.getJournal(topupId)).isHybridSpendLeg, isFalse);
    expect(pocketId, isNotNull);
    expect(cashId, isNotNull);
  });
}
