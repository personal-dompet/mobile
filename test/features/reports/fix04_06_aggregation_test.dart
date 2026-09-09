import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/activities/enums/activity_type.dart';
import 'package:dompet_app/features/activities/extensions/activity.dart';
import 'package:dompet_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../reports/report_test_helpers.dart';

int _sec(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

/// Jurnal saldo awal persis seperti AssetRepository.createAsset:
/// debit aset + kredit akun ekuitas 301.0001, source setup.
Future<int> insertSetupJournal({
  required DbService db,
  required DateTime date,
  required int assetId,
  required int amount,
}) async {
  final conn = await db.database;
  final equityId = await accountId(db, '301.0001');
  final journalId = await conn.rawInsert(
    '''
    INSERT INTO $journalEntryTable (
      ${JournalEntryKey.entryDate},
      ${JournalEntryKey.source},
      ${JournalEntryKey.description},
      ${JournalEntryKey.status}
    ) VALUES (?,?,?,?)
    ''',
    [
      _sec(date),
      JournalSource.setup.value,
      'Konfigurasi saldo awal',
      JournalStatus.posted.name,
    ],
  );
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
      journalId, equityId, 0, amount, 1,
    ],
  );
  return journalId;
}

void main() {
  group('B3 FIX-04: saldo awal tampil di aktivitas', () {
    test('getJournals tanpa filter menyertakan setup', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final cash = await accountId(db, '101.0001');
      await insertSetupJournal(
        db: db,
        date: DateTime(2026, 9, 2),
        assetId: cash,
        amount: 5000000,
      );

      final repo = JournalRepository(db);
      final result = await repo.getJournals(
        pagination: Pagination(page: 1, limit: 5),
      );

      expect(result.items.length, 1);
      final entry = result.items.single;
      expect(entry.source, JournalSource.setup);
      // Q9 A: income-like.
      expect(entry.type, ActivityType.income);
      expect(entry.title(), 'Saldo awal');
      expect(entry.displayAmount().startsWith('+'), isTrue);
    });

    test('getJournals filter accountId menyertakan setup (detail dompet)', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final cash = await accountId(db, '101.0001');
      await insertSetupJournal(
        db: db,
        date: DateTime(2026, 9, 2),
        assetId: cash,
        amount: 5000000,
      );

      final repo = JournalRepository(db);
      final result = await repo.getJournals(
        pagination: Pagination(page: 1, limit: 5),
        filter: JournalFilter(accountId: cash),
      );

      expect(result.items.length, 1);
      expect(result.items.single.displayAmount(accountId: cash).startsWith('+'), isTrue);
    });

    test('getJournal by id bisa dibuka (tap detail)', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final cash = await accountId(db, '101.0001');
      final id = await insertSetupJournal(
        db: db,
        date: DateTime(2026, 9, 2),
        assetId: cash,
        amount: 5000000,
      );

      final repo = JournalRepository(db);
      final entry = await repo.getJournal(id);
      expect(entry.title(), 'Saldo awal');
    });
  });

  group('B3 FIX-04: saldo awal eksklusif dari agregat', () {
    test('dashboard ringkasan tetap 0', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final cash = await accountId(db, '101.0001');
      await insertSetupJournal(
        db: db,
        date: DateTime.now(),
        assetId: cash,
        amount: 5000000,
      );

      final summary = await DashboardRepository(db).getTransactionSummary();
      expect(summary.income, 0);
      expect(summary.expense, 0);
    });

    test('laporan bulanan tak berubah + transaction_count tetap', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final cash = await accountId(db, '101.0001');
      final salary = await accountId(db, '401.0001');
      await insertSetupJournal(
        db: db,
        date: DateTime(2026, 9, 2),
        assetId: cash,
        amount: 5000000,
      );
      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 3),
        assetId: cash,
        categoryId: salary,
        amount: 8000000,
        isExpense: false,
      );

      const period = ReportPeriod(year: 2026, month: 9);
      final repo = ReportRepository(db);
      final summary = await repo.getMonthlySummary(period);
      expect(summary.income, 8000000);
      expect(summary.expense, 0);
      expect(summary.transactionCount, 1);
      expect(await repo.getExpenseByCategory(period), isEmpty);
      expect(await repo.getIncomeByCategory(period), hasLength(1));
    });
  });

  group('B3 FIX-06: pemasukan per kategori', () {
    test('urut terbesar + persen + setup dikecualikan', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final repo = ReportRepository(db);
      final cash = await accountId(db, '101.0001');
      final salary = await accountId(db, '401.0001');

      await insertTransaction(
        db: db,
        date: DateTime(2026, 9, 3),
        assetId: cash,
        categoryId: salary,
        amount: 8000000,
        isExpense: false,
      );
      await insertSetupJournal(
        db: db,
        date: DateTime(2026, 9, 2),
        assetId: cash,
        amount: 5000000,
      );

      final items = await repo.getIncomeByCategory(
        const ReportPeriod(year: 2026, month: 9),
      );
      expect(items.length, 1);
      expect(items.single.amount, 8000000);
      expect(items.single.percentage, 100);
    });

    test('bulan kosong -> list kosong', () async {
      final db = await createTestDbService();
      addTearDown(() => disposeTestDbService(db));
      final items = await ReportRepository(db).getIncomeByCategory(
        const ReportPeriod(year: 2026, month: 9),
      );
      expect(items, isEmpty);
    });
  });
}
