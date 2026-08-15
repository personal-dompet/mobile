import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';

const budgetTable = 'budgets';

const budgetSchema =
    '''
  CREATE TABLE IF NOT EXISTS $budgetTable (
    ${BudgetKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${BudgetKey.accountId} INTEGER NOT NULL,
    ${BudgetKey.periodStart} INTEGER NOT NULL,
    ${BudgetKey.periodEnd} INTEGER NOT NULL,
    ${BudgetKey.budgetedAmount} INTEGER NOT NULL CHECK(${BudgetKey.budgetedAmount} > 0),
    ${BudgetKey.carryAmount} INTEGER NOT NULL DEFAULT 0,
    ${BudgetKey.leftover} INTEGER NOT NULL DEFAULT 0,
    ${BudgetKey.closedAt} INTEGER,
    ${BudgetKey.createdAt} INTEGER DEFAULT (strftime('%s', 'now')),
    UNIQUE(${BudgetKey.accountId}, ${BudgetKey.periodStart}),
    CHECK(${BudgetKey.periodStart} < ${BudgetKey.periodEnd}),
    FOREIGN KEY (${BudgetKey.accountId}) REFERENCES $accountTable(${AccountKey.id})
  )
''';

const budgetPeriodIdx =
    '''
  CREATE INDEX IF NOT EXISTS idx_budget_period 
  ON $budgetTable (${BudgetKey.periodStart}, ${BudgetKey.periodEnd});
''';

const budgetStatusIdx =
    '''
  CREATE INDEX IF NOT EXISTS idx_budget_status
  ON $budgetTable (${BudgetKey.accountId}, ${BudgetKey.closedAt});
''';
