import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/activities/enums/activity_type.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_filter.freezed.dart';

@freezed
abstract class JournalFilter with _$JournalFilter {
  const JournalFilter._();
  const factory JournalFilter({
    String? description,
    ActivityType? type,
    int? accountId,
    (DateTime, DateTime)? dates,
  }) = _JournalFilter;

  List<String> get whereClauses {
    final clauses = <String>[];

    if (description != null && description!.isNotEmpty) {
      clauses.add('$journalEntryTable.${JournalEntryKey.description} LIKE ?');
    }

    if (type != null && (type == .expense || type == .income)) {
      switch (type) {
        case .expense:
          clauses.add('''
            $journalEntryTable.${JournalEntryKey.source} = 'transaction'
            AND EXISTS (
              SELECT 1 FROM $journalLineTable
              INNER JOIN $accountTable 
                ON $accountTable.${AccountKey.id} = $journalLineTable.${JournalLineKey.accountId}
              WHERE $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
                AND $accountTable.${AccountKey.type} = '${AccountTypeName.asset.value}'
                AND $journalLineTable.${JournalLineKey.creditAmount} > 0
            )
          ''');
          break;
        case .income:
          clauses.add('''
            $journalEntryTable.${JournalEntryKey.source} = 'transaction'
            AND EXISTS (
              SELECT 1 FROM $journalLineTable
              INNER JOIN $accountTable 
                ON $accountTable.${AccountKey.id} = $journalLineTable.${JournalLineKey.accountId}
              WHERE $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
                AND $accountTable.${AccountKey.type} = '${AccountTypeName.asset.value}'
                AND $journalLineTable.${JournalLineKey.debitAmount} > 0
            )
          ''');
          break;
        default:
      }
    } else if (type != null && type != .all) {
      clauses.add('$journalEntryTable.${JournalEntryKey.source} = ?');
    }

    if (dates != null) {
      clauses.add(
        '$journalEntryTable.${JournalEntryKey.entryDate} BETWEEN ? AND ?',
      );
    }

    if (accountId != null) {
      clauses.add('''
        EXISTS (
          SELECT 1 FROM $journalLineTable
          WHERE $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
          AND $journalLineTable.${JournalLineKey.accountId} = ?
        )
      ''');
    }

    return clauses;
  }

  List<dynamic> get arguments {
    final args = [];

    if (description != null && description!.isNotEmpty) {
      args.add('%${description!.trim()}%');
    }

    if (type != null && type != .expense && type != .income && type != .all) {
      args.add(switch (type) {
        .adjustment => JournalSource.adjustment.value,
        .billPayment => JournalSource.billPayment.value,
        .transfer => JournalSource.transfer.value,
        _ => JournalSource.transaction.value,
      });
    }

    if (dates != null) {
      final (startDate, endDate) = dates!;
      args.addAll([startDate.secondsSinceEpoch, endDate.secondsSinceEpoch]);
    }

    if (accountId != null) {
      args.add(accountId);
    }

    return args;
  }
}
