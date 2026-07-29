import 'package:reactive_forms/reactive_forms.dart';

class AssetSelectorForm extends FormGroup {
  AssetSelectorForm()
    : super(
        {
          AssetSelectorFieldKey.id: FormControl<int>(
            validators: [Validators.required],
          ),
          AssetSelectorFieldKey.name: FormControl<String>(
            validators: [Validators.required],
          ),
          AssetSelectorFieldKey.balance: FormControl<int>(
            validators: [Validators.required],
          ),
        },
        validators: [Validators.required],
      );

  FormControl<int> get idControl =>
      control(AssetSelectorFieldKey.id) as FormControl<int>;

  FormControl<String> get nameControl =>
      control(AssetSelectorFieldKey.name) as FormControl<String>;

  FormControl<int> get balanceControl =>
      control(AssetSelectorFieldKey.balance) as FormControl<int>;

  int? get id => idControl.value;

  String? get name => nameControl.value;

  int? get balance => balanceControl.value;
}

abstract class AssetSelectorFieldKey {
  static const id = 'id';
  static const name = 'name';
  static const balance = 'balance';
}
