import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/app_configuration.dart';
import 'package:dompet_app/core/models/app_configuration.dart';

class AppConfigurationRepository {
  final DbService _dbService;

  AppConfigurationRepository(this._dbService);

  Future<AppConfiguration> getConfig() async {
    final db = await _dbService.database;

    final result = await db.query(appConfigurationTable);

    final settingText = result.first[AppConfigurationKey.setting] as String;
    return AppConfiguration.fromJson(jsonDecode(settingText));
  }

  Future<void> updateConfig(AppConfiguration config) async {
    final db = await _dbService.database;

    await db.update(appConfigurationTable, {
      AppConfigurationKey.setting: jsonEncode(config.toJson()),
    });
  }
}
