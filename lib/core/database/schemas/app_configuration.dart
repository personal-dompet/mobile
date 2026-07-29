import 'package:dompet_app/core/constants/field_keys/field_key.dart';

const appConfigurationTable = 'app_configurations';

const appConfigurationSchema =
    '''
CREATE TABLE IF NOT EXISTS $appConfigurationTable (
  ${AppConfigurationKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${AppConfigurationKey.setting} TEXT NOT NULL
)
''';
