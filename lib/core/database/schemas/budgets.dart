import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';

const budgetTable = 'budget_periods';

const budgetSchema =
    '''
  CREATE TABLE IF NOT EXISTS $budgetTable (
    ${BudgetKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${BudgetKey.budgetPlanId} INTEGER NOT NULL,
    ${BudgetKey.periodStart} INTEGER NOT NULL,
    ${BudgetKey.periodEnd} INTEGER NOT NULL,
    ${BudgetKey.budgetedAmount} INTEGER NOT NULL CHECK(${BudgetKey.budgetedAmount} > 0),
    ${BudgetKey.carryAmount} INTEGER NOT NULL DEFAULT 0,
    ${BudgetKey.leftover} INTEGER NOT NULL DEFAULT 0,
    ${BudgetKey.closedAt} INTEGER,
    ${BudgetKey.createdAt} INTEGER DEFAULT (strftime('%s', 'now')),
    UNIQUE(${BudgetKey.budgetPlanId}, ${BudgetKey.periodStart}),
    CHECK(${BudgetKey.periodStart} < ${BudgetKey.periodEnd}),
    FOREIGN KEY (${BudgetKey.budgetPlanId}) REFERENCES $budgetPlanTable(${BudgetPlanKey.id})
  )
''';
