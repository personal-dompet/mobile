import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';

const savingPlanTable = 'saving_plans';

const savingPlanSchema =
    '''
  CREATE TABLE IF NOT EXISTS $savingPlanTable (
    ${SavingPlanKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${SavingPlanKey.accountId} INTEGER UNIQUE NOT NULL,
    ${SavingPlanKey.targetAmount} INTEGER CHECK(${SavingPlanKey.targetAmount} IS NULL OR ${SavingPlanKey.targetAmount} > 0),
    ${SavingPlanKey.targetDate} INTEGER,
    ${SavingPlanKey.note} TEXT,
    ${SavingPlanKey.status} TEXT NOT NULL DEFAULT 'ACTIVE' CHECK(${SavingPlanKey.status} IN ('ACTIVE','COMPLETED')),
    ${SavingPlanKey.isDeleted} INTEGER DEFAULT 0,
    ${SavingPlanKey.createdAt} INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (${SavingPlanKey.accountId}) REFERENCES $accountTable(${AccountKey.id})
  )
''';

const savingPlanStatusIdx =
    '''
  CREATE INDEX IF NOT EXISTS idx_saving_plan_status
  ON $savingPlanTable (${SavingPlanKey.status}, ${SavingPlanKey.isDeleted});
''';

const savingPlanAccountIdx =
    '''
  CREATE INDEX IF NOT EXISTS idx_saving_plan_account
  ON $savingPlanTable (${SavingPlanKey.accountId});
''';
