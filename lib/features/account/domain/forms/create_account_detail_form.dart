import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateAccountDetailForm extends FormGroup {
  CreateAccountDetailForm()
      : super({
          'provider': FormControl<String>(),
          'accountNumber': FormControl<String>(validators: [
            Validators.minLength(8),
            Validators.maxLength(32),
          ]),
        });

  FormControl<String> get provider =>
      control('provider') as FormControl<String>;
  FormControl<String> get accountNumber =>
      control('accountNumber') as FormControl<String>;

  String? get providerValue => provider.value;
  String? get accountNumberValue => accountNumber.value;

  String? get maskedAccountNumber {
    if (accountNumberValue == null || accountNumberValue!.length < 8) {
      return null;
    }

    String first3 = accountNumberValue!.substring(0, 3);
    String last3 =
        accountNumberValue!.substring(accountNumberValue!.length - 3);

    return '$first3...$last3';
  }

  Map<String, dynamic> get json => Map.fromEntries({
        'provider': providerValue,
        'accountNumber': maskedAccountNumber,
      }.entries);
}

final createAccountDetailFormProvider =
    Provider<CreateAccountDetailForm>((ref) {
  return CreateAccountDetailForm();
});
