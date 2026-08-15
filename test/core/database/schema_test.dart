import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../helpers/test_db.dart';

void main() {
  late DbService dbService;
  late Database db;

  setUp(() async {
    dbService = await createTestDbService();
    db = await dbService.database;
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  test(
    'fresh database contains every schema table (incl. budget tables)',
    () async {
      const expectedTables = {
        'accounts',
        'app_configurations',
        'journal_entries',
        'journal_lines',
        'budget_plans',
        'budgets',
      };

      final rows = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table'",
      );
      final actualTables = rows.map((row) => row['name']).toSet();

      for (final table in expectedTables) {
        expect(
          actualTables,
          contains(table),
          reason: 'table $table must be created on a fresh database',
        );
      }
    },
  );

  test('fresh database exposes the account balance view under the frozen '
      'name (v_account_balances)', () async {
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'view'",
    );
    final views = rows.map((row) => row['name']).toList();

    expect(
      views,
      contains(accountBalanceView),
      reason: 'view name frozen to $accountBalanceView',
    );
  });
}
