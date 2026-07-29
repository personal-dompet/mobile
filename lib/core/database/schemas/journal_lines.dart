import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/accounts.dart';
import 'package:dompet_app/core/database/schemas/journal_entries.dart';

const journalLineTable = 'journal_lines';

const journalLineSchema =
    '''
CREATE TABLE IF NOT EXISTS $journalLineTable (
  ${JournalLineKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${JournalLineKey.journalEntryId} INTEGER NOT NULL,
  ${JournalLineKey.accountId} INTEGER NOT NULL,
  ${JournalLineKey.debitAmount} INTEGER DEFAULT 0 CHECK(${JournalLineKey.debitAmount} >= 0),
  ${JournalLineKey.creditAmount} INTEGER DEFAULT 0 CHECK(${JournalLineKey.creditAmount} >= 0),
  ${JournalLineKey.note} TEXT,
  ${JournalLineKey.lineOrder} INTEGER,
  FOREIGN KEY (${JournalLineKey.journalEntryId}) REFERENCES $journalEntryTable (${JournalEntryKey.id}),
  FOREIGN KEY (${JournalLineKey.accountId}) REFERENCES $accountTable (${AccountKey.id})
)
''';

const journalLineEntryIdx =
    '''
CREATE INDEX idx_${journalLineTable}_${JournalLineKey.journalEntryId} on $journalLineTable (${JournalLineKey.journalEntryId})
''';

const journalLineAccountIdIdx =
    '''
CREATE INDEX idx_${journalLineTable}_${JournalLineKey.accountId} on $journalLineTable (${JournalLineKey.accountId})
''';
