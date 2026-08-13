import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';

const journalEntryTable = 'journal_entries';

String journalEntrySchema =
    '''
CREATE TABLE IF NOT EXISTS $journalEntryTable (
  ${JournalEntryKey.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${JournalEntryKey.entryDate} INTEGER NOT NULL,
  ${JournalEntryKey.description} TEXT,
  ${JournalEntryKey.reference} TEXT,
  ${JournalEntryKey.source} TEXT NOT NULL CHECK(${JournalEntryKey.source} IN (${JournalSource.allValues.join(',')})),
  ${JournalEntryKey.status} TEXT NOT NULL CHECK(${JournalEntryKey.status} IN (${JournalStatus.allValues.join(',')})),
  ${JournalEntryKey.metadata} TEXT,
  ${JournalEntryKey.sourceId} INTEGER,
  ${JournalEntryKey.createdAt} INTEGER DEFAULT (strftime('%s', 'now'))
)
''';

const journalEntryStatusDateIdx =
    '''
  CREATE INDEX idx_${journalEntryTable}_${JournalEntryKey.status}_${JournalEntryKey.entryDate} on $journalEntryTable (${JournalEntryKey.status}, ${JournalEntryKey.entryDate})
''';
