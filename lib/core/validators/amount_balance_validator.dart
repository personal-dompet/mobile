import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A validator that checks if the amount does not exceed the from balance
class AmountBalanceValidator extends Validator<FormGroup> {
  final String controlName;
  final String errorKey;
  final bool forAccount; // true for account, false for pocket

  AmountBalanceValidator._({
    required this.controlName,
    this.errorKey = 'exceedsBalance',
    required this.forAccount,
  });

  /// Factory constructor for validating against AccountModel
  factory AmountBalanceValidator.forAccount({
    required String controlName,
    String errorKey = 'exceedsBalance',
  }) {
    return AmountBalanceValidator._(
      controlName: controlName,
      errorKey: errorKey,
      forAccount: true,
    );
  }

  /// Factory constructor for validating against PocketModel
  factory AmountBalanceValidator.forPocket({
    required String controlName,
    String errorKey = 'exceedsBalance',
  }) {
    return AmountBalanceValidator._(
      controlName: controlName,
      errorKey: errorKey,
      forAccount: false,
    );
  }

  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    // Only proceed if the control is a FormGroup
    if (control is! FormGroup) {
      return null;
    }

    final form = control;
    final amountControl = form.control('amount');
    final fromControl = form.control(controlName);

    // Skip validation if either control is null or doesn't have a value
    if (amountControl.value == null || fromControl.value == null) {
      return null;
    }

    // Ensure both values are of the expected types
    if (amountControl.value is! int) {
      return null;
    }

    final int amount = amountControl.value as int;

    // Check if the source is an AccountModel or PocketModel based on the flag
    int? balance;
    if (forAccount && fromControl.value is AccountModel) {
      balance = (fromControl.value as AccountModel).balance;
    } else if (!forAccount && fromControl.value is PocketModel) {
      balance = (fromControl.value as PocketModel).balance;
    } else {
      // If the model type doesn't match what we expect, skip validation
      return null;
    }

    // Check if amount exceeds balance
    if (amount > balance) {
      amountControl.setErrors({errorKey: true});
      return {errorKey: true};
    }

    // Return null if validation passes
    return null;
  }
}
