import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';

const accountBalanceView = 'v_account_balances';

String accountBalanceViewDefinition =
    '''
CREATE VIEW $accountBalanceView AS
  SELECT 
    $accountTable.*,
    CASE
      WHEN $accountTable.${AccountKey.normalBalance} = 'DEBIT' THEN
        SUM(CASE WHEN $journalEntryTable.${JournalEntryKey.status} = 'posted' THEN $journalLineTable.${JournalLineKey.debitAmount} ELSE 0 END) - 
        SUM(CASE WHEN $journalEntryTable.${JournalEntryKey.status} = 'posted' THEN $journalLineTable.${JournalLineKey.creditAmount} ELSE 0 END)
      ELSE
        SUM(CASE WHEN $journalEntryTable.${JournalEntryKey.status} = 'posted' THEN $journalLineTable.${JournalLineKey.creditAmount} ELSE 0 END) - 
        SUM(CASE WHEN $journalEntryTable.${JournalEntryKey.status} = 'posted' THEN $journalLineTable.${JournalLineKey.debitAmount} ELSE 0 END)
    END AS ${AccountKey.balance}
  FROM $accountTable
  LEFT JOIN $journalLineTable ON $journalLineTable.${JournalLineKey.accountId} = $accountTable.${AccountKey.id}
  LEFT JOIN $journalEntryTable ON $journalEntryTable.${JournalEntryKey.id} = $journalLineTable.${JournalLineKey.journalEntryId} 
    AND $journalEntryTable.${JournalEntryKey.status} = '${JournalStatus.posted.name}'
  GROUP BY $accountTable.${AccountKey.id}
''';
