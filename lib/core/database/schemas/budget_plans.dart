import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';

const budgetPlanTable = 'budget_plans';

const budgetPlanSchema =
    '''
  CREATE TABLE IF NOT EXISTS $budgetPlanTable (
    ${BudgetPlanKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${BudgetPlanKey.accountId} INTEGER UNIQUE NOT NULL,
    ${BudgetPlanKey.amount} INTEGER NOT NULL CHECK(${BudgetPlanKey.amount} > 0),
    ${BudgetPlanKey.frequency} TEXT NOT NULL,
    ${BudgetPlanKey.startDate} INTEGER NOT NULL,
    ${BudgetPlanKey.endType} TEXT NOT NULL,
    ${BudgetPlanKey.endDate} INTEGER,
    ${BudgetPlanKey.endAfterN} INTEGER,
    ${BudgetPlanKey.carryPolicy} TEXT NOT NULL,
    ${BudgetPlanKey.isActive} INTEGER NOT NULL DEFAULT 1,
    ${BudgetPlanKey.note} TEXT,
    FOREIGN KEY (${BudgetPlanKey.accountId}) REFERENCES $accountTable(${AccountKey.id})
  )
''';
