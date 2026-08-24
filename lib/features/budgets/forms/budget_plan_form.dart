import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BudgetPlanForm extends FormGroup {
  BudgetPlanForm()
    : super({
        BudgetPlanKey.accountId: FormControl<int>(
          validators: [Validators.required],
        ),
        _FieldKey.categoryName: FormControl<String>(
          validators: [Validators.required],
        ),
        BudgetPlanKey.amount: FormControl<int>(
          validators: [Validators.required],
        ),
        BudgetPlanKey.note: FormControl<String>(),
      });

  FormControl<int> get categoryIdControl =>
      control(BudgetPlanKey.accountId) as FormControl<int>;
  FormControl<String> get categoryNameControl =>
      control(_FieldKey.categoryName) as FormControl<String>;
  FormControl<int> get amountControl =>
      control(BudgetPlanKey.amount) as FormControl<int>;
  FormControl<String> get noteControl =>
      control(BudgetPlanKey.note) as FormControl<String>;

  int? get categoryId => categoryIdControl.value;
  String? get categoryName => categoryNameControl.value;
  int get amount => amountControl.value ?? 0;
  String? get note => noteControl.value;
}

abstract class _FieldKey {
  static const categoryName = 'category_name';
}
