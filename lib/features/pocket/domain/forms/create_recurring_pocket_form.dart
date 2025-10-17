import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateRecurringPocketForm extends FormGroup {
  CreateRecurringPocketForm()
      : super({
          'productName': FormControl<String>(validators: [Validators.required]),
          'amount': FormControl<int>(validators: [Validators.required]),
          'productDescription': FormControl<String>(),
          'dueDate': FormControl<DateTime>(),
        });

  FormControl<String> get productName =>
      control('productName') as FormControl<String>;
  FormControl<int> get amount => control('amount') as FormControl<int>;
  FormControl<String> get productDescription =>
      control('productDescription') as FormControl<String>;
  FormControl<DateTime> get dueDate =>
      control('dueDate') as FormControl<DateTime>;

  String get productNameValue => productName.value ?? '';
  int get amountValue => amount.value ?? 0;
  String get productDescriptionValue => productDescription.value ?? '';
  DateTime? get dueDateValue => dueDate.value;

  Map<String, dynamic> get json => Map.fromEntries({
        'productName': productNameValue,
        'amount': amountValue,
        'productDescription': productDescriptionValue,
        'dueDate': dueDateValue != null
            ? (dueDateValue!.millisecondsSinceEpoch / 1000).toInt()
            : null,
      }.entries);
}

final createRecurringPocketFormProvider =
    Provider<CreateRecurringPocketForm>((ref) {
  return CreateRecurringPocketForm();
});
