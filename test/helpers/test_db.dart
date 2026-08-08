import 'package:dompet_app/core/database/db_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Creates a [DbService] backed by a real in-memory SQLite database
/// (sqflite_common_ffi) with the full app schema + seeds.
///
/// Money math is tested against a real database — never mocked.
Future<DbService> createTestDbService() async {
  sqfliteFfiInit();
  final dbService = DbService(testPath: inMemoryDatabasePath);
  await dbService.database;
  return dbService;
}

Future<void> disposeTestDbService(DbService dbService) async {
  await dbService.close();
}
