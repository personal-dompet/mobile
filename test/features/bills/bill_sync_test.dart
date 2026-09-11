import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

/// Engine sinkronisasi malas: aktivasi draft + generate periode berjalan.
void main() {
  late DbService dbService;

  setUp(() async {
    dbService = await createTestDbService();
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  /// now tetap: 15 Sep 2026.
  final now = DateTime(2026, 9, 15);
  int sec(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

  Future<int> createExpenseCategory(String name) async {
    final form = CategoryForm();
    form.nameControl.updateValue(name);
    form.typeControl.updateValue(AccountType.expense);
    final account = await CategoryRepository(dbService).createCategory(
      form: form,
    );
    return account.id;
  }

  Future<int> createPlan({
    required int accountId,
    String billedSchedule = '5',
    String dueDateSchedule = '10',
    DateTime? endedAt,
  }) async {
    final plans = BillPlanRepository(dbService);
    final plan = await plans.savePlan(
      accountId: accountId,
      name: 'Listrik',
      amount: 100000,
      period: 'monthly',
      billedSchedule: billedSchedule,
      dueDateSchedule: dueDateSchedule,
      reminderDays: 3,
      endedAt: endedAt,
      bulkCreate: false,
    );
    return plan.id;
  }

  Future<int> insertDraft({
    required int planId,
    required DateTime billed,
    required DateTime due,
    required String period,
  }) async {
    final db = await dbService.database;
    return db.insert(billTable, {
      BillKey.billPlanId: planId,
      BillKey.amount: 100000,
      BillKey.billPeriod: period,
      BillKey.billedAt: sec(billed),
      BillKey.dueDate: sec(due),
      BillKey.remindedAt: sec(due.subtract(const Duration(days: 3))),
      BillKey.status: BillStatus.drafted.value,
      BillKey.isDeleted: 0,
    });
  }

  Future<List<Map<String, Object?>>> billsOf(int planId) async {
    final db = await dbService.database;
    return db.query(
      billTable,
      where: '${BillKey.billPlanId} = ? AND ${BillKey.isDeleted} = 0',
      whereArgs: [planId],
      orderBy: '${BillKey.billedAt} ASC',
    );
  }

  Future<List<Map<String, Object?>>> generatedJournals(int billId) async {
    final db = await dbService.database;
    return db.query(
      journalEntryTable,
      where:
          '${JournalEntryKey.sourceId} = ? AND ${JournalEntryKey.source} = ?',
      whereArgs: [billId, 'bill_generated'],
    );
  }

  group('synchronizeBills aktivasi', () {
    test('draft yang waktunya tiba → unpaid + jurnal akrual posted', () async {
      final bills = BillRepository(dbService);
      final accountId = await createExpenseCategory('Listrik');
      final planId = await createPlan(accountId: accountId);
      final billId = await insertDraft(
        planId: planId,
        billed: DateTime(2026, 9, 5),
        due: DateTime(2026, 9, 10),
        period: '2026-09',
      );

      await bills.synchronizeBills(now: now);

      final bill = await bills.getBillById(billId);
      expect(bill?.status, BillStatus.unpaid.value);

      final journals = await generatedJournals(billId);
      expect(journals, hasLength(1));
      expect(journals.first[JournalEntryKey.status], 'posted');

      final db = await dbService.database;
      final lines = await db.query(
        journalLineTable,
        where: '${JournalLineKey.journalEntryId} = ?',
        whereArgs: [journals.first[JournalEntryKey.id]],
        orderBy: '${JournalLineKey.lineOrder} ASC',
      );
      expect(lines, hasLength(2));
      expect(lines[0][JournalLineKey.accountId], accountId);
      expect(lines[0][JournalLineKey.debitAmount], 100000);
      final payable = await db.query(
        accountTable,
        where: '${AccountKey.code} = ?',
        whereArgs: ['201.0001'],
      );
      expect(lines[1][JournalLineKey.accountId], payable.first[AccountKey.id]);
      expect(lines[1][JournalLineKey.creditAmount], 100000);
    });

    test('draft masa depan tidak disentuh', () async {
      final bills = BillRepository(dbService);
      final accountId = await createExpenseCategory('Listrik');
      final planId = await createPlan(accountId: accountId);
      final billId = await insertDraft(
        planId: planId,
        billed: DateTime(2026, 10, 5),
        due: DateTime(2026, 10, 10),
        period: '2026-10',
      );

      await bills.synchronizeBills(now: now);

      expect((await bills.getBillById(billId))?.status, 'drafted');
      expect(await generatedJournals(billId), isEmpty);
    });
  });

  group('synchronizeBills generate', () {
    test('periode berjalan dibuat sekali, idempoten', () async {
      final bills = BillRepository(dbService);
      final accountId = await createExpenseCategory('Air');
      final planId = await createPlan(
        accountId: accountId,
        billedSchedule: '20',
        dueDateSchedule: 'last_day',
      );

      // Tgl 20 belum tiba → belum ada tagihan.
      await bills.synchronizeBills(now: now);
      expect(await billsOf(planId), isEmpty);

      // Tiba → satu unpaid + jurnal.
      await bills.synchronizeBills(now: DateTime(2026, 9, 21));
      var rows = await billsOf(planId);
      expect(rows, hasLength(1));
      expect(rows.first[BillKey.status], BillStatus.unpaid.value);
      expect(rows.first[BillKey.billPeriod], '2026-09');
      expect(
        await generatedJournals(rows.first[BillKey.id] as int),
        hasLength(1),
      );

      // Sync lagi → tetap satu (UNIQUE + cek eksisting).
      await bills.synchronizeBills(now: DateTime(2026, 9, 22));
      rows = await billsOf(planId);
      expect(rows, hasLength(1));
    });

    test('plan berakhir dilewati', () async {
      final bills = BillRepository(dbService);
      final accountId = await createExpenseCategory('Gym');
      final planId = await createPlan(
        accountId: accountId,
        billedSchedule: '20',
        dueDateSchedule: 'last_day',
        endedAt: DateTime(2026, 9, 1),
      );

      await bills.synchronizeBills(now: DateTime(2026, 9, 21));
      expect(await billsOf(planId), isEmpty);
    });
  });

  group('getPendingTotal + hitungan sync', () {
    test('total unpaid; draft/paid/lunas dikecualikan; sync lapor sentuhan',
        () async {
      final bills = BillRepository(dbService);
      final accountId = await createExpenseCategory('Listrik');
      final planId = await createPlan(accountId: accountId);

      expect(await bills.getPendingTotal(), 0);

      await insertDraft(
        planId: planId,
        billed: DateTime(2026, 9, 5),
        due: DateTime(2026, 9, 10),
        period: '2026-09',
      );
      expect(await bills.getPendingTotal(), 0);

      final touched = await bills.synchronizeBills(now: now);
      expect(touched, 1);
      expect(await bills.getPendingTotal(), 100000);

      // Idempoten: sync ulang tak menyentuh apa-apa.
      expect(await bills.synchronizeBills(now: now), 0);

      // Bayar → pending nol lagi.
      final rows = await billsOf(planId);
      final db = await dbService.database;
      final cash = await db.query(
        accountTable,
        where: '${AccountKey.code} = ?',
        whereArgs: ['101.0001'],
      );
      await bills.payBill(
        billId: rows.first[BillKey.id] as int,
        assetId: cash.first[AccountKey.id] as int,
      );
      expect(await bills.getPendingTotal(), 0);
    });
  });
}
