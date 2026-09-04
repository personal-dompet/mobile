// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saving_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingPlan _$SavingPlanFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SavingPlan',
  json,
  ($checkedConvert) {
    final val = _SavingPlan(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      accountId: $checkedConvert('account_id', (v) => (v as num).toInt()),
      accountCode: $checkedConvert('account_code', (v) => v as String),
      accountName: $checkedConvert('account_name', (v) => v as String),
      iconCode: $checkedConvert('icon_code', (v) => (v as num?)?.toInt()),
      targetAmount: $checkedConvert(
        'target_amount',
        (v) => (v as num?)?.toInt(),
      ),
      targetDate: $checkedConvert('target_date', (v) => (v as num?)?.toInt()),
      note: $checkedConvert('note', (v) => v as String?),
      status: $checkedConvert('status', (v) => v as String? ?? 'ACTIVE'),
      balance: $checkedConvert('balance', (v) => (v as num?)?.toInt() ?? 0),
      progress: $checkedConvert('progress', (v) => (v as num?)?.toDouble()),
      createdAt: $checkedConvert(
        'created_at',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'accountId': 'account_id',
    'accountCode': 'account_code',
    'accountName': 'account_name',
    'iconCode': 'icon_code',
    'targetAmount': 'target_amount',
    'targetDate': 'target_date',
    'createdAt': 'created_at',
  },
);

Map<String, dynamic> _$SavingPlanToJson(_SavingPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'account_code': instance.accountCode,
      'account_name': instance.accountName,
      'icon_code': ?instance.iconCode,
      'target_amount': ?instance.targetAmount,
      'target_date': ?instance.targetDate,
      'note': ?instance.note,
      'status': instance.status,
      'balance': instance.balance,
      'progress': ?instance.progress,
      'created_at': instance.createdAt,
    };
