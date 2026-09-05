import 'dart:io';

import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/seeders/seeders.dart';
import 'package:dompet_app/core/database/triggers/account_counter_trigger.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbService {
  static const String dbFileName = 'dompet.db';

  Database? _database;

  final String? _testPath;

  DbService({String? testPath}) : _testPath = testPath;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final testPath = _testPath;
    _database = await (testPath != null
        ? _openDatabase(testPath)
        : _initDB(dbFileName));
    return _database!;
  }

  /// Returns absolute path to the underlying database file.
  ///
  /// For in-memory databases returns [inMemoryDatabasePath].
  Future<String> getDatabasePath() async {
    final testPath = _testPath;
    if (testPath != null) return testPath;
    final appDir = await getApplicationSupportDirectory();
    return join(appDir.path, 'databases', dbFileName);
  }

  /// Returns the database [File] handle for the current path.
  Future<File> getDatabaseFile() async {
    final path = await getDatabasePath();
    return File(path);
  }

  /// Flushes WAL into main db file. Must be called before copying file.
  Future<void> checkpoint() async {
    final db = _database;
    if (db != null) {
      try {
        await db.execute('PRAGMA wal_checkpoint(FULL)');
      } catch (_) {}
    } else {
      // No open connection → nothing to checkpoint, file is already consistent
      // if app was closed cleanly. Try to open briefly if file exists.
      final path = await getDatabasePath();
      if (path == inMemoryDatabasePath) return;
      final file = File(path);
      if (!await file.exists()) return;
      // Open, checkpoint, close
      try {
        final tmpDb = await databaseFactoryFfi.openDatabase(
          path,
          options: OpenDatabaseOptions(
            onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
          ),
        );
        await tmpDb.execute('PRAGMA wal_checkpoint(FULL)');
        await tmpDb.close();
      } catch (_) {}
    }
  }

  /// Reopens database after [close]. Useful after a file-level restore.
  Future<Database> reopen() async {
    if (_database != null) return _database!;
    return database;
  }

  /// Checks integrity of the currently opened database.
  Future<bool> verifyIntegrity() async {
    try {
      final db = await database;
      final result = await db.rawQuery('PRAGMA integrity_check');
      if (result.isEmpty) return false;
      final value = result.first.values.first as String?;
      return value == 'ok';
    } catch (_) {
      return false;
    }
  }

  /// Checks integrity of a database file at [path] without affecting current [database].
  ///
  /// Verifies SQLite header and runs `PRAGMA integrity_check` in a temporary connection.
  Future<bool> verifyFileIntegrity(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return false;
      if (await file.length() < 100) return false;

      // Check SQLite magic header: "SQLite format 3\x00"
      final header = await file.openRead(0, 16).first;
      const expected = [
        83,
        81,
        76,
        105,
        116,
        101,
        32,
        102,
        111,
        114,
        109,
        97,
        116,
        32,
        51,
        0,
      ];
      if (header.length < 16) return false;
      for (var i = 0; i < 16; i++) {
        if (header[i] != expected[i]) return false;
      }

      // Run integrity_check on a temporary connection
      Database? tmpDb;
      try {
        tmpDb = await databaseFactoryFfi.openDatabase(
          path,
          options: OpenDatabaseOptions(readOnly: true),
        );
        final result = await tmpDb.rawQuery('PRAGMA integrity_check');
        if (result.isEmpty) return false;
        final value = result.first.values.first as String?;
        return value == 'ok';
      } finally {
        await tmpDb?.close();
      }
    } catch (_) {
      return false;
    }
  }

  /// Opens a database at the given [path] without touching app storage.
  ///
  /// Used by tests (in-memory or temp file) and by the snapshot regeneration
  /// script. The caller is responsible for removing any existing file.
  Future<Database> _openDatabase(String path) {
    return databaseFactoryFfi.openDatabase(path, options: _databaseOptions);
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
    // await databaseFactoryFfi.deleteDatabase(path);
    try {
      return await databaseFactory.openDatabase(
        path,
        options: _databaseOptions,
      );
    } catch (e) {
      if (e.toString().contains('not a database')) {
        // await deleteDatabase(path);
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
    batch.execute(budgetSchema);
    batch.execute(savingPlanSchema);
    batch.execute(journalEntrySchema);
    batch.execute(journalLineSchema);

    // Seeder
    seedAppConfiguration(batch);

    batch.execute(journalLineEntryIdx);
    batch.execute(journalLineAccountIdIdx);
    batch.execute(journalEntryStatusDateIdx);
    batch.execute(savingPlanAccountIdx);
    batch.execute(savingPlanStatusIdx);

    batch.execute(accountBalanceViewDefinition);
    batch.execute(budgetTrackerViewDefinition);
    batch.execute(savingTrackerViewDefinition);

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
