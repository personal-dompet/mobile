import 'package:reactive_forms/reactive_forms.dart';

/// Single source of truth for money-amount validation (FIX-01: min 1 global).
///
/// Every nominal money field (income, expense incl. batch items, transfer,
/// budget plan, saving topup/withdraw/spend) must reject 0, negative, null,
/// and decimals. `BalanceAdjustmentForm.amount` is intentionally exempt: it
/// holds the *new balance* (0 is a legitimate balance); its no-op guard
/// lives in [BalanceAdjustmentRepository] instead.
abstract final class DompetAmountValidators {
  /// Minimum accepted nominal. See Q1 decision: min 1 global, integer.
  static const int minAmount = 1;

  /// Uniform repo/form message. See Q2 decision.
  static const String belowMinMessage = 'Nominal harus lebih dari 0';

  /// `required + number(0 decimals, no negatives) + min(1)`.
  ///
  /// Set [required] to false for optional amount fields (e.g. saving target):
  /// null stays valid, but a filled value must still be >= 1.
  static List<Validator<dynamic>> min1({bool required = true}) => [
    if (required) Validators.required,
    Validators.number(
      allowedDecimals: 0,
      allowNull: true,
      allowNegatives: false,
    ),
    if (required)
      Validators.min(minAmount)
    else
      // Optional fields: null stays valid, a filled value must be >= 1
      // (MinValidator alone fails on null).
      Validators.delegate(
        (control) => control.value == null
            ? null
            : Validators.min(minAmount).validate(control),
      ),
  ];
}
