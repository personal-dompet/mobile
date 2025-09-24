import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateSpendingPocketForm extends FormGroup {
  CreateSpendingPocketForm()
      : super({
          'name': FormControl<String>(
            validators: [Validators.required],
          ),
          'color': FormControl<String?>(),
          'icon': FormControl<String?>(),
          'balance': FormControl<int?>(),
          'lowBalanceThreshold': FormControl<int?>(),
          'lowBalanceReminder': FormControl<bool>(),
        });

  FormControl<String> get nameControl => control('name') as FormControl<String>;
  FormControl<String?> get colorControl =>
      control('color') as FormControl<String?>;
  FormControl<String?> get iconControl =>
      control('icon') as FormControl<String?>;
  FormControl<int?> get balanceControl =>
      control('balance') as FormControl<int?>;
  FormControl<int?> get lowBalanceThresholdControl =>
      control('lowBalanceThreshold') as FormControl<int?>;
  FormControl<bool> get lowBalanceReminderControl =>
      control('lowBalanceReminder') as FormControl<bool>;

  String get name => nameControl.value ?? '';
  String? get color => colorControl.value;
  String? get icon => iconControl.value;
  int? get balance => balanceControl.value;
  int? get lowBalanceThreshold => lowBalanceThresholdControl.value;
  bool get lowBalanceReminder => lowBalanceReminderControl.value ?? false;

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color,
        'icon': icon,
        'balance': balance,
        'lowBalanceThreshold': lowBalanceThreshold,
        'lowBalanceReminder': lowBalanceReminder,
      };
}

final createSpendingPocketFormProvider =
    Provider.autoDispose<CreateSpendingPocketForm>(
        (ref) => CreateSpendingPocketForm());
