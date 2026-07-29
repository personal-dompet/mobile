import 'package:dompet_app/core/constants/field_keys/field_key.dart';

const journalEntryTable = 'journal_entries';

const journalEntrySchema =
    '''
CREATE TABLE IF NOT EXISTS $journalEntryTable (
  ${JournalEntryKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${JournalEntryKey.entryDate} INETGER NOT NULL,
  ${JournalEntryKey.description} TEXT,
  ${JournalEntryKey.reference} TEXT,
  ${JournalEntryKey.source} TEXT NOT NULL,
  ${JournalEntryKey.status} TEXT NOT NULL,
  ${JournalEntryKey.metadata} TEXT,
  ${JournalEntryKey.sourceId} INTEGER,
  ${JournalEntryKey.createdAt} INTEGER DEFAULT (strftime('%s', 'now'))
)
''';

const journalEntryStatusDateIdx =
    '''
  CREATE INDEX idx_${journalEntryTable}_${JournalEntryKey.status}_${JournalEntryKey.entryDate} on $journalEntryTable (${JournalEntryKey.status}, ${JournalEntryKey.entryDate})
''';
