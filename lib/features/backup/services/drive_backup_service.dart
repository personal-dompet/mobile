import 'dart:convert';
import 'dart:io';

import 'package:dompet_app/features/backup/models/backup_meta.dart';
import 'package:dompet_app/features/backup/services/backup_auth_service.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:path/path.dart' as p;

class DriveBackupService {
  static const String backupFileName = 'dompet_backup.db';
  static const String metaFileName = 'backup_meta.json';
  static const String appDataFolder = 'appDataFolder';

  final BackupAuthService _authService;

  DriveBackupService(this._authService);

  Future<gapis.AuthClient> _client() => _authService.ensureAuthClient();

  /// Finds a file by name in appDataFolder. Returns null if not found.
  Future<drive.File?> _findFile(drive.DriveApi driveApi, String name) async {
    final result = await driveApi.files.list(
      q: "name='$name' and trashed=false",
      spaces: appDataFolder,
      $fields: 'files(id,name,size,modifiedTime)',
    );
    final files = result.files;
    if (files == null || files.isEmpty) return null;
    return files.first;
  }

  Future<BackupMeta?> fetchMeta() async {
    final client = await _client();
    try {
      final driveApi = drive.DriveApi(client);
      final metaFile = await _findFile(driveApi, metaFileName);
      if (metaFile == null || metaFile.id == null) return null;

      final media = await driveApi.files.get(
        metaFile.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = <int>[];
      await for (final chunk in media.stream) {
        bytes.addAll(chunk);
      }
      final jsonStr = utf8.decode(bytes);
      return BackupMeta.fromJsonString(jsonStr);
    } finally {
      client.close();
    }
  }

  /// Uploads dbFile + meta to appDataFolder. Single backup (update if exists).
  Future<BackupMeta> upload(File dbFile, {int dbVersion = 1}) async {
    final client = await _client();
    try {
      final driveApi = drive.DriveApi(client);

      final size = await dbFile.length();
      final meta = BackupMeta(
        updatedAt: DateTime.now(),
        sizeBytes: size,
        dbVersion: dbVersion,
      );

      // Upload DB file
      final existingDb = await _findFile(driveApi, backupFileName);
      final media = drive.Media(dbFile.openRead(), size);

      if (existingDb != null && existingDb.id != null) {
        await driveApi.files.update(
          drive.File()..modifiedTime = DateTime.now().toUtc(),
          existingDb.id!,
          uploadMedia: media,
        );
      } else {
        await driveApi.files.create(
          drive.File()
            ..name = backupFileName
            ..parents = [appDataFolder],
          uploadMedia: media,
        );
      }

      // Upload meta file
      final metaBytes = utf8.encode(meta.toJsonString());
      final metaExisting = await _findFile(driveApi, metaFileName);
      final metaMedia = drive.Media(
        Stream.value(metaBytes),
        metaBytes.length,
      );

      if (metaExisting != null && metaExisting.id != null) {
        await driveApi.files.update(
          drive.File()..modifiedTime = DateTime.now().toUtc(),
          metaExisting.id!,
          uploadMedia: metaMedia,
        );
      } else {
        await driveApi.files.create(
          drive.File()
            ..name = metaFileName
            ..parents = [appDataFolder]
            ..mimeType = 'application/json',
          uploadMedia: metaMedia,
        );
      }

      return meta;
    } finally {
      client.close();
    }
  }

  /// Downloads the latest backup file to a temp file and returns its path + meta.
  Future<({File file, BackupMeta? meta})> downloadToTemp(Directory tempDir) async {
    final client = await _client();
    try {
      final driveApi = drive.DriveApi(client);
      final dbFile = await _findFile(driveApi, backupFileName);
      if (dbFile == null || dbFile.id == null) {
        throw StateError('Backup tidak ditemukan di Google Drive');
      }

      final media = await driveApi.files.get(
        dbFile.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final tmpPath = p.join(
        tempDir.path,
        'dompet_restore_${DateTime.now().millisecondsSinceEpoch}.db',
      );
      final tmpFile = File(tmpPath);
      final sink = tmpFile.openWrite();
      await for (final chunk in media.stream) {
        sink.add(chunk);
      }
      await sink.close();

      BackupMeta? meta;
      try {
        final metaFile = await _findFile(driveApi, metaFileName);
        if (metaFile != null && metaFile.id != null) {
          final metaMedia = await driveApi.files.get(
            metaFile.id!,
            downloadOptions: drive.DownloadOptions.fullMedia,
          ) as drive.Media;
          final bytes = <int>[];
          await for (final chunk in metaMedia.stream) {
            bytes.addAll(chunk);
          }
          meta = BackupMeta.fromJsonString(utf8.decode(bytes));
        }
      } catch (_) {
        meta = null;
      }

      return (file: tmpFile, meta: meta);
    } finally {
      client.close();
    }
  }

  /// For diagnostics: checks if a backup exists.
  Future<bool> hasBackup() async {
    final client = await _client();
    try {
      final driveApi = drive.DriveApi(client);
      final f = await _findFile(driveApi, backupFileName);
      return f != null;
    } finally {
      client.close();
    }
  }
}
