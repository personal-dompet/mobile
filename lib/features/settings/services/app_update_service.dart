import 'dart:convert';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

/// Hasil cek pembaruan dari GitHub Releases (pengganti auto-update Play).
class AppUpdateInfo {
  const AppUpdateInfo({
    required this.currentVersion,
    required this.currentBuild,
    required this.latestVersion,
    required this.latestBuild,
    required this.releaseUrl,
  });

  final String currentVersion;
  final int currentBuild;
  final String latestVersion;
  final int latestBuild;
  final String releaseUrl;

  bool get hasUpdate => latestBuild > currentBuild;
}

/// Cek rilis terbaru tanpa dependency HTTP tambahan (pakai HttpClient).
/// Tag rilis memakai format yang sama dengan pubspec: v1.0.1+2.
class AppUpdateService {
  static const _latestUrl =
      'https://api.github.com/repos/personal-dompet/mobile/releases/latest';

  final HttpClient _client;

  AppUpdateService({HttpClient? client}) : _client = client ?? HttpClient();

  /// null = sudah terbaru / offline / gagal (jangan ganggu user).
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(info.buildNumber) ?? 0;

      final request = await _client
          .getUrl(Uri.parse(_latestUrl))
          .timeout(const Duration(seconds: 10));
      request.headers.set('Accept', 'application/vnd.github+json');
      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode != HttpStatus.ok) return null;

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final tag = (json['tag_name'] as String? ?? '').replaceFirst('v', '');
      final parts = tag.split('+');
      if (parts.length != 2) return null;
      final latestBuild = int.tryParse(parts[1]) ?? 0;

      return AppUpdateInfo(
        currentVersion: info.version,
        currentBuild: currentBuild,
        latestVersion: parts[0],
        latestBuild: latestBuild,
        releaseUrl:
            (json['html_url'] as String?) ??
            'https://github.com/personal-dompet/mobile/releases/latest',
      );
    } catch (_) {
      return null;
    }
  }

  /// Versi terpasang, untuk baris info di Pengaturan.
  Future<String> installedVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return '${info.version}+${info.buildNumber}';
    } catch (_) {
      return '-';
    }
  }
}
