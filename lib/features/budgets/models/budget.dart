import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

@freezed
abstract class Budget with _$Budget {
  const Budget._();
  const factory Budget({
    @JsonKey(name: BudgetKey.id) required int id,
    @JsonKey(name: BudgetKey.accountId) required int accountId,
    @JsonKey(name: BudgetKey.accountName) required String accountName,
    @JsonKey(name: BudgetKey.budgetedAmount) required int budgetAmount,
    @JsonKey(name: BudgetKey.periodStart) required int periodStart,
    @JsonKey(name: BudgetKey.periodEnd) required int periodEnd,
    @JsonKey(name: BudgetKey.actualSpend) @Default(0) int actualSpend,
    @JsonKey(name: BudgetKey.carryAmount) @Default(0) int carryAmount,
    @JsonKey(name: BudgetKey.leftover) @Default(0) int leftover,
    @JsonKey(name: BudgetKey.closedAt) int? closedAt,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  DateTime get periodStartDate => periodStart.dateTime;
  DateTime get periodEndDate => periodEnd.dateTime;
  double get useageRatio => actualSpend / budgetAmount;
  String get periode => periodStartDate.format(hideDate: true);
  bool get isOutOfPeriod {
    final now = DateTime.now();
    return !DateUtils.isSameMonth(now, periodEndDate);
  }
}
