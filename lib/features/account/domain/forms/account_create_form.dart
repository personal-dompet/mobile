import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AccountCreateForm extends FormGroup {
  AccountCreateForm()
      : super({
          'name': FormControl<String>(
            validators: [Validators.required],
          ),
          'color': FormControl<PocketColor>(),
          'type': FormControl<AccountType>(),
        });

  FormControl<String> get nameControl => control('name') as FormControl<String>;
  FormControl<PocketColor> get colorControl =>
      control('color') as FormControl<PocketColor>;
  FormControl<AccountType> get typeControl =>
      control('type') as FormControl<AccountType>;

  String get name => nameControl.value ?? '';
  PocketColor? get color => colorControl.value;
  AccountType? get type => typeControl.value;

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color?.toHex(),
        'type': type?.value,
      };
}

final accountCreateFormProvider = Provider<AccountCreateForm>((ref) {
  return AccountCreateForm();
});