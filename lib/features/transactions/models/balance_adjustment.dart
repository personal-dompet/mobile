import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_adjustment.freezed.dart';
part 'balance_adjustment.g.dart';

@freezed
abstract class BalanceAdjustment with _$BalanceAdjustment {
  const BalanceAdjustment._();
  const factory BalanceAdjustment({
    @JsonKey(name: 'previous_balance') @Default(0) int previousBalance,
    @JsonKey(name: 'current_balance') @Default(0) int currentBalance,
  }) = _BalanceAdjustment;

  factory BalanceAdjustment.fromJson(Map<String, dynamic> json) =>
      _$BalanceAdjustmentFromJson(json);

  int get difference => currentBalance - previousBalance;
}
