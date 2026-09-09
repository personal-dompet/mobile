import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/savings/models/saving_detail.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../helpers/test_db.dart';

void main() {
  late DbService dbService;
  late Database db;
  late SavingRepository repository;

  setUp(() async {
    dbService = await createTestDbService();
    db = await dbService.database;
    repository = SavingRepository(dbService);
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
    return result.first[AccountKey.id] as int;
  }

  Future<void> fundAsset(int assetId, int amount) async {
    final initialId = await accountIdByCode(
      AccountPreset.intialBalance.code,
    );
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

  test('getPocketJournals mengembalikan full histori pocket terbaru dulu',
      () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    final foodId = await accountIdByCode(AccountPreset.food.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(
      name: 'VGA',
      targetAmount: 5000000,
    );
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 1000000,
      date: DateTime(2026, 8, 27, 10),
    );
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 500000,
      date: DateTime(2026, 9, 1, 10),
    );
    await repository.withdraw(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 100000,
      date: DateTime(2026, 9, 2, 10),
    );
    await repository.spend(
      pocketId: plan.accountId,
      assetId: cashId,
      categoryId: foodId,
      amount: 50000,
      date: DateTime(2026, 9, 3, 10),
    );

    // Pocket lain tidak boleh bocor ke histori ini.
    final other = await repository.createPocket(name: 'Liburan');
    await repository.topup(
      pocketId: other.accountId,
      assetId: cashId,
      amount: 700000,
      date: DateTime(2026, 9, 3, 11),
    );

    final journals = await repository.getPocketJournals(plan.accountId);

    expect(journals, hasLength(4));
    // Terbaru dulu.
    for (var i = 0; i < journals.length - 1; i++) {
      expect(
        journals[i].entryDate >= journals[i + 1].entryDate,
        isTrue,
        reason: 'riwayat harus terurut terbaru dulu',
      );
    }
    for (final journal in journals) {
      expect(journal.source, JournalSource.saving);
      expect(journal.status, JournalStatus.posted);
      expect(
        journal.lines.any((line) => line.accountId == plan.accountId),
        isTrue,
      );
    }
  });

  test('SavingDetail.compute menghitung 2 topup dari histori DB', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(
      name: 'VGA',
      targetAmount: 5000000,
    );
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 1000000,
      date: DateTime(2026, 8, 27, 10),
    );
    await repository.topup(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 500000,
      date: DateTime(2026, 9, 1, 10),
    );

    final fetched = await repository.getByAccountId(plan.accountId);
    final journals = await repository.getPocketJournals(plan.accountId);
    final detail = SavingDetail.compute(
      plan: fetched!,
      activities: journals,
      now: DateTime(2026, 9, 4, 12),
    );

    expect(detail.transactionCount, 2);
    expect(detail.insight.topupCount, 2);
    expect(detail.insight.totalTopup, 1500000);
    expect(detail.insight.addedThisMonth, 500000);
  });
}
