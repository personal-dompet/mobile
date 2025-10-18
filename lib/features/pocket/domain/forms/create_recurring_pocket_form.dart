import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateRecurringPocketForm extends FormGroup {
  CreateRecurringPocketForm()
      : super({
          'productName': FormControl<String>(validators: [Validators.required]),
          'amount': FormControl<int>(validators: [Validators.required]),
          'productDescription': FormControl<String>(),
          'billingDate': FormControl<int>(),
        });

  FormControl<String> get productName =>
      control('productName') as FormControl<String>;
  FormControl<int> get amount => control('amount') as FormControl<int>;
  FormControl<String> get productDescription =>
      control('productDescription') as FormControl<String>;
  FormControl<int> get billingDate =>
      control('billingDate') as FormControl<int>;

  String get productNameValue => productName.value ?? '';
  int get amountValue => amount.value ?? 0;
  String get productDescriptionValue => productDescription.value ?? '';
  int? get billingDateValue => billingDate.value;

  Map<String, dynamic> get json => Map.fromEntries({
        'productName': productNameValue,
        'amount': amountValue,
        'productDescription': productDescriptionValue,
        'billingDate': billingDateValue,
      }.entries);
}

final createRecurringPocketFormProvider =
    Provider<CreateRecurringPocketForm>((ref) {
  return CreateRecurringPocketForm();
});
