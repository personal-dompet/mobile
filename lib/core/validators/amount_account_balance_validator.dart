import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A validator that checks if the amount does not exceed the from pocket balance
class AmountAccountBalanceValidator extends Validator<dynamic> {
  final String controlName;
  final String errorKey;

  AmountAccountBalanceValidator({
    required this.controlName,
    this.errorKey = 'exceedsBalance',
  });

  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    // Only proceed if the control is a FormGroup
    if (control is! FormGroup) {
      return null;
    }

    final form = control;
    final amountControl = form.control('amount');
    final fromAccountControl = form.control(controlName);

    // Skip validation if either control is null or doesn't have a value
    if (amountControl.value == null || fromAccountControl.value == null) {
      return null;
    }

    // Ensure both values are of the expected types
    if (amountControl.value is! int ||
        fromAccountControl.value is! AccountModel) {
      return null;
    }

    final int amount = amountControl.value as int;
    final AccountModel fromPocket = fromAccountControl.value as AccountModel;

    // Check if amount exceeds pocket balance
    if (amount > fromPocket.balance) {
      amountControl.setErrors({errorKey: true});
      return {errorKey: true};
    }

    // Return null if validation passes
    return null;
  }
}
