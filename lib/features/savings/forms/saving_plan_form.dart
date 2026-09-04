import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SavingPlanForm extends FormGroup {
  SavingPlanForm()
    : super({
        AccountKey.name: FormControl<String>(
          validators: [Validators.required],
        ),
        AccountKey.iconCode: FormControl<int>(),
        SavingPlanKey.targetAmount: FormControl<int>(
          validators: [
            Validators.number(
              allowedDecimals: 0,
              allowNull: true,
              allowNegatives: false,
            ),
          ],
        ),
        SavingPlanKey.targetDate: FormControl<DateTime>(),
        SavingPlanKey.note: FormControl<String>(),
      });

  FormControl<String> get nameControl =>
      control(AccountKey.name) as FormControl<String>;
  FormControl<int> get iconCodeControl =>
      control(AccountKey.iconCode) as FormControl<int>;
  FormControl<int> get targetAmountControl =>
      control(SavingPlanKey.targetAmount) as FormControl<int>;
  FormControl<DateTime> get targetDateControl =>
      control(SavingPlanKey.targetDate) as FormControl<DateTime>;
  FormControl<String> get noteControl =>
      control(SavingPlanKey.note) as FormControl<String>;

  String? get name => nameControl.value;
  int? get iconCode => iconCodeControl.value;
  int? get targetAmount => targetAmountControl.value;
  DateTime? get targetDate => targetDateControl.value;
  String? get note => noteControl.value;
}
