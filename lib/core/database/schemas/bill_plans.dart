import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/constants/last_day.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';

const billPlanTable = 'bill_plans';

String billPlanSchema =
    '''
CREATE TABLE IF NOT EXISTS $billPlanTable (
  ${BillPlanKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${BillPlanKey.accountId} INTEGER NOT NULL,
  ${BillPlanKey.name} TEXT NOT NULL,
  ${BillPlanKey.amount} INTEGER NOT NULL,
  ${BillPlanKey.period} TEXT NOT NULL CHECK(${BillPlanKey.period} IN (${BillPlanPeriodEnum.allValues.map((e) => "'$e'").join(',')})),
  ${BillPlanKey.billedSchedule} TEXT NOT NULL,
  ${BillPlanKey.dueDateSchedule} TEXT NOT NULL,
  ${BillPlanKey.reminderDays} INTEGER DEFAULT 3,
  ${BillPlanKey.endedAt} INTEGER,
  ${BillPlanKey.reference} TEXT,
  ${BillPlanKey.note} TEXT,
  ${BillPlanKey.isDeleted} INTEGER DEFAULT 0,
  ${BillPlanKey.createdAt} INTEGER DEFAULT (strftime('%s', 'now')),

  CHECK(
    (${BillPlanKey.period} = '${BillPlanPeriodEnum.monthly}' AND 
      (
        CAST(REPLACE(REPLACE(${BillPlanKey.billedSchedule}, '$lastDay', '99'), '-', '') AS INTEGER) < 
        CAST(REPLACE(REPLACE(${BillPlanKey.dueDateSchedule}, '$lastDay', '99'), '-', '') AS INTEGER)
      )
    )
    OR
    ${BillPlanKey.period} != '${BillPlanPeriodEnum.monthly}'
  ),

  FOREIGN KEY (${BillPlanKey.accountId}) REFERENCES $accountTable(${AccountKey.id})
)
''';

const billPlanStatusIdx =
    '''
  CREATE INDEX IF NOT EXISTS idx_bill_plan_status
  ON $billPlanTable (${BillPlanKey.isDeleted}, ${BillPlanKey.endedAt});
''';

const billPlanAccountIdx =
    '''
  CREATE INDEX IF NOT EXISTS idx_bill_plan_account
  ON $billPlanTable (${BillPlanKey.accountId});
''';
