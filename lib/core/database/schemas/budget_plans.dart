import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';

const budgetPlanTable = 'budget_plans';

const budgetPlanSchema =
    '''
  CREATE TABLE IF NOT EXISTS $budgetPlanTable (
    ${BudgetPlanKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${BudgetPlanKey.accountId} INTEGER UNIQUE NOT NULL,
    ${BudgetPlanKey.amount} INTEGER NOT NULL CHECK(${BudgetPlanKey.amount} > 0),
    ${BudgetPlanKey.note} TEXT,
    ${BudgetPlanKey.isDeleted} INTEGER DEFAULT 0,
    ${BudgetPlanKey.createdAt} INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (${BudgetPlanKey.accountId}) REFERENCES $accountTable(${AccountKey.id})
  )
''';

const budgetPlanStatusIdx =
    '''
  CREATE INDEX IF NOT EXISTS idx_budget_plan_status
  ON $budgetPlanTable (${BudgetPlanKey.isDeleted});
''';
