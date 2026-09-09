import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/savings/models/saving_filter.dart';
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

  /// Danai asset cair via jurnal setup (debit asset, credit saldo awal).
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

  test('createPocket menyimpan 1 row saving_plans + akun ASSET non-liquid',
      () async {
    final plan = await repository.createPocket(
      name: 'VGA',
      targetAmount: 5000000,
    );

    expect(plan.accountName, 'VGA');
    expect(plan.balance, 0);
    expect(plan.targetAmount, 5000000);

    final accountRows = await db.query(
      accountTable,
      where: '${AccountKey.id} = ?',
      whereArgs: [plan.accountId],
    );
    expect(accountRows.first[AccountKey.type], AccountType.asset.value);
    expect(accountRows.first[AccountKey.isLiquid], 0);
    expect(
      (accountRows.first[AccountKey.code] as String).startsWith('101.0006'),
      isTrue,
    );
  });

  test('topup mengurangi asset cair dan menambah pocket (balance)', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(name: 'VGA');
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);

    expect(await balanceOf(cashId), 9000000);
    expect(await balanceOf(plan.accountId), 1000000);
  });

  test('multi-asset topup terakumulasi sebagai total pocket', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    final bankId = await accountIdByCode(AccountPreset.bank.code);
    await fundAsset(cashId, 5000000);
    await fundAsset(bankId, 5000000);

    final plan = await repository.createPocket(name: 'VGA');
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);
    await repository.topup(pocketId: plan.accountId, assetId: bankId, amount: 2000000);

    expect(await balanceOf(plan.accountId), 3000000);

    final pockets = await repository.getPockets(const SavingFilter());
    expect(pockets.firstWhere((p) => p.accountId == plan.accountId).balance, 3000000);
  });

  test('spend mengurangi pocket saja, asset cair tidak tersentuh', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    final foodId = await accountIdByCode(AccountPreset.food.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(name: 'VGA');
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);
    await repository.spend(
      pocketId: plan.accountId,
      assetId: cashId,
      categoryId: foodId,
      amount: 500000,
    );

    expect(await balanceOf(plan.accountId), 500000);
    expect(await balanceOf(cashId), 9000000,
        reason: 'spend hybrid: Jurnal 1 isi dompet, Jurnal 2 pakai — neto 0');
    expect(await balanceOf(foodId), 500000);
  });

  test('spend tanpa kategori fallback ke Lain-Lain (Q7)', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(name: 'VGA');
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);
    final journalId = await repository.spend(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 300000,
    );

    expect(await balanceOf(plan.accountId), 700000);
    expect(await balanceOf(cashId), 9000000,
        reason: 'hybrid neto dompet 0');

    final otherId = await accountIdByCode(AccountPreset.otherExpense.code);
    final lines = await db.query(
      journalLineTable,
      where: '${JournalLineKey.journalEntryId} = ?',
      whereArgs: [journalId],
    );
    expect(
      lines.any((l) =>
          l[JournalLineKey.accountId] == otherId &&
          (l[JournalLineKey.debitAmount] as num).toInt() == 300000),
      isTrue,
      reason: 'Jurnal 2 debit Lain-Lain',
    );
  });

  test('withdraw mengembalikan dana ke asset cair', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(name: 'VGA');
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);
    await repository.withdraw(
      pocketId: plan.accountId,
      assetId: cashId,
      amount: 400000,
    );

    expect(await balanceOf(plan.accountId), 600000);
    expect(await balanceOf(cashId), 9400000);
  });

  test('setiap jurnal saving balance (debit == credit)', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    final foodId = await accountIdByCode(AccountPreset.food.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(name: 'VGA');
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);
    await repository.spend(pocketId: plan.accountId, assetId: cashId, categoryId: foodId, amount: 200000);
    await repository.withdraw(pocketId: plan.accountId, assetId: cashId, amount: 100000);

    final rows = await db.rawQuery('''
      SELECT
        ${JournalLineKey.journalEntryId},
        SUM(${JournalLineKey.debitAmount}) AS total_debit,
        SUM(${JournalLineKey.creditAmount}) AS total_credit
      FROM $journalLineTable
      GROUP BY ${JournalLineKey.journalEntryId}
    ''');

    for (final row in rows) {
      expect(row['total_debit'], row['total_credit'],
          reason:
              'journal entry ${row[JournalLineKey.journalEntryId]} must balance');
    }
  });

  test('v_saving_tracker menghitung progress sebagai rasio', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(
      name: 'VGA',
      targetAmount: 5000000,
    );
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);

    final fetched = await repository.getByAccountId(plan.accountId);
    expect(fetched!.progress, closeTo(0.2, 0.0001));
    expect(fetched.progressRatio, closeTo(0.2, 0.0001));
    expect(fetched.remaining, 4000000);
    expect(fetched.isTargetReached, isFalse);
  });

  test('pocket tanpa target punya progress null', () async {
    final plan = await repository.createPocket(name: 'Celengan');
    final fetched = await repository.getByAccountId(plan.accountId);
    expect(fetched!.targetAmount, isNull);
    expect(fetched.progress, isNull);
    expect(fetched.hasTarget, isFalse);
  });

  test('delete mengunci topup lanjutan', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(name: 'VGA');
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);
    await repository.delete(plan.accountId);

    final deleted = await repository.getByAccountId(plan.accountId);
    expect(deleted, isNull);

    expect(
      () => repository.topup(
        pocketId: plan.accountId,
        assetId: cashId,
        amount: 100000,
      ),
      throwsException,
    );
  });

  test('getPockets dengan filter status ACTIVE (path SavingCubit)', () async {
    await repository.createPocket(name: 'VGA');
    await repository.createPocket(name: 'Liburan');

    final active = await repository.getPockets(
      const SavingFilter(status: 'ACTIVE'),
    );
    expect(active, hasLength(2));

    await repository.delete(active.first.accountId);

    final activeAfter = await repository.getPockets(
      const SavingFilter(status: 'ACTIVE'),
    );
    expect(activeAfter, hasLength(1));
  });

  test('getPockets dengan filter nama + status', () async {
    await repository.createPocket(name: 'VGA RTX');
    await repository.createPocket(name: 'Liburan Bali');

    final result = await repository.getPockets(
      const SavingFilter(accountName: 'vga', status: 'ACTIVE'),
    );
    expect(result, hasLength(1));
    expect(result.first.accountName, 'VGA RTX');
  });

  test('deleteWithWithdraw mengembalikan sisa penuh lalu menghapus', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(
      name: 'VGA',
      targetAmount: 1000000,
    );
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);

    final journalId = await repository.deleteWithWithdraw(
      accountId: plan.accountId,
      assetId: cashId,
    );
    expect(journalId, isNotNull);

    // Sisa kembali utuh, pocket kosong dan ter-soft-delete.
    expect(await balanceOf(plan.accountId), 0);
    expect(await balanceOf(cashId), 10000000);

    final deleted = await repository.getByAccountId(plan.accountId);
    expect(deleted, isNull);

    // Jurnal penghapus tetap seimbang.
    final rows = await db.rawQuery('''
      SELECT
        SUM(${JournalLineKey.debitAmount}) AS total_debit,
        SUM(${JournalLineKey.creditAmount}) AS total_credit
      FROM $journalLineTable
      WHERE ${JournalLineKey.journalEntryId} = ?
    ''', [journalId]);
    expect(rows.first['total_debit'], rows.first['total_credit']);
    expect(rows.first['total_debit'], 1000000);
  });

  test('deleteWithWithdraw saldo 0 langsung hapus tanpa jurnal', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);

    final plan = await repository.createPocket(name: 'VGA');

    final journalsBefore =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $journalEntryTable'),
        ) ??
        0;

    final journalId = await repository.deleteWithWithdraw(
      accountId: plan.accountId,
      assetId: cashId,
    );
    expect(journalId, isNull);

    final journalsAfter =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $journalEntryTable'),
        ) ??
        0;
    expect(journalsAfter, journalsBefore);

    final deleted = await repository.getByAccountId(plan.accountId);
    expect(deleted, isNull);
  });

  test('overshoot: topup melebihi target tetap diterima', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 10000000);

    final plan = await repository.createPocket(
      name: 'VGA',
      targetAmount: 1000000,
    );
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 1000000);
    await repository.topup(pocketId: plan.accountId, assetId: cashId, amount: 200000);

    expect(await balanceOf(plan.accountId), 1200000);

    final fetched = await repository.getByAccountId(plan.accountId);
    expect(fetched!.isTargetReached, isTrue);
    expect(fetched.progressRatio, closeTo(1.2, 0.0001));
  });

  test('buat beruntun nama sama menghasilkan kode unik monotonik', () async {
    final first = await repository.createPocket(name: 'Testing');
    final second = await repository.createPocket(name: 'Testing');

    expect(first.accountName, 'Testing');
    expect(second.accountName, 'Testing');
    expect(first.accountId, isNot(second.accountId));
    expect(first.accountCode, '101.0006.0001');
    expect(second.accountCode, '101.0006.0002');
  });

  test('kode tidak dipakai ulang setelah hapus', () async {
    final first = await repository.createPocket(name: 'Testing');
    final second = await repository.createPocket(name: 'Testing');
    await repository.delete(second.accountId);

    final third = await repository.createPocket(name: 'Testing');

    expect(first.accountCode, '101.0006.0001');
    expect(third.accountCode, '101.0006.0003');
  });

  test('topup melebihi saldo asset ditolak', () async {
    final cashId = await accountIdByCode(AccountPreset.cash.code);
    await fundAsset(cashId, 100000);

    final plan = await repository.createPocket(name: 'VGA');

    expect(
      () => repository.topup(
        pocketId: plan.accountId,
        assetId: cashId,
        amount: 500000,
      ),
      throwsException,
    );
  });
}
