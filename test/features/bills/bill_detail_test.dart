import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/models/bill_filter.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

/// Model Bill (status turunan waktu) + repo list + hapus plan.
void main() {
  late DbService dbService;

  setUp(() async {
    dbService = await createTestDbService();
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  Bill makeBill({
    required String status,
    required int remindedAt,
    required int dueDate,
  }) {
    return Bill(
      id: 1,
      billPlanId: 1,
      amount: 100000,
      billPeriod: '2026-09',
      billedAt: remindedAt - 86400,
      dueDate: dueDate,
      remindedAt: remindedAt,
      status: status,
    );
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

  Future<int> accountIdByCode(String code) async {
    final db = await dbService.database;
    final rows = await db.query(
      accountTable,
      where: '${AccountKey.code} = ?',
      whereArgs: [code],
    );
    return rows.first[AccountKey.id] as int;
  }

  /// Plan + satu tagihan unpaid siap bayar.
  Future<int> createUnpaidBill() async {
    final plans = BillPlanRepository(dbService);
    final accountId = await createExpenseCategory('Listrik');
    final plan = await plans.savePlan(
      accountId: accountId,
      name: 'Listrik',
      amount: 100000,
      period: 'monthly',
      billedSchedule: '5',
      dueDateSchedule: '10',
      reminderDays: 3,
      bulkCreate: false,
    );
    final db = await dbService.database;
    final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return db.insert(billTable, {
      BillKey.billPlanId: plan.id,
      BillKey.amount: 100000,
      BillKey.billPeriod: '2026-09',
      BillKey.billedAt: nowSec - 86400,
      BillKey.dueDate: nowSec + 5 * 86400,
      BillKey.remindedAt: nowSec - 86400,
      BillKey.status: BillStatus.unpaid.value,
      BillKey.isDeleted: 0,
    });
  }

  group('Bill status turunan waktu', () {
    // now = 2026-09-15 12:00.
    final now = DateTime(2026, 9, 15, 12);
    final nowSec = now.millisecondsSinceEpoch ~/ 1000;
    const day = 86400;

    test('unpaid lewat due → overdue, bukan reminder', () {
      final bill = makeBill(
        status: BillStatus.unpaid.value,
        remindedAt: nowSec - 5 * day,
        dueDate: nowSec - day,
      );
      expect(bill.isOverdueAt(now), isTrue);
      expect(bill.isDueReminderAt(now), isFalse);
    });

    test('unpaid di jendela reminder → reminder, bukan overdue', () {
      final bill = makeBill(
        status: BillStatus.unpaid.value,
        remindedAt: nowSec - day,
        dueDate: nowSec + 2 * day,
      );
      expect(bill.isDueReminderAt(now), isTrue);
      expect(bill.isOverdueAt(now), isFalse);
    });

    test('paid lewat due tetap bukan overdue', () {
      final bill = makeBill(
        status: BillStatus.paid.value,
        remindedAt: nowSec - 5 * day,
        dueDate: nowSec - day,
      );
      expect(bill.isOverdueAt(now), isFalse);
    });

    test('drafted tidak pernah overdue/reminder', () {
      final bill = makeBill(
        status: BillStatus.drafted.value,
        remindedAt: nowSec - 5 * day,
        dueDate: nowSec - day,
      );
      expect(bill.isOverdueAt(now), isFalse);
      expect(bill.isDueReminderAt(now), isFalse);
    });
  });

  group('BillRepository.getBills', () {    test('paginasi + total + filter status', () async {
      final plans = BillPlanRepository(dbService);
      final bills = BillRepository(dbService);
      final accountId = await createExpenseCategory('Listrik');

      final first =
          DateTime.now().add(const Duration(days: 1));
      final plan = await plans.savePlan(
        accountId: accountId,
        name: 'Listrik',
        amount: 100000,
        period: 'monthly',
        billedSchedule: first.day.toString(),
        dueDateSchedule: 'last_day',
        reminderDays: 3,
        endedAt: DateTime(first.year, first.month + 3, 1),
        bulkCreate: true,
      );

      final page1 = await bills.getBills(
        pagination: Pagination(page: 1, limit: 2),
        filter: BillFilter(billPlanId: plan.id),
      );
      expect(page1.items, hasLength(2));
      expect(page1.meta.total, 3);

      final page2 = await bills.getBills(
        pagination: Pagination(page: 2, limit: 2),
        filter: BillFilter(billPlanId: plan.id),
      );
      expect(page2.items, hasLength(1));

      final paid = await bills.getBills(
        pagination: Pagination(page: 1, limit: 20),
        filter: BillFilter(
          billPlanId: plan.id,
          statuses: [BillStatus.paid.value],
        ),
      );
      expect(paid.items, isEmpty);
      expect(paid.meta.total, 0);
    });
  });

  group('BillPlanRepository.deletePlan', () {
    test('plan + draft terhapus lemas, unpaid aktif utuh', () async {
      final plans = BillPlanRepository(dbService);
      final accountId = await createExpenseCategory('Air');

      final plan = await plans.savePlan(
        accountId: accountId,
        name: 'Air',
        amount: 50000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        endedAt: DateTime.now().add(const Duration(days: 60)),
        bulkCreate: true,
      );

      final db = await dbService.database;
      await db.insert(billTable, {
        BillKey.billPlanId: plan.id,
        BillKey.amount: 50000,
        BillKey.billPeriod: '2026-01',
        BillKey.billedAt: 1,
        BillKey.dueDate: 2,
        BillKey.remindedAt: 1,
        BillKey.status: BillStatus.unpaid.value,
        BillKey.isDeleted: 0,
      });

      await plans.deletePlan(plan.id);

      expect(await plans.getById(plan.id), isNull);

      final rows = await db.query(
        billTable,
        where: '${BillKey.billPlanId} = ?',
        whereArgs: [plan.id],
      );
      final drafts = rows.where(
        (r) => r[BillKey.status] == BillStatus.drafted.value,
      );
      expect(drafts.map((r) => r[BillKey.isDeleted]), everyElement(1));
      final unpaid = rows.firstWhere(
        (r) => r[BillKey.status] == BillStatus.unpaid.value,
      );
      expect(unpaid[BillKey.isDeleted], 0);
    });
  });

  group('BillRepository.payBill', () {
    test('bayar lunas: jurnal posted + bill paid', () async {
      final bills = BillRepository(dbService);
      final billId = await createUnpaidBill();
      final cashId = await accountIdByCode('101.0001');
      final payableId = await accountIdByCode('201.0001');

      await bills.payBill(billId: billId, assetId: cashId);

      final bill = await bills.getBillById(billId);
      expect(bill?.status, BillStatus.paid.value);

      final db = await dbService.database;
      final entries = await db.query(
        journalEntryTable,
        where:
            '${JournalEntryKey.sourceId} = ? AND ${JournalEntryKey.source} = ?',
        whereArgs: [billId, 'bill_payment'],
      );
      expect(entries, hasLength(1));
      expect(entries.first[JournalEntryKey.status], 'posted');

      final lines = await db.query(
        journalLineTable,
        where: '${JournalLineKey.journalEntryId} = ?',
        whereArgs: [entries.first[JournalEntryKey.id]],
        orderBy: '${JournalLineKey.lineOrder} ASC',
      );
      expect(lines, hasLength(2));
      expect(lines[0][JournalLineKey.accountId], payableId);
      expect(lines[0][JournalLineKey.debitAmount], 100000);
      expect(lines[0][JournalLineKey.creditAmount], 0);
      expect(lines[1][JournalLineKey.accountId], cashId);
      expect(lines[1][JournalLineKey.debitAmount], 0);
      expect(lines[1][JournalLineKey.creditAmount], 100000);

      final journals = await bills.getBillJournals(billId);
      expect(journals, hasLength(1));
    });

    test('bayar dua kali ditolak', () async {
      final bills = BillRepository(dbService);
      final billId = await createUnpaidBill();
      final cashId = await accountIdByCode('101.0001');

      await bills.payBill(billId: billId, assetId: cashId);
      expect(
        () => bills.payBill(billId: billId, assetId: cashId),
        throwsException,
      );
    });

    test('dompet tak dikenal ditolak', () async {
      final bills = BillRepository(dbService);
      final billId = await createUnpaidBill();
      expect(
        () => bills.payBill(billId: billId, assetId: 999999),
        throwsException,
      );
    });

    test('saldo kurang → jurnal penyesuaian + dompet berakhir 0', () async {
      final bills = BillRepository(dbService);
      final billId = await createUnpaidBill();
      final db = await dbService.database;
      final cashId = await accountIdByCode('101.0001');

      await bills.payBill(billId: billId, assetId: cashId);

      final adjustments = await db.query(
        journalEntryTable,
        where: '${JournalEntryKey.source} = ?',
        whereArgs: ['adjustment'],
      );
      expect(adjustments, hasLength(1));
      expect(adjustments.first[JournalEntryKey.status], 'posted');

      final balance = await db.rawQuery(
        'SELECT ${AccountKey.balance} AS b FROM $accountBalanceView WHERE ${AccountKey.id} = ?',
        [cashId],
      );
      expect(balance.first['b'], 0);
    });

    test('saldo cukup → tanpa jurnal penyesuaian', () async {
      final bills = BillRepository(dbService);
      final billId = await createUnpaidBill();
      final db = await dbService.database;
      final cashId = await accountIdByCode('101.0001');
      final salaryId = await accountIdByCode('401.0001');
      final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final entryId = await db.rawInsert(
        'INSERT INTO $journalEntryTable (${JournalEntryKey.entryDate}, ${JournalEntryKey.source}, ${JournalEntryKey.status}) VALUES (?,?,?)',
        [nowSec, 'transaction', 'posted'],
      );
      await db.rawInsert(
        'INSERT INTO $journalLineTable (${JournalLineKey.journalEntryId}, ${JournalLineKey.accountId}, ${JournalLineKey.debitAmount}, ${JournalLineKey.creditAmount}, ${JournalLineKey.lineOrder}) VALUES (?,?,?,?,?), (?,?,?,?,?)',
        [entryId, cashId, 200000, 0, 0, entryId, salaryId, 0, 200000, 1],
      );

      await bills.payBill(billId: billId, assetId: cashId);

      final adjustments = await db.query(
        journalEntryTable,
        where: '${JournalEntryKey.source} = ?',
        whereArgs: ['adjustment'],
      );
      expect(adjustments, isEmpty);

      final balance = await db.rawQuery(
        'SELECT ${AccountKey.balance} AS b FROM $accountBalanceView WHERE ${AccountKey.id} = ?',
        [cashId],
      );
      expect(balance.first['b'], 100000);
    });
  });

  group('pencarian nama tagihan rutin', () {
    Future<int> unpaidBillFor(String planName) async {
      final plans = BillPlanRepository(dbService);
      final accountId = await createExpenseCategory('Cat $planName');
      final plan = await plans.savePlan(
        accountId: accountId,
        name: planName,
        amount: 50000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        bulkCreate: false,
      );
      final db = await dbService.database;
      final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return db.insert(billTable, {
        BillKey.billPlanId: plan.id,
        BillKey.amount: 50000,
        BillKey.billPeriod: '2026-09',
        BillKey.billedAt: nowSec - 86400,
        BillKey.dueDate: nowSec + 5 * 86400,
        BillKey.remindedAt: nowSec - 86400,
        BillKey.status: BillStatus.unpaid.value,
        BillKey.isDeleted: 0,
      });
    }

    test('getActiveBills(planKeyword) hanya cocok', () async {
      final bills = BillRepository(dbService);
      await unpaidBillFor('Listrik Rumah');
      await unpaidBillFor('Air Mineral');

      final filtered = await bills.getActiveBills(planKeyword: 'lis');
      expect(filtered, hasLength(1));

      final all = await bills.getActiveBills(planKeyword: '  ');
      expect(all, hasLength(2));
    });

    test('BillFilter planName memfilter histori lunas', () async {
      final bills = BillRepository(dbService);
      final id1 = await unpaidBillFor('Listrik Rumah');
      await unpaidBillFor('Air Mineral');
      final cashId = await accountIdByCode('101.0001');
      await bills.payBill(billId: id1, assetId: cashId);

      final result = await bills.getBills(
        pagination: Pagination(page: 1, limit: 10),
        filter: BillFilter(
          statuses: [BillStatus.paid.value],
          planName: 'LIS',
        ),
      );
      expect(result.items, hasLength(1));
      expect(result.meta.total, 1);
    });
  });
}
