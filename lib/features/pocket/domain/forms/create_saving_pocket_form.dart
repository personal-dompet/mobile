import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateSavingPocketForm extends FormGroup {
  CreateSavingPocketForm()
      : super({
          'targetAmount': FormControl<int>(),
          'targetDescription': FormControl<String>(),
          'targetDate': FormControl<DateTime>(),
        });

  FormControl<int> get targetAmount =>
      control('targetAmount') as FormControl<int>;
  FormControl<String> get targetDescription =>
      control('targetDescription') as FormControl<String>;
  FormControl<DateTime> get targetDate =>
      control('targetDate') as FormControl<DateTime>;

  int get targetAmountValue => targetAmount.value ?? 0;
  String get targetDescriptionValue => targetDescription.value ?? '';
  DateTime? get targetDateValue => targetDate.value;

  Map<String, dynamic> get json => Map.fromEntries({
        'targetAmount': targetAmountValue,
        'targetDescription': targetDescriptionValue,
        'targetDate': targetDateValue != null
            ? (targetDateValue!.millisecondsSinceEpoch / 1000).toInt()
            : null,
      }.entries);
}

final createSavingPocketFormProvider = Provider<CreateSavingPocketForm>((ref) {
  return CreateSavingPocketForm();
});
