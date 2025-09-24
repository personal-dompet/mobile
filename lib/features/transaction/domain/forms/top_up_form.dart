import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TopUpForm extends FormGroup {
  TopUpForm()
      : super({
          'account': FormControl<SimpleAccountModel>(
            validators: [Validators.required],
            value: null,
          ),
          'amount': FormControl<int>(
            validators: [Validators.required, Validators.min(1)],
          ),
          'description': FormControl<String?>(),
        });

  FormControl<SimpleAccountModel> get accountControl =>
      control('account') as FormControl<SimpleAccountModel>;
  FormControl<int> get amountControl => control('amount') as FormControl<int>;
  FormControl<String?> get descriptionControl =>
      control('description') as FormControl<String?>;

  SimpleAccountModel? get account => control('account').value;
  int get amount => control('amount').value;
  String? get description => control('description').value;

  Map<String, dynamic> toJson() {
    return {
      'accountId': account?.id,
      'amount': amount,
      'description': description,
    };
  }
}
