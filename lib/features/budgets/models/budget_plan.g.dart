// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetPlan _$BudgetPlanFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_BudgetPlan',
  json,
  ($checkedConvert) {
    final val = _BudgetPlan(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      accountId: $checkedConvert('account_id', (v) => (v as num).toInt()),
      amount: $checkedConvert('amount', (v) => (v as num).toInt()),
      note: $checkedConvert('note', (v) => v as String?),
      isDeleted: $checkedConvert(
        'is_deleted',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      createdAt: $checkedConvert(
        'created_at',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'accountId': 'account_id',
    'isDeleted': 'is_deleted',
    'createdAt': 'created_at',
  },
);

Map<String, dynamic> _$BudgetPlanToJson(_BudgetPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'amount': instance.amount,
      'note': ?instance.note,
      'is_deleted': instance.isDeleted,
      'created_at': instance.createdAt,
    };
