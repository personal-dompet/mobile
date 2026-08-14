// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Account',
  json,
  ($checkedConvert) {
    final val = _Account(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      code: $checkedConvert('code', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      type: $checkedConvert(
        'type',
        (v) => $enumDecode(_$AccountTypeNameEnumMap, v),
      ),
      isLiquid: $checkedConvert(
        'is_liquid',
        (v) => v == null
            ? false
            : const BoolIntConverter().fromJson((v as num).toInt()),
      ),
      isDeleted: $checkedConvert(
        'is_deleted',
        (v) => v == null
            ? false
            : const BoolIntConverter().fromJson((v as num).toInt()),
      ),
      isSystem: $checkedConvert(
        'is_system',
        (v) => v == null
            ? false
            : const BoolIntConverter().fromJson((v as num).toInt()),
      ),
      iconCode: $checkedConvert('icon_code', (v) => (v as num?)?.toInt()),
      normalbalance: $checkedConvert(
        'normal_balance',
        (v) => $enumDecode(_$BalanceTypeEnumMap, v),
      ),
      balance: $checkedConvert('balance', (v) => (v as num?)?.toInt() ?? 0),
      createdAt: $checkedConvert('created_at', (v) => (v as num).toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'isLiquid': 'is_liquid',
    'isDeleted': 'is_deleted',
    'isSystem': 'is_system',
    'iconCode': 'icon_code',
    'normalbalance': 'normal_balance',
    'createdAt': 'created_at',
  },
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'type': _$AccountTypeNameEnumMap[instance.type]!,
  'is_liquid': const BoolIntConverter().toJson(instance.isLiquid),
  'is_deleted': const BoolIntConverter().toJson(instance.isDeleted),
  'is_system': const BoolIntConverter().toJson(instance.isSystem),
  'icon_code': ?instance.iconCode,
  'normal_balance': _$BalanceTypeEnumMap[instance.normalbalance]!,
  'balance': instance.balance,
  'created_at': instance.createdAt,
};

const _$AccountTypeNameEnumMap = {
  AccountType.asset: 'ASSET',
  AccountType.liability: 'LIABILITY',
  AccountType.equity: 'EQUITY',
  AccountType.income: 'INCOME',
  AccountType.expense: 'EXPENSE',
};

const _$BalanceTypeEnumMap = {
  BalanceType.debit: 'DEBIT',
  BalanceType.credit: 'CREDIT',
};
