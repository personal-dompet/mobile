import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_plan.freezed.dart';
part 'budget_plan.g.dart';

@freezed
abstract class BudgetPlan with _$BudgetPlan {
  const BudgetPlan._();
  const factory BudgetPlan({
    @JsonKey(name: BudgetPlanKey.id) required int id,
    @JsonKey(name: BudgetPlanKey.accountId) required int accountId,
    @JsonKey(name: BudgetPlanKey.amount) required int amount,
    @JsonKey(name: BudgetPlanKey.note) String? note,
    @JsonKey(name: BudgetPlanKey.isDeleted) @Default(0) int isDeleted,
    @JsonKey(name: BudgetPlanKey.createdAt) @Default(0) int createdAt,
  }) = _BudgetPlan;

  factory BudgetPlan.fromJson(Map<String, dynamic> json) =>
      _$BudgetPlanFromJson(json);
}