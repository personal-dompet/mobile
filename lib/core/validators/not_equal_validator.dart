import 'package:dompet/core/constants/error_key.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A validator that ensures two fields in a form group have different values.
///
/// This is useful for cases where you want to ensure two fields don't have the same value,
/// such as ensuring transfer 'from' and 'to' pockets are different.
class NotEqualValidator extends Validator<dynamic> {
  final String controlName;
  final String comparisonControlName;
  final ErrorKey? errorKey;

  /// Creates a new [NotEqualValidator] instance.
  ///
  /// [controlName] is the name of the control to compare.
  /// [comparisonControlName] is the name of the control to compare against.
  /// [errorKey] is an optional custom error key to use (defaults to ErrorKey.notEqual).
  NotEqualValidator(
    this.controlName,
    this.comparisonControlName, {
    this.errorKey,
  }) : super();

  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    // Only proceed if the control is a FormGroup
    if (control is! FormGroup) {
      return null;
    }

    final form = control;
    final controlToValidate = form.control(controlName);
    final comparisonControl = form.control(comparisonControlName);

    // Only validate if both controls exist and have values
    if (controlToValidate.value != null && comparisonControl.value != null) {
      // If the values are equal, add an error to the control being validated
      if (controlToValidate.value == comparisonControl.value) {
        final errorKeyToUse = errorKey ?? ErrorKey.notEqual;
        return {errorKeyToUse.name: true};
      }
    }

    // Return null if validation passes
    return null;
  }
}
