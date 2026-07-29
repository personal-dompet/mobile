import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_line.freezed.dart';
part 'journal_line.g.dart';

@freezed
abstract class JournalLine with _$JournalLine {
  const JournalLine._();
  const factory JournalLine({
    @JsonKey(name: JournalLineKey.id) required int id,
    @JsonKey(name: JournalLineKey.journalEntryId) required int journalEntryId,
    @JsonKey(name: JournalLineKey.accountId) required int accountId,
    @JsonKey(name: JournalLineKey.debitAmount) @Default(0) int debitAmount,
    @JsonKey(name: JournalLineKey.creditAmount) @Default(0) int creditAmount,
    @JsonKey(name: JournalLineKey.note) String? note,
    @JsonKey(name: JournalLineKey.lineOrder) @Default(0) int lineOrder,

    @JsonKey(name: JournalLineKey.accountName) required String accountName,
    @JsonKey(name: JournalLineKey.accountType)
    required AccountTypeName accountType,
    @JsonKey(name: JournalLineKey.accountBalance) @Default(0) int balance,
    @JsonKey(name: JournalLineKey.accountNormalBalance)
    required BalanceType accountNormalBalance,
  }) = _JournalLine;

  factory JournalLine.fromJson(Map<String, dynamic> json) =>
      _$JournalLineFromJson(json);

  int get amount => debitAmount > 0 ? debitAmount : creditAmount;
}
