import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BalanceAdjustmentForm extends FormGroup {
  BalanceAdjustmentForm()
    : super({
        _FieldKey.amount: FormControl<int>(validators: [Validators.required]),
        _FieldKey.account: FormControl<Account>(
          validators: [Validators.required],
        ),
      });

  FormControl<int> get amountControl =>
      control(_FieldKey.amount) as FormControl<int>;
  FormControl<Account> get accountControl =>
      control(_FieldKey.account) as FormControl<Account>;

  int? get amount => amountControl.value;
  Account? get account => accountControl.value;
}

abstract class _FieldKey {
  static const amount = 'amount';
  static const account = 'account';
}
