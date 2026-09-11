import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'dart:io';

import '../../helpers/test_db.dart';

/// Form rencana tagihan: simpan plan + bulk generate draft.
void main() {
  late DbService dbService;

  setUpAll(() async {
    await initializeDateFormatting('id');
  });

  setUp(() async {
    dbService = await createTestDbService();
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  Future<int> createExpenseCategory(String name) async {
    final form = CategoryForm();
    form.nameControl.updateValue(name);
    form.typeControl.updateValue(AccountType.expense);
    final account = await CategoryRepository(dbService).createCategory(
      form: form,
    );
    return account.id;
  }

  Future<List<Map<String, Object?>>> billsOf(int planId) async {
    final db = await dbService.database;
    return db.query(
      billTable,
      where: '${BillKey.billPlanId} = ?',
      whereArgs: [planId],
      orderBy: '${BillKey.billedAt} ASC',
    );
  }

  group('BillPlanRepository.savePlan bulk', () {
    test('monthly bulk 3 draft: status, urutan tanggal, reminded H-3',
        () async {
      final plans = BillPlanRepository(dbService);
      final accountId = await createExpenseCategory('Listrik');

      final first = BillSchedule.nextMonthlyBilled(DateTime.now(), '5');
      final endedAt = DateTime(first.year, first.month + 2, 5);

      final plan = await plans.savePlan(
        accountId: accountId,
        name: 'Listrik Rumah',
        amount: 100000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        endedAt: endedAt,
        reference: 'IDPEL 123',
        bulkCreate: true,
      );

      expect(plan.reference, 'IDPEL 123');
      expect(plan.name, 'Listrik Rumah');

      final bills = await billsOf(plan.id);
      expect(bills, hasLength(3));
      for (final bill in bills) {
        expect(bill[BillKey.status], 'drafted');
        expect(bill[BillKey.amount], 100000);
        final billedAt = bill[BillKey.billedAt] as int;
        final dueDate = bill[BillKey.dueDate] as int;
        final remindedAt = bill[BillKey.remindedAt] as int;
        expect(billedAt, lessThanOrEqualTo(dueDate));
        expect(remindedAt, dueDate - 3 * 86400);
      }
      final periods = bills.map((b) => b[BillKey.billPeriod] as String);
      expect(periods.toSet(), hasLength(3));
    });

    test('monthly billed 28 + due last_day lolos validasi', () async {
      final plans = BillPlanRepository(dbService);
      final accountId = await createExpenseCategory('Air');

      final plan = await plans.savePlan(
        accountId: accountId,
        name: 'Air',
        amount: 50000,
        period: 'monthly',
        billedSchedule: '28',
        dueDateSchedule: 'last_day',
        reminderDays: 0,
        bulkCreate: false,
      );

      expect(plan.billedSchedule, '28');
      expect((await billsOf(plan.id)), isEmpty);
    });

    test('monthly billed >= due ditolak sebelum menyentuh DB', () async {
      final plans = BillPlanRepository(dbService);
      final accountId = await createExpenseCategory('Internet');

      expect(
        () => plans.savePlan(
          accountId: accountId,
          name: 'Internet',
          amount: 50000,
          period: 'monthly',
          billedSchedule: '10',
          dueDateSchedule: '5',
          reminderDays: 3,
          bulkCreate: false,
        ),
        throwsException,
      );
    });

    test('yearly due lintas tahun jatuh di tahun billed + 1', () async {
      final plans = BillPlanRepository(dbService);
      final accountId = await createExpenseCategory('Pajak Motor');

      final first = BillSchedule.nextYearlyBilled(DateTime.now(), '12-20');
      final endedAt = DateTime(first.year, 12, 20);

      final plan = await plans.savePlan(
        accountId: accountId,
        name: 'Pajak Motor',
        amount: 300000,
        period: 'yearly',
        billedSchedule: '12-20',
        dueDateSchedule: '01-05',
        reminderDays: 3,
        endedAt: endedAt,
        bulkCreate: true,
      );

      final bills = await billsOf(plan.id);
      expect(bills, hasLength(1));
      final billedAt = DateTime.fromMillisecondsSinceEpoch(
        (bills.first[BillKey.billedAt] as int) * 1000,
      );
      final dueDate = DateTime.fromMillisecondsSinceEpoch(
        (bills.first[BillKey.dueDate] as int) * 1000,
      );
      expect(dueDate.year, billedAt.year + 1);
      expect(bills.first[BillKey.billPeriod], billedAt.year.toString());
    });
  });

  group('BillPlanRepository.getPlansWithCategories', () {
    test('satu kategori boleh banyak rencana + ikut kategori', () async {
      final plans = BillPlanRepository(dbService);
      final listrikId = await createExpenseCategory('Listrik');

      await plans.savePlan(
        accountId: listrikId,
        name: 'Listrik Rumah',
        amount: 100000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        reference: 'IDPEL 123',
        bulkCreate: false,
      );
      await plans.savePlan(
        accountId: listrikId,
        name: 'Listrik Kos',
        amount: 50000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        reference: 'IDPEL 456',
        bulkCreate: false,
      );

      final items = await plans.getPlansWithCategories();
      expect(items, hasLength(2));
      expect(
        items.map((e) => e.plan.name),
        containsAll(['Listrik Rumah', 'Listrik Kos']),
      );
      expect(
        items.map((e) => e.plan.reference),
        containsAll(['IDPEL 123', 'IDPEL 456']),
      );
      expect(
        items.map((e) => e.category.name),
        everyElement('Listrik'),
      );
    });

    test('filter nama parsial, case-insensitive', () async {
      final plans = BillPlanRepository(dbService);
      final id = await createExpenseCategory('Langganan');

      for (final name in ['Netflix', 'Spotify', 'Internet']) {
        await plans.savePlan(
          accountId: id,
          name: name,
          amount: 50000,
          period: 'monthly',
          billedSchedule: '5',
          dueDateSchedule: '10',
          reminderDays: 3,
          bulkCreate: false,
        );
      }

      final filtered = await plans.getPlansWithCategories(nameKeyword: 'tif');
      expect(filtered.map((e) => e.plan.name), ['Spotify']);

      final all = await plans.getPlansWithCategories(nameKeyword: '  ');
      expect(all, hasLength(3));
    });
  });

  group('BillPlanRepository.savePlan ubah', () {
    test('ubah nominal tanpa bulk: id sama, tanpa tagihan baru', () async {
      final plans = BillPlanRepository(dbService);
      final accountId = await createExpenseCategory('Gym');

      final created = await plans.savePlan(
        accountId: accountId,
        name: 'Gym',
        amount: 100000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        bulkCreate: false,
      );

      final updated = await plans.savePlan(
        id: created.id,
        accountId: accountId,
        name: 'Gym Baru',
        amount: 150000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        bulkCreate: false,
      );

      expect(updated.id, created.id);
      expect(updated.name, 'Gym Baru');
      expect(updated.amount, 150000);
      expect(await billsOf(updated.id), isEmpty);
    });

    test('ubah + bulk: draft lama diganti nominal baru', () async {
      final plans = BillPlanRepository(dbService);
      final accountId = await createExpenseCategory('Kos');

      final first = BillSchedule.nextMonthlyBilled(DateTime.now(), '5');
      final endedAt = DateTime(first.year, first.month + 1, 5);
      final created = await plans.savePlan(
        accountId: accountId,
        name: 'Kos',
        amount: 1000000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        endedAt: endedAt,
        bulkCreate: true,
      );
      expect(await billsOf(created.id), hasLength(2));

      final updated = await plans.savePlan(
        id: created.id,
        accountId: accountId,
        name: 'Kos',
        amount: 1200000,
        period: 'monthly',
        billedSchedule: '5',
        dueDateSchedule: '10',
        reminderDays: 3,
        endedAt: endedAt,
        bulkCreate: true,
      );

      expect(updated.id, created.id);
      final bills = await billsOf(updated.id);
      expect(bills, hasLength(2));
      expect(
        bills.map((b) => b[BillKey.amount]),
        everyElement(1200000),
      );
    });
  });

  group('BillSchedule tanggal-berakhir ⇄ banyak-tagihan', () {    test('monthly: count(nth(n)) == n', () {
      final nth = BillSchedule.nthBilledDate(
        period: 'monthly',
        billedSchedule: '5',
        n: 12,
        from: DateTime(2026, 1, 10),
      );
      expect(
        BillSchedule.countDrafts(
          period: 'monthly',
          billedSchedule: '5',
          endedAt: nth,
          from: DateTime(2026, 1, 10),
        ),
        12,
      );
    });

    test('yearly Februari dibatasi 28 tanpa last_day', () {
      final date = BillSchedule.yearlyDate(2026, '02-28');
      expect((date.month, date.day), (2, 28));
      expect(
        BillSchedule.format('yearly', '02-28'),
        isNot(contains('Terakhir')),
      );
    });
  });

  group('migrasi v1→v2 kolom name', () {
    test('DB lama tanpa name tetap terbuka + baris terbawa', () async {
      final dir = await Directory.systemTemp.createTemp('bill_migrate');
      final path = p.join(dir.path, 'dompet.db');
      DbService? migrated;
      try {
        final oldDb = await databaseFactoryFfi.openDatabase(
          path,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              await db.execute('''
                CREATE TABLE $billPlanTable (
                  ${BillPlanKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
                  ${BillPlanKey.accountId} INTEGER NOT NULL,
                  ${BillPlanKey.amount} INTEGER NOT NULL
                )
              ''');
            },
          ),
        );
        await oldDb.insert(billPlanTable, {
          BillPlanKey.accountId: 1,
          BillPlanKey.amount: 100000,
        });
        await oldDb.close();

        final migratedDb = DbService(testPath: path);
        migrated = migratedDb;
        final db = await migratedDb.database;
        final info = await db.rawQuery('PRAGMA table_info($billPlanTable)');
        expect(
          info.map((c) => c['name']),
          contains(BillPlanKey.name),
        );
        final rows = await db.query(billPlanTable);
        expect(rows, hasLength(1));
        expect(rows.first[BillPlanKey.name], '');
        await migratedDb.close();
        migrated = null;
      } finally {
        // Tutup dulu sebelum hapus: bila expect di atas gagal, koneksi yang
        // masih terbuka mengunci file di Windows dan menutupi error aslinya.
        await migrated?.close();
        await dir.delete(recursive: true);
      }
    });

    test('DB v1 skema penuh (sudah ada name) tetap terbuka + tanpa dobel',
        () async {
      final dir = await Directory.systemTemp.createTemp('bill_migrate_full');
      final path = p.join(dir.path, 'dompet.db');
      DbService? migrated;
      try {
        final oldDb = await databaseFactoryFfi.openDatabase(
          path,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              await db.execute(billPlanSchema);
            },
          ),
        );
        await oldDb.insert(billPlanTable, {
          BillPlanKey.accountId: 1,
          BillPlanKey.name: 'Listrik',
          BillPlanKey.amount: 100000,
          BillPlanKey.period: 'monthly',
          BillPlanKey.billedSchedule: '5',
          BillPlanKey.dueDateSchedule: '10',
        });
        await oldDb.close();

        migrated = DbService(testPath: path);
        final db = await migrated.database;
        final info = await db.rawQuery('PRAGMA table_info($billPlanTable)');
        expect(
          info.where((c) => c['name'] == BillPlanKey.name),
          hasLength(1),
        );
        final rows = await db.query(billPlanTable);
        expect(rows, hasLength(1));
        expect(rows.first[BillPlanKey.name], 'Listrik');
        await migrated.close();
        migrated = null;
      } finally {
        await migrated?.close();
        await dir.delete(recursive: true);
      }
    });
  });
}
