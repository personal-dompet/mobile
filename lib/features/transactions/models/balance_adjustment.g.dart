// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_adjustment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BalanceAdjustment _$BalanceAdjustmentFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_BalanceAdjustment',
      json,
      ($checkedConvert) {
        final val = _BalanceAdjustment(
          previousBalance: $checkedConvert(
            'previous_balance',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          currentBalance: $checkedConvert(
            'current_balance',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'previousBalance': 'previous_balance',
        'currentBalance': 'current_balance',
      },
    );

Map<String, dynamic> _$BalanceAdjustmentToJson(_BalanceAdjustment instance) =>
    <String, dynamic>{
      'previous_balance': instance.previousBalance,
      'current_balance': instance.currentBalance,
    };
