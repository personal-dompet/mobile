// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Budget',
  json,
  ($checkedConvert) {
    final val = _Budget(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      accountId: $checkedConvert('account_id', (v) => (v as num).toInt()),
      accountName: $checkedConvert('account_name', (v) => v as String),
      budgetAmount: $checkedConvert(
        'budgeted_amount',
        (v) => (v as num).toInt(),
      ),
      periodStart: $checkedConvert('period_start', (v) => (v as num).toInt()),
      periodEnd: $checkedConvert('period_end', (v) => (v as num).toInt()),
      actualSpend: $checkedConvert(
        'actual_spend',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      categoryArchived: $checkedConvert(
        'category_archived',
        (v) => v as bool? ?? false,
      ),
      carryAmount: $checkedConvert(
        'carry_amount',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      leftover: $checkedConvert('leftover', (v) => (v as num?)?.toInt() ?? 0),
      closedAt: $checkedConvert('closed_at', (v) => (v as num?)?.toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'accountId': 'account_id',
    'accountName': 'account_name',
    'budgetAmount': 'budgeted_amount',
    'periodStart': 'period_start',
    'periodEnd': 'period_end',
    'actualSpend': 'actual_spend',
    'categoryArchived': 'category_archived',
    'carryAmount': 'carry_amount',
    'closedAt': 'closed_at',
  },
);

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
  'id': instance.id,
  'account_id': instance.accountId,
  'account_name': instance.accountName,
  'budgeted_amount': instance.budgetAmount,
  'period_start': instance.periodStart,
  'period_end': instance.periodEnd,
  'actual_spend': instance.actualSpend,
  'category_archived': instance.categoryArchived,
  'carry_amount': instance.carryAmount,
  'leftover': instance.leftover,
  'closed_at': ?instance.closedAt,
};
