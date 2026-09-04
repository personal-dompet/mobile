import 'dart:io';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Regenerates the repo-root `dompet.db` dev snapshot so it is in schema
/// parity with `lib/core/database/schemas/` + `views/`:
///
/// - all tables (incl. `budget_plans` / `budgets` / `saving_plans`)
/// - the `v_account_balances` view (frozen code truth)
/// - the `v_saving_tracker` view
/// - seeded preset accounts + app configuration
/// - the dev wallet ("Tunai") with its opening balance journal
///   (same flow as wallet creation during onboarding)
///
/// Intentionally skipped on regular test runs — run explicitly from the
/// repo root with:
///
///   REGEN_SNAPSHOT=1 flutter test test/tool/regenerate_dompet_db_test.dart
///
/// (Plain `dart run` cannot compile this dependency graph on the current
/// Windows SDK — FFI transformer crash — so the regenerator lives here.)
void main() {
  test('regenerate repo-root dompet.db snapshot in schema parity', () async {
    if (!Platform.environment.containsKey('REGEN_SNAPSHOT')) {
      markTestSkipped('Set REGEN_SNAPSHOT=1 to regenerate the snapshot.');
      return;
    }

    final repoRoot = Directory.current;
    expect(
      File(
        '${repoRoot.path}${Platform.pathSeparator}pubspec.yaml',
      ).existsSync(),
      isTrue,
      reason: 'run from the repo root',
    );

    sqfliteFfiInit();

    // Use an absolute path: sqflite_common_ffi resolves relative paths
    // against its own databases directory, not the process CWD.
    final snapshot = File('dompet.db').absolute;
    if (snapshot.existsSync()) {
      snapshot.deleteSync();
    }

    final dbService = DbService(testPath: snapshot.path);
    final db = await dbService.database;

    final assetRepository = AssetRepository(dbService);
    final form = AssetForm();
    form.nameControl.updateValue(AccountPreset.cash.value);
    form.codeControl.updateValue(AccountPreset.cash.code);
    form.balanceControl.updateValue(300000);
    await assetRepository.createAsset(form);

    final tables = (await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    )).map((row) => row['name']).toSet();
    for (final table in {
      'accounts',
      'app_configurations',
      'journal_entries',
      'journal_lines',
      'budget_plans',
      'budgets',
      'saving_plans',
    }) {
      expect(tables, contains(table), reason: 'snapshot must contain $table');
    }

    final views = (await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'view'",
    )).map((row) => row['name']).toList();
    expect(
      views,
      contains(accountBalanceView),
      reason: 'snapshot view must be $accountBalanceView',
    );
    expect(
      views,
      contains(savingTrackerView),
      reason: 'snapshot view must be $savingTrackerView',
    );

    final wallet = await db.query(
      accountTable,
      where: '${AccountKey.code} = ? AND ${AccountKey.isSystem} = 0',
      whereArgs: ['101.0001.0001'],
      limit: 1,
    );
    expect(wallet, hasLength(1), reason: 'dev wallet "Tunai" must exist');

    expect(
      await db.query(journalEntryTable),
      hasLength(1),
      reason: 'opening balance journal must exist',
    );
    expect(
      await db.query(journalLineTable),
      hasLength(2),
      reason: 'opening journal must have two balanced lines',
    );

    await dbService.close();
  });
}
