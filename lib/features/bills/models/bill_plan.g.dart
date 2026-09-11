// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillPlan _$BillPlanFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_BillPlan',
  json,
  ($checkedConvert) {
    final val = _BillPlan(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      accountId: $checkedConvert('account_id', (v) => (v as num).toInt()),
      name: $checkedConvert('name', (v) => v as String),
      amount: $checkedConvert('amount', (v) => (v as num).toInt()),
      period: $checkedConvert('period', (v) => v as String),
      billedSchedule: $checkedConvert('billed_schedule', (v) => v as String),
      dueDateSchedule: $checkedConvert('due_date_schedule', (v) => v as String),
      reminderDays: $checkedConvert(
        'reminder_days',
        (v) => (v as num?)?.toInt(),
      ),
      endedAt: $checkedConvert('ended_at', (v) => (v as num?)?.toInt()),
      reference: $checkedConvert('reference', (v) => v as String?),
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
    'billedSchedule': 'billed_schedule',
    'dueDateSchedule': 'due_date_schedule',
    'reminderDays': 'reminder_days',
    'endedAt': 'ended_at',
    'isDeleted': 'is_deleted',
    'createdAt': 'created_at',
  },
);

Map<String, dynamic> _$BillPlanToJson(_BillPlan instance) => <String, dynamic>{
  'id': instance.id,
  'account_id': instance.accountId,
  'name': instance.name,
  'amount': instance.amount,
  'period': instance.period,
  'billed_schedule': instance.billedSchedule,
  'due_date_schedule': instance.dueDateSchedule,
  'reminder_days': ?instance.reminderDays,
  'ended_at': ?instance.endedAt,
  'reference': ?instance.reference,
  'note': ?instance.note,
  'is_deleted': instance.isDeleted,
  'created_at': instance.createdAt,
};
