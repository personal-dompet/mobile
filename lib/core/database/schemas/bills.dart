import 'package:dompet_app/core/constants/field_keys/bill.dart';
import 'package:dompet_app/core/constants/field_keys/bill_plan.dart';
import 'package:dompet_app/core/database/schemas/bill_plans.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';

const billTable = 'bills';

String billSchema =
    '''
  CREATE TABLE IF NOT EXISTS $billTable (
    ${BillKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${BillKey.billPlanId} INTEGER NOT NULL,
    ${BillKey.amount} INTEGER NOT NULL,
    ${BillKey.billPeriod} TEXT NOT NULL,
    ${BillKey.billedAt} INTEGER NOT NULL,
    ${BillKey.dueDate} INTEGER NOT NULL,
    ${BillKey.remindedAt} INTEGER NOT NULL,
    ${BillKey.status} TEXT NOT NULL CHECK(${BillKey.status} IN (${BillStatus.allValues.map((e) => "'$e'").join(',')})),
    ${BillKey.isDeleted} INTEGER DEFAULT 0,
    ${BillKey.createdAt} INTEGER DEFAULT (strftime('%s', 'now')),
    UNIQUE(${BillKey.billPlanId}, ${BillKey.billPeriod}),
    CHECK(${BillKey.billedAt} <= ${BillKey.dueDate}),
    CHECK(${BillKey.remindedAt} <= ${BillKey.dueDate}),
    FOREIGN KEY (${BillKey.billPlanId}) REFERENCES $billPlanTable(${BillPlanKey.id})
  )
''';

const billStatusIdx =
    '''
  CREATE INDEX IF NOT EXISTS idx_bill_status
  ON $billTable (${BillKey.status}, ${BillKey.isDeleted});
''';
