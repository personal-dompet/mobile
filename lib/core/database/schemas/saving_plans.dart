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
    ${SavingPlanKey.billPlanId} INTEGER REFERENCES $billPlanTable(${BillPlanKey.id}),
    ${SavingPlanKey.billPeriod} TEXT,
    ${SavingPlanKey.note} TEXT,
    ${SavingPlanKey.status} TEXT NOT NULL DEFAULT 'active' CHECK(${SavingPlanKey.status} IN ('active','completed')),
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

/// Link ke tagihan rutin tahunan (nullable: NULL = target biasa).
/// Partial unique: satu tagihan rutin hanya boleh punya satu target
/// per kemunculan periode (mis. tahun "2026").
const savingPlanBillPlanIdx =
    '''
  CREATE INDEX IF NOT EXISTS idx_saving_plan_bill
  ON $savingPlanTable (${SavingPlanKey.billPlanId}, ${SavingPlanKey.billPeriod});
''';

const savingPlanBillOccurrenceIdx =
    '''
  CREATE UNIQUE INDEX IF NOT EXISTS uq_saving_plan_bill_occurrence
  ON $savingPlanTable (${SavingPlanKey.billPlanId}, ${SavingPlanKey.billPeriod})
  WHERE ${SavingPlanKey.billPlanId} IS NOT NULL;
''';
