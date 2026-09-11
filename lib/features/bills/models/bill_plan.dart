import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_plan.freezed.dart';
part 'bill_plan.g.dart';

@freezed
abstract class BillPlan with _$BillPlan {
  const BillPlan._();
  const factory BillPlan({
    @JsonKey(name: BillPlanKey.id) required int id,
    @JsonKey(name: BillPlanKey.accountId) required int accountId,
    @JsonKey(name: BillPlanKey.name) required String name,
    @JsonKey(name: BillPlanKey.amount) required int amount,
    @JsonKey(name: BillPlanKey.period) required String period,
    @JsonKey(name: BillPlanKey.billedSchedule) required String billedSchedule,
    @JsonKey(name: BillPlanKey.dueDateSchedule)
    required String dueDateSchedule,
    @JsonKey(name: BillPlanKey.reminderDays) int? reminderDays,
    @JsonKey(name: BillPlanKey.endedAt) int? endedAt,
    @JsonKey(name: BillPlanKey.reference) String? reference,
    @JsonKey(name: BillPlanKey.note) String? note,
    @JsonKey(name: BillPlanKey.isDeleted) @Default(0) int isDeleted,
    @JsonKey(name: BillPlanKey.createdAt) @Default(0) int createdAt,
  }) = _BillPlan;

  factory BillPlan.fromJson(Map<String, dynamic> json) =>
      _$BillPlanFromJson(json);
}
