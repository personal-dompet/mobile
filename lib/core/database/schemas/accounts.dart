import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/enums/enum.dart';

const accountTable = 'accounts';

String accountSchema =
    '''
CREATE TABLE IF NOT EXISTS $accountTable (
  ${AccountKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${AccountKey.code} TEXT NOT NULL UNIQUE,
  ${AccountKey.name} TEXT NOT NULL,
  ${AccountKey.type} TEXT NOT NULL CHECK(${AccountKey.type} IN (${AccountType.allValues.join(',')})),
  ${AccountKey.normalBalance} TEXT NOT NULL CHECK(${AccountKey.normalBalance} IN (${BalanceType.allValues.join(',')})),
  ${AccountKey.isLiquid} INTEGER DEFAULT 0,
  ${AccountKey.isSystem} INTEGER DEFAULT 0,
  ${AccountKey.iconCode} INTEGER,
  ${AccountKey.isDeleted} INTEGER DEFAULT 0,
  ${AccountKey.counter} INTEGER DEFAULT 0,
  ${AccountKey.createdAt} INTEGER DEFAULT (strftime('%s', 'now'))
)
''';
