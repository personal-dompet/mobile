import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';

const budgetTrackerView = 'v_budget_tracker';

String budgetTrackerViewDefinition =
    '''
CREATE VIEW $budgetTrackerView AS
  SELECT
    $budgetTable.*,
    $accountTable.${AccountKey.name} AS ${BudgetKey.accountName},
    COALESCE(SUM(CASE 
      WHEN $accountTable.${AccountKey.normalBalance} = '${BalanceType.debit.value}' THEN $journalLineTable.${JournalLineKey.debitAmount}
      WHEN $accountTable.${AccountKey.normalBalance} = '${BalanceType.credit.value}' THEN $journalLineTable.${JournalLineKey.creditAmount}
      ELSE 0
    END), 0) AS ${BudgetKey.actualSpend}
  FROM $budgetTable
  LEFT JOIN $accountTable ON $accountTable.${AccountKey.id} = $budgetTable.${BudgetKey.accountId}
  LEFT JOIN $journalLineTable ON $journalLineTable.${JournalLineKey.accountId} = $accountTable.${AccountKey.id}
  LEFT JOIN $journalEntryTable ON $journalEntryTable.${JournalEntryKey.id} = $journalLineTable.${JournalLineKey.journalEntryId}
    AND $journalEntryTable.${JournalEntryKey.entryDate} BETWEEN $budgetTable.${BudgetKey.periodStart} AND $budgetTable.${BudgetKey.periodEnd}
    AND $journalEntryTable.${JournalEntryKey.status} = '${JournalStatus.posted.name}'
  GROUP BY $budgetTable.${BudgetKey.id}, $budgetTable.${BudgetKey.accountId}
''';
