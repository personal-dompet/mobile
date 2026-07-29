import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';

const budgetPeriodTable = 'budget_periods';

const budgetPeriodSchema =
    '''
  CREATE TABLE IF NOT EXISTS $budgetPeriodTable (
    ${BudgetPeriodKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${BudgetPeriodKey.budgetPlanId} INTEGER NOT NULL,
    ${BudgetPeriodKey.periodStart} INTEGER NOT NULL,
    ${BudgetPeriodKey.periodEnd} INTEGER NOT NULL,
    ${BudgetPeriodKey.budgetedAmount} INTEGER NOT NULL CHECK(${BudgetPeriodKey.budgetedAmount} > 0),
    ${BudgetPeriodKey.carryAmount} INTEGER NOT NULL DEFAULT 0,
    ${BudgetPeriodKey.closePolicy} TEXT,
    ${BudgetPeriodKey.leftover} INTEGER NOT NULL DEFAULT 0,
    ${BudgetPeriodKey.closedAt} INTEGER,
    FOREIGN KEY (${BudgetPeriodKey.budgetPlanId}) REFERENCES $budgetPlanTable(${BudgetPlanKey.id})
  )
''';
