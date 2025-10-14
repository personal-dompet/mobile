import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateSpendingPocketForm extends FormGroup {
  CreateSpendingPocketForm()
      : super({
          'lowBalanceThreshold': FormControl<int>(),
          'lowBalanceReminder': FormControl<bool>(),
        });

  FormControl<int> get lowBalanceThreshold =>
      control('lowBalanceThreshold') as FormControl<int>;
  FormControl<bool> get lowBalanceReminder =>
      control('lowBalanceReminder') as FormControl<bool>;

  int get lowBalanceThresholdValue => lowBalanceThreshold.value ?? 0;
  bool get lowBalanceReminderValue => lowBalanceReminder.value ?? false;

  Map<String, dynamic> get json => Map.fromEntries({
        'lowBalanceThreshold': lowBalanceThresholdValue,
        'lowBalanceReminder': lowBalanceReminderValue,
      }.entries);
}

final createSpendingPocketFormProvider =
    Provider.autoDispose<CreateSpendingPocketForm>((ref) {
  return CreateSpendingPocketForm();
});
