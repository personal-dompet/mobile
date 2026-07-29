// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionSummary _$TransactionSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TransactionSummary', json, ($checkedConvert) {
      final val = _TransactionSummary(
        income: $checkedConvert('income', (v) => (v as num?)?.toInt() ?? 0),
        expense: $checkedConvert('expense', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$TransactionSummaryToJson(_TransactionSummary instance) =>
    <String, dynamic>{'income': instance.income, 'expense': instance.expense};
