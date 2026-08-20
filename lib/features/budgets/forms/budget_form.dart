import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BudgetForm extends FormGroup {
  BudgetForm()
    : super({
        _FieldKey.account: FormControl<Account>(
          validators: [Validators.required],
        ),
        BudgetPlanKey.amount: FormControl<int>(
          validators: [Validators.required],
        ),
        BudgetPlanKey.note: FormControl<String>(),
      });

  FormControl<Account> get accountControl =>
      control(_FieldKey.account) as FormControl<Account>;
  FormControl<int> get amountControl =>
      control(BudgetPlanKey.amount) as FormControl<int>;
  FormControl<String> get noteControl =>
      control(BudgetPlanKey.note) as FormControl<String>;

  Account? get account => accountControl.value;
  int get amount => amountControl.value ?? 0;
  String? get note => noteControl.value;
}

abstract class _FieldKey {
  static const account = 'account';
}