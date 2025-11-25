import 'package:dompet/core/constants/error_key.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AmountBalanceValidator extends Validator<FormGroup> {
  final String controlName;
  final ErrorKey errorKey;
  final bool forAccount;

  AmountBalanceValidator._({
    required this.controlName,
    this.errorKey = ErrorKey.exceedsBalance,
    required this.forAccount,
  });

  factory AmountBalanceValidator.forAccount({
    required String controlName,
    ErrorKey errorKey = ErrorKey.exceedsBalance,
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
    ErrorKey errorKey = ErrorKey.exceedsBalance,
  }) {
    return AmountBalanceValidator._(
      controlName: controlName,
      errorKey: errorKey,
      forAccount: false,
    );
  }

  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    if (control is! FormGroup) {
      return null;
    }

    final form = control;
    final amountControl = form.control('amount');
    final fromControl = form.control(controlName);

    if (amountControl.value == null ||
        fromControl.value == null ||
        amountControl.value is! int) {
      return null;
    }

    final int amount = amountControl.value as int;

    int? balance;
    if (forAccount && fromControl.value is AccountModel) {
      balance = (fromControl.value as AccountModel).balance;
    } else if (!forAccount && fromControl.value is PocketModel) {
      balance = (fromControl.value as PocketModel).balance;
    } else {
      return null;
    }

    if (amount > balance) {
      amountControl.setErrors({errorKey.name: true});
      return {errorKey.name: true};
    }

    return null;
  }
}
