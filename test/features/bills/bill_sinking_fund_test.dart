import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/savings/cubits/saving_detail_cubit.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../helpers/test_db.dart';

/// Link target sisihan <-> tagihan rutin tahunan + bayar dari target.
void main() {
  late DbService dbService;
  late Database db;
  late BillPlanRepository plans;
  late BillRepository bills;
  late SavingRepository savings;

  setUp(() async {
    dbService = await createTestDbService();
    db = await dbService.database;
    plans = BillPlanRepository(dbService);
    bills = BillRepository(dbService);
    savings = SavingRepository(dbService);
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

  Future<int> createExpenseCategory(String name) async {
    final form = CategoryForm();
    form.nameControl.updateValue(name);
    form.typeControl.updateValue(AccountType.expense);
    final account = await CategoryRepository(dbService).createCategory(
      form: form,
    );
    return account.id;
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

  int epochSec(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

  Future<int> createYearlyPlan() async {
    final categoryId = await createExpenseCategory('Pajak Motor');
    final plan = await plans.savePlan(
      accountId: categoryId,
      name: 'Pajak Motor',
      amount: 1200000,
      period: 'yearly',
      billedSchedule: '01-05',
      dueDateSchedule: '01-10',
      reminderDays: 3,
      bulkCreate: false,
    );
    return plan.id;
  }

  /// Tagihan unpaid siap bayar untuk [planId] + [period].
  Future<int> createUnpaidBill(int planId, String period) {
    return db.insert(billTable, {
      BillKey.billPlanId: planId,
      BillKey.amount: 1200000,
      BillKey.billPeriod: period,
      BillKey.billedAt: epochSec(DateTime(2026, 1, 5)),
      BillKey.dueDate: epochSec(DateTime(2026, 1, 10)),
      BillKey.remindedAt: epochSec(DateTime(2026, 1, 7)),
      BillKey.status: BillStatus.unpaid.value,
      BillKey.isDeleted: 0,
    });
  }

  Future<Map<String, Object?>> billRow(int billId) async {
    final rows = await db.query(
      billTable,
      where: '${BillKey.id} = ?',
      whereArgs: [billId],
      limit: 1,
    );
    expect(rows, isNotEmpty);
    return rows.first;
  }

  group('link target sisihan', () {
    test('createPocket menyimpan link + getLinkedTarget menemukannya', () async {
      final planId = await createYearlyPlan();

      final target = await savings.createPocket(
        name: 'Dana Pajak Motor',
        targetAmount: 1200000,
        targetDate: epochSec(DateTime(2026, 1, 10)),
        billPlanId: planId,
        billPeriod: '2026',
      );

      expect(target.billPlanId, planId);
      expect(target.billPeriod, '2026');
      expect(target.isBillSinkingFund, isTrue);

      final found = await savings.getLinkedTarget(planId, '2026');
      expect(found, isNotNull);
      expect(found!.accountId, target.accountId);
    });

    test('tanpa link: getLinkedTarget null, target biasa tak terdampak',
        () async {
      final planId = await createYearlyPlan();
      await savings.createPocket(name: 'VGA', targetAmount: 5000000);

      expect(await savings.getLinkedTarget(planId, '2026'), isNull);
    });

    test('satu plan + periode yang sama ditolak (unique), beda tahun boleh',
        () async {
      final planId = await createYearlyPlan();
      await savings.createPocket(
        name: 'Dana 2026',
        targetAmount: 1200000,
        billPlanId: planId,
        billPeriod: '2026',
      );

      expect(
        () => savings.createPocket(
          name: 'Dana 2026 duplikat',
          targetAmount: 1200000,
          billPlanId: planId,
          billPeriod: '2026',
        ),
        throwsA(anything),
      );

      final next = await savings.createPocket(
        name: 'Dana 2027',
        targetAmount: 1200000,
        billPlanId: planId,
        billPeriod: '2027',
      );
      expect(next.billPeriod, '2027');
    });

    test('deletePlan me-null-kan link, target hidup sebagai target biasa',
        () async {
      final planId = await createYearlyPlan();
      final target = await savings.createPocket(
        name: 'Dana Pajak Motor',
        targetAmount: 1200000,
        billPlanId: planId,
        billPeriod: '2026',
      );

      await plans.deletePlan(planId);

      expect(await savings.getLinkedTarget(planId, '2026'), isNull);
      final kept = await savings.getByAccountId(target.accountId);
      expect(kept, isNotNull);
      expect(kept!.billPlanId, isNull);
      expect(kept.isBillSinkingFund, isFalse);
    });
  });

  group('payBillFromPocket', () {
    test('sukses: pocket berkurang, dompet neto 0, tagihan lunas', () async {
      final cashId = await accountIdByCode(AccountPreset.cash.code);
      await fundAsset(cashId, 10000000);

      final planId = await createYearlyPlan();
      final billId = await createUnpaidBill(planId, '2026');
      final target = await savings.createPocket(
        name: 'Dana Pajak Motor',
        targetAmount: 1200000,
        billPlanId: planId,
        billPeriod: '2026',
      );
      await savings.topup(
        pocketId: target.accountId,
        assetId: cashId,
        amount: 1200000,
      );

      await bills.payBillFromPocket(
        billId: billId,
        pocketId: target.accountId,
        assetId: cashId,
      );

      expect((await billRow(billId))[BillKey.status], BillStatus.paid.value);
      expect(await balanceOf(target.accountId), 0);
      // Dompet perantara: diisi withdraw lalu dipakai bayar → neto sama.
      expect(await balanceOf(cashId), 10000000 - 1200000);

      final paymentJournals = await db.query(
        journalEntryTable,
        where: '${JournalEntryKey.sourceId} = ? AND ${JournalEntryKey.source} = ?',
        whereArgs: [billId, JournalSource.billPayment.value],
      );
      expect(paymentJournals, hasLength(1));
      final withdrawJournals = await db.query(
        journalEntryTable,
        where: '${JournalEntryKey.source} = ?',
        whereArgs: [JournalSource.saving.value],
      );
      // topup + withdraw.
      expect(withdrawJournals, hasLength(2));
    });

    test('saldo target kurang: gagal, tagihan tetap unpaid (atomik)', () async {
      final cashId = await accountIdByCode(AccountPreset.cash.code);
      await fundAsset(cashId, 10000000);

      final planId = await createYearlyPlan();
      final billId = await createUnpaidBill(planId, '2026');
      final target = await savings.createPocket(
        name: 'Dana Pajak Motor',
        targetAmount: 1200000,
        billPlanId: planId,
        billPeriod: '2026',
      );
      await savings.topup(
        pocketId: target.accountId,
        assetId: cashId,
        amount: 100000,
      );

      expect(
        () => bills.payBillFromPocket(
          billId: billId,
          pocketId: target.accountId,
          assetId: cashId,
        ),
        throwsA(isA<Exception>()),
      );

      expect((await billRow(billId))[BillKey.status], BillStatus.unpaid.value);
      expect(await balanceOf(target.accountId), 100000);
    });

    test('tagihan sudah lunas: ditolak', () async {
      final cashId = await accountIdByCode(AccountPreset.cash.code);
      await fundAsset(cashId, 10000000);

      final planId = await createYearlyPlan();
      final billId = await createUnpaidBill(planId, '2026');
      final target = await savings.createPocket(
        name: 'Dana Pajak Motor',
        targetAmount: 1200000,
        billPlanId: planId,
        billPeriod: '2026',
      );
      await savings.topup(
        pocketId: target.accountId,
        assetId: cashId,
        amount: 2400000,
      );

      await bills.payBillFromPocket(
        billId: billId,
        pocketId: target.accountId,
        assetId: cashId,
      );
      expect(
        () => bills.payBillFromPocket(
          billId: billId,
          pocketId: target.accountId,
          assetId: cashId,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('sync nominal', () {
    test('updateTargetAmount menyamakan nominal target', () async {
      final planId = await createYearlyPlan();
      final target = await savings.createPocket(
        name: 'Dana Pajak Motor',
        targetAmount: 1200000,
        billPlanId: planId,
        billPeriod: '2026',
      );

      final updated = await savings.updateTargetAmount(
        accountId: target.accountId,
        targetAmount: 1500000,
      );

      expect(updated, isNotNull);
      expect(updated!.targetAmount, 1500000);
      expect(updated.billPlanId, planId);
    });
  });

  group('bayar dari detail target', () {
    test('getBillByPlanAndPeriod menemukan tagihan kemunculan', () async {
      final planId = await createYearlyPlan();
      final billId = await createUnpaidBill(planId, '2026');

      final found = await bills.getBillByPlanAndPeriod(planId, '2026');
      expect(found, isNotNull);
      expect(found!.id, billId);

      expect(await bills.getBillByPlanAndPeriod(planId, '2027'), isNull);
      expect(await bills.getBillByPlanAndPeriod(planId + 9999, '2026'), isNull);
    });

    test('SavingDetailCubit memuat linkedBill + payLinkedBill lunas', () async {
      final cashId = await accountIdByCode(AccountPreset.cash.code);
      await fundAsset(cashId, 10000000);

      final planId = await createYearlyPlan();
      await createUnpaidBill(planId, '2026');
      final target = await savings.createPocket(
        name: 'Dana Pajak Motor',
        targetAmount: 1200000,
        targetDate: epochSec(DateTime(2026, 1, 10)),
        billPlanId: planId,
        billPeriod: '2026',
      );
      await savings.topup(
        pocketId: target.accountId,
        assetId: cashId,
        amount: 1200000,
      );

      final cubit = SavingDetailCubit(savings, bills);
      addTearDown(cubit.close);
      await cubit.fetch(target.accountId);
      final detail = cubit.state.maybeWhen(
        loaded: (detail) => detail,
        orElse: () => throw StateError('expected loaded, got ${cubit.state}'),
      );
      expect(detail.linkedBill, isNotNull);
      expect(detail.linkedBill!.billPeriod, '2026');

      final error = await cubit.payLinkedBill(assetId: cashId);
      expect(error, isNull);

      final paid = await bills.getBillByPlanAndPeriod(planId, '2026');
      expect(paid!.isPaid, isTrue);
      expect(await balanceOf(target.accountId), 0);
    });

    test('payLinkedBill tanpa tagihan mengembalikan pesan error', () async {
      final target = await savings.createPocket(name: 'VGA');

      final cubit = SavingDetailCubit(savings, bills);
      addTearDown(cubit.close);
      await cubit.fetch(target.accountId);

      final error = await cubit.payLinkedBill(assetId: 1);
      expect(error, isNotNull);
    });

    test('belanja dari target sisihan ditolak di repo', () async {
      final cashId = await accountIdByCode(AccountPreset.cash.code);
      await fundAsset(cashId, 10000000);

      final planId = await createYearlyPlan();
      final target = await savings.createPocket(
        name: 'Dana Pajak Motor',
        targetAmount: 1200000,
        billPlanId: planId,
        billPeriod: '2026',
      );
      await savings.topup(
        pocketId: target.accountId,
        assetId: cashId,
        amount: 500000,
      );

      expect(
        () => savings.spend(
          pocketId: target.accountId,
          assetId: cashId,
          amount: 100000,
        ),
        throwsA(isA<Exception>()),
      );
      // Dana utuh, tidak berkurang oleh belanja yang ditolak.
      expect(await balanceOf(target.accountId), 500000);
    });
  });
}
