import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';

const String increaseAccountCounter =
    '''
  CREATE TRIGGER IF NOT EXISTS  increase_account_counter
    AFTER UPDATE ON $journalEntryTable
    WHEN NEW.${JournalEntryKey.status} = 'posted'
      AND OLD.${JournalEntryKey.status} = 'draft'
  BEGIN
    UPDATE $accountTable
    SET ${AccountKey.counter} = ${AccountKey.counter} + 1
    WHERE ${AccountKey.id} IN (
      SELECT ${JournalLineKey.accountId}
      FROM $journalLineTable
      WHERE ${JournalLineKey.journalEntryId} = NEW.${JournalEntryKey.id}
    );
  END
''';

const String decreaseAccountCounter =
    '''
  CREATE TRIGGER IF NOT EXISTS  decrease_account_counter
    AFTER UPDATE ON $journalEntryTable
    WHEN NEW.${JournalEntryKey.status} = 'voided'
      AND OLD.${JournalEntryKey.status} != 'voided'
  BEGIN
    UPDATE $accountTable
    SET ${AccountKey.counter} = MAX(${AccountKey.counter} - 1, 0)
    WHERE ${AccountKey.id} IN (
      SELECT ${JournalLineKey.accountId}
      FROM $journalLineTable
      WHERE ${JournalLineKey.journalEntryId} = NEW.${JournalEntryKey.id}
    );
  END
''';
