import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateAccountDetailForm extends FormGroup {
  CreateAccountDetailForm()
      : super({
          'provider': FormControl<String>(),
          'accountNumber': FormControl<String>(),
        });

  FormControl<String> get provider =>
      control('provider') as FormControl<String>;
  FormControl<String> get accountNumber =>
      control('accountNumber') as FormControl<String>;

  String? get providerValue => provider.value;
  String? get accountNumberValue => accountNumber.value;

  Map<String, dynamic> get json => Map.fromEntries({
        'provider': providerValue,
        'accountNumber': accountNumberValue,
      }.entries);
}

final createAccountDetailFormProvider =
    Provider<CreateAccountDetailForm>((ref) {
  return CreateAccountDetailForm();
});
