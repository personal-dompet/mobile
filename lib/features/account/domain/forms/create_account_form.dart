import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateAccountForm extends FormGroup {
  CreateAccountForm()
      : super({
          'name': FormControl<String>(
            validators: [Validators.required],
          ),
          'color': FormControl<PocketColor>(),
          'type': FormControl<AccountType>(),
        });

  FormControl<String> get name => control('name') as FormControl<String>;
  FormControl<PocketColor> get color =>
      control('color') as FormControl<PocketColor>;
  FormControl<AccountType> get type =>
      control('type') as FormControl<AccountType>;

  String get nameValue => name.value ?? '';
  PocketColor? get colorValue => color.value;
  AccountType? get typeValue => type.value;

  Map<String, dynamic> get json => Map.fromEntries({
        'name': nameValue,
        'color': colorValue?.toHex(),
        'type': typeValue?.value,
      }.entries);

  AccountModel toAccountModel() {
    return AccountModel.placeholder(
      color: colorValue,
      name: nameValue,
      type: typeValue,
    );
  }
}

final createAccountFormProvider = Provider<CreateAccountForm>((ref) {
  return CreateAccountForm();
});
