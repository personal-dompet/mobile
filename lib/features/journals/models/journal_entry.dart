import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/features/activities/enums/activity_type.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/models/journal_line.dart';
import 'package:dompet_app/features/transactions/models/balance_adjustment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

@freezed
abstract class JournalEntry with _$JournalEntry {
  const JournalEntry._();
  const factory JournalEntry({
    @JsonKey(name: JournalEntryKey.id) required int id,
    @JsonKey(name: JournalEntryKey.entryDate) required int entryDate,
    @JsonKey(name: JournalEntryKey.description) String? description,
    @JsonKey(name: JournalEntryKey.reference) String? reference,
    @JsonKey(name: JournalEntryKey.metadata) String? metadata,
    @JsonKey(name: JournalEntryKey.source) required JournalSource source,
    @JsonKey(name: JournalEntryKey.status) required JournalStatus status,
    @JsonKey(name: JournalEntryKey.sourceId) int? sourceId,

    @JsonKey(name: JournalEntryKey.lines) @Default([]) List<JournalLine> lines,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  int get debitAmount => lines.fold(0, (previousValue, element) {
    return previousValue + element.debitAmount;
  });

  int get creditAmount => lines.fold(0, (previousValue, element) {
    return previousValue + element.creditAmount;
  });

  int get amount => debitAmount;

  bool get isIncome {
    return switch (source) {
      .transaction => lines.any((line) => line.accountType == .income),
      _ => false,
    };
  }

  ActivityType get type {
    if (source == .transfer) {
      return .transfer;
    }
    if (source == .billPayment) {
      return .billPayment;
    }
    if (source == .saving) {
      // Alokasi (asset->pocket) tampil sebagai transfer,
      // spend dari pocket tampil sebagai expense.
      final hasExpense = lines.any((line) => line.accountType == .expense);
      if (hasExpense) return .expense;
      return .transfer;
    }
    if (source == .transaction && !isIncome) {
      return .expense;
    }
    if (source == .transaction && isIncome) {
      return .income;
    }
    return .adjustment;
  }

  List<JournalLine> get assetLines {
    if (type != .transfer) {
      return lines
          .where((line) => line.accountType == .asset)
          .toList(growable: false);
    }
    return [...lines]..sort((a, b) => a.creditAmount.compareTo(b.creditAmount));
  }

  List<JournalLine> get otherLines =>
      lines.where((line) => line.accountType != .asset).toList();

  BalanceAdjustment? get balanceMeta {
    if (metadata == null || type != .adjustment) return null;
    final json = jsonDecode(metadata!);
    return BalanceAdjustment.fromJson(json);
  }
}
