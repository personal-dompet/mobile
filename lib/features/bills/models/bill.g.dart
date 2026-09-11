// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bill _$BillFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Bill',
  json,
  ($checkedConvert) {
    final val = _Bill(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      billPlanId: $checkedConvert('bill_plan_id', (v) => (v as num).toInt()),
      amount: $checkedConvert('amount', (v) => (v as num).toInt()),
      billPeriod: $checkedConvert('bill_period', (v) => v as String),
      billedAt: $checkedConvert('billed_at', (v) => (v as num).toInt()),
      dueDate: $checkedConvert('due_date', (v) => (v as num).toInt()),
      remindedAt: $checkedConvert('reminded_at', (v) => (v as num).toInt()),
      status: $checkedConvert('status', (v) => v as String),
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
    'billPlanId': 'bill_plan_id',
    'billPeriod': 'bill_period',
    'billedAt': 'billed_at',
    'dueDate': 'due_date',
    'remindedAt': 'reminded_at',
    'isDeleted': 'is_deleted',
    'createdAt': 'created_at',
  },
);

Map<String, dynamic> _$BillToJson(_Bill instance) => <String, dynamic>{
  'id': instance.id,
  'bill_plan_id': instance.billPlanId,
  'amount': instance.amount,
  'bill_period': instance.billPeriod,
  'billed_at': instance.billedAt,
  'due_date': instance.dueDate,
  'reminded_at': instance.remindedAt,
  'status': instance.status,
  'is_deleted': instance.isDeleted,
  'created_at': instance.createdAt,
};
