import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saving_plan.freezed.dart';
part 'saving_plan.g.dart';

@freezed
abstract class SavingPlan with _$SavingPlan {
  const SavingPlan._();
  const factory SavingPlan({
    @JsonKey(name: SavingPlanKey.id) required int id,
    @JsonKey(name: SavingPlanKey.accountId) required int accountId,
    @JsonKey(name: SavingPlanKey.accountCode) required String accountCode,
    @JsonKey(name: SavingPlanKey.accountName) required String accountName,
    @JsonKey(name: SavingPlanKey.iconCode) int? iconCode,
    @JsonKey(name: SavingPlanKey.targetAmount) int? targetAmount,
    @JsonKey(name: SavingPlanKey.targetDate) int? targetDate,
    @JsonKey(name: SavingPlanKey.note) String? note,
    @JsonKey(name: SavingPlanKey.status) @Default('ACTIVE') String status,
    @JsonKey(name: SavingPlanKey.balance) @Default(0) int balance,
    @JsonKey(name: SavingPlanKey.progress) double? progress,
    @JsonKey(name: SavingPlanKey.createdAt) @Default(0) int createdAt,
  }) = _SavingPlan;

  factory SavingPlan.fromJson(Map<String, dynamic> json) =>
      _$SavingPlanFromJson(json);

  DateTime? get targetDateTime => targetDate?.dateTime;

  bool get hasTarget => targetAmount != null && targetAmount! > 0;

  /// Rasio 0.0 - 1.0 untuk progress bar. Null jika tanpa target.
  /// Bisa > 1.0 jika balance melebihi target (over-achieved).
  double? get progressRatio {
    if (!hasTarget) return null;
    return balance / targetAmount!;
  }

  int get remaining {
    if (!hasTarget) return 0;
    return targetAmount! - balance;
  }

  bool get isTargetReached => hasTarget && balance >= targetAmount!;

  String get progressLabel {
    if (!hasTarget) return balance.currency;
    return '${balance.currency} / ${targetAmount!.currency}';
  }
}
