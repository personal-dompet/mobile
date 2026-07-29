import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/app_configuration.dart';
import 'package:dompet_app/core/models/app_configuration.dart';
import 'package:sqflite/sqflite.dart';

Future<void> seedAppConfiguration(Batch batch) async {
  final configuration = AppConfiguration(hint: AppHint());
  batch.rawInsert(
    '''
    INSERT INTO $appConfigurationTable (${AppConfigurationKey.setting})
    VALUES (?)
  ''',
    [jsonEncode(configuration.toJson())],
  );
}
