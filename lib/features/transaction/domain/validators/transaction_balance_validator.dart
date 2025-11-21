import 'package:dompet/core/validators/amount_balance_validator.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TransactionBalanceValidator extends Validator<FormGroup> {
  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    if (control is! FormGroup) {
      return null;
    }

    final form = control;
    final typeControl = form.control('type') as FormControl<TransactionType>;
    final amountControl = form.control('amount');

    if (typeControl.value == TransactionType.income) return null;

    final isPocketValid =
        AmountBalanceValidator.forPocket(controlName: 'pocket').validate(form);
    final isAccountValid =
        AmountBalanceValidator.forAccount(controlName: 'account')
            .validate(form);

    Map<String, bool>? errors;

    if (isAccountValid != null && isPocketValid != null) {
      errors = {'exceedsBalance': true};
    }

    if (isAccountValid == null && isPocketValid != null) {
      errors = {'exceedsPocketBalance': true};
    }

    if (isAccountValid != null && isPocketValid == null) {
      errors = {'exceedsAccountBalance': true};
    }

    if (errors != null) {
      amountControl.setErrors(errors);
    }

    return errors;
  }
}
