import 'dart:io';

import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/features/backup/models/backup_meta.dart';
import 'package:dompet_app/features/backup/services/drive_backup_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BackupRepository {
  final DbService _dbService;
  final DriveBackupService _driveService;

  BackupRepository(this._dbService, this._driveService);

  Future<BackupMeta?> getLastBackupMeta() async {
    try {
      return await _driveService.fetchMeta();
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasBackup() async {
    try {
      return await _driveService.hasBackup();
    } catch (_) {
      return false;
    }
  }

  /// Creates a backup of the current database and uploads to Drive.
  ///
  /// Steps: checkpoint → close → copy to staging → reopen → upload.
  Future<BackupMeta> backup() async {
    final dbPath = await _dbService.getDatabasePath();
    if (dbPath == inMemoryDatabasePath) {
      throw StateError('Backup tidak didukung untuk database in-memory');
    }

    final dbFile = File(dbPath);
    if (!await dbFile.exists()) {
      throw StateError('File database tidak ditemukan');
    }

    // Ensure WAL is flushed
    await _dbService.checkpoint();

    // Close so file is not locked
    await _dbService.close();

    File? stagingFile;
    try {
      final tempDir = await getTemporaryDirectory();
      final stagingPath = p.join(
        tempDir.path,
        'dompet_backup_staging_${DateTime.now().millisecondsSinceEpoch}.db',
      );
      stagingFile = await dbFile.copy(stagingPath);

      // Reopen immediately so app remains usable during upload
      await _dbService.reopen();

      // Verify staging file
      final ok = await _dbService.verifyFileIntegrity(stagingFile.path);
      if (!ok) {
        throw StateError('File staging backup tidak valid');
      }

      final meta = await _driveService.upload(stagingFile);
      return meta;
    } catch (e) {
      // Ensure DB is reopened even on failure
      try {
        await _dbService.reopen();
      } catch (_) {}
      rethrow;
    } finally {
      if (stagingFile != null) {
        try {
          if (await stagingFile.exists()) await stagingFile.delete();
        } catch (_) {}
      }
      // Ensure reopened if not already
      try {
        await _dbService.reopen();
      } catch (_) {}
    }
  }

  /// Restores database from Drive.
  ///
  /// Downloads to temp, verifies, creates safety copy, overwrites, verifies, reopens.
  /// On failure, rolls back safety copy.
  Future<BackupMeta?> restore() async {
    final dbPath = await _dbService.getDatabasePath();
    if (dbPath == inMemoryDatabasePath) {
      throw StateError('Restore tidak didukung untuk database in-memory');
    }

    final tempDir = await getTemporaryDirectory();
    final download = await _driveService.downloadToTemp(tempDir);
    final tmpFile = download.file;

    try {
      // Verify downloaded file
      final ok = await _dbService.verifyFileIntegrity(tmpFile.path);
      if (!ok) {
        throw StateError('File backup rusak atau bukan database Dompet');
      }

      // Close current DB
      await _dbService.checkpoint();
      await _dbService.close();

      final dbFile = File(dbPath);
      File? safetyCopy;
      final dir = dbFile.parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Safety copy if current file exists
      if (await dbFile.exists()) {
        final safetyPath = p.join(
          dir.path,
          'dompet.db.pre-restore-${DateTime.now().millisecondsSinceEpoch}',
        );
        try {
          safetyCopy = await dbFile.copy(safetyPath);
        } catch (_) {
          safetyCopy = null;
        }
      }

      // Overwrite with downloaded file
      try {
        await tmpFile.copy(dbPath);
      } catch (e) {
        // Try rollback
        if (safetyCopy != null && await safetyCopy.exists()) {
          try {
            await safetyCopy.copy(dbPath);
          } catch (_) {}
        }
        throw StateError('Gagal mengganti database: $e');
      }

      // Verify after copy
      final verifyAfter = await _dbService.verifyFileIntegrity(dbPath);
      if (!verifyAfter) {
        // Rollback
        if (safetyCopy != null && await safetyCopy.exists()) {
          try {
            await safetyCopy.copy(dbPath);
          } catch (_) {}
        }
        throw StateError('Database hasil restore tidak valid, dipulihkan ke sebelumnya');
      }

      // Reopen and final integrity check
      await _dbService.reopen();
      final integrityOk = await _dbService.verifyIntegrity();
      if (!integrityOk) {
        await _dbService.close();
        if (safetyCopy != null && await safetyCopy.exists()) {
          try {
            await safetyCopy.copy(dbPath);
            await _dbService.reopen();
          } catch (_) {}
        }
        throw StateError('Integrity check gagal setelah restore');
      }

      return download.meta;
    } finally {
      try {
        if (await tmpFile.exists()) await tmpFile.delete();
      } catch (_) {}
      // Ensure DB is reopened if we are still closed
      try {
        await _dbService.reopen();
      } catch (_) {}
    }
  }
}
