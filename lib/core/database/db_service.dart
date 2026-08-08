import 'dart:io';

import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/seeders/seeders.dart';
import 'package:dompet_app/core/database/triggers/account_counter_trigger.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbService {
  Database? _database;

  final String? _testPath;

  DbService({String? testPath}) : _testPath = testPath;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final testPath = _testPath;
    _database = await (testPath != null
        ? _openDatabase(testPath)
        : _initDB('dompet.db'));
    return _database!;
  }

  /// Opens a database at the given [path] without touching app storage.
  ///
  /// Used by tests (in-memory or temp file) and by the snapshot regeneration
  /// script. The caller is responsible for removing any existing file.
  Future<Database> _openDatabase(String path) {
    return databaseFactoryFfi.openDatabase(
      path,
      options: _databaseOptions,
    );
  }

  OpenDatabaseOptions get _databaseOptions => OpenDatabaseOptions(
    version: 1,
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
  );

  Future<Database> _initDB(String fileName) async {
    final databaseFactory = databaseFactoryFfi;
    final appDir = await getApplicationSupportDirectory();
    final dirPath = join(appDir.path, 'databases');
    await Directory(dirPath).create(recursive: true);
    final path = join(dirPath, fileName);
    await databaseFactoryFfi.deleteDatabase(path);
    try {
      return await databaseFactory.openDatabase(path, options: _databaseOptions);
    } catch (e) {
      if (e.toString().contains('not a database')) {
        await deleteDatabase(path);
        return await databaseFactory.openDatabase(
          path,
          options: _databaseOptions,
        );
      }
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute(accountSchema);
    batch.execute(appConfigurationSchema);
    batch.execute(budgetPlanSchema);
    batch.execute(budgetPeriodSchema);
    batch.execute(journalEntrySchema);
    batch.execute(journalLineSchema);

    // Seeder
    seedAppConfiguration(batch);

    batch.execute(journalLineEntryIdx);
    batch.execute(journalLineAccountIdIdx);
    batch.execute(journalEntryStatusDateIdx);

    batch.execute(accountBalanceViewDefinition);

    batch.execute(increaseAccountCounter);
    batch.execute(decreaseAccountCounter);

    await batch.commit();

    await db.transaction((txn) async {
      await seedAccount(txn);
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // run migration scripts per version
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
