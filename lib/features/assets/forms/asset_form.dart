import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AssetForm extends FormGroup {
  AssetForm()
    : super({
        AccountKey.name: FormControl<String>(validators: [Validators.required]),
        AccountKey.code: FormControl<String>(validators: [Validators.required]),
        _AdditionalField.balance: FormControl<int>(
          validators: [
            Validators.number(
              allowedDecimals: 0,
              allowNull: true,
              allowNegatives: false,
            ),
          ],
        ),
        AccountKey.iconCode: FormControl<int>(),
      });

  FormControl<String> get nameControl =>
      control(AccountKey.name) as FormControl<String>;
  FormControl<String> get codeControl =>
      control(AccountKey.code) as FormControl<String>;
  FormControl<int> get iconCodeControl =>
      control(AccountKey.iconCode) as FormControl<int>;
  FormControl<int> get balanceControl =>
      control(_AdditionalField.balance) as FormControl<int>;

  String? get name => nameControl.value;
  String? get code => codeControl.value;
  int? get iconCode => iconCodeControl.value;
  int? get balance => balanceControl.value;
}

abstract class _AdditionalField {
  static const balance = 'balance';
}
