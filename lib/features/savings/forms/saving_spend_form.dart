import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Form belanja langsung dari pocket (credit pocket + debit expense).
/// Pocket dikunci dari konteks detail, user hanya pilih kategori + nominal.
class SavingSpendForm extends FormGroup {
  SavingSpendForm()
    : super({
        SavingPlanKey.accountId: FormControl<int>(
          validators: [Validators.required],
        ),
        _FieldKey.categoryId: FormControl<int>(
          validators: [Validators.required],
        ),
        _FieldKey.categoryName: FormControl<String>(
          validators: [Validators.required],
        ),
        _FieldKey.amount: FormControl<int>(
          validators: [
            Validators.required,
            Validators.number(
              allowedDecimals: 0,
              allowNull: true,
              allowNegatives: false,
            ),
          ],
        ),
        _FieldKey.note: FormControl<String>(),
        _FieldKey.date: FormControl<DateTime>(value: DateTime.now()),
      });

  FormControl<int> get pocketIdControl =>
      control(SavingPlanKey.accountId) as FormControl<int>;
  FormControl<int> get categoryIdControl =>
      control(_FieldKey.categoryId) as FormControl<int>;
  FormControl<String> get categoryNameControl =>
      control(_FieldKey.categoryName) as FormControl<String>;
  FormControl<int> get amountControl =>
      control(_FieldKey.amount) as FormControl<int>;
  FormControl<String> get noteControl =>
      control(_FieldKey.note) as FormControl<String>;
  FormControl<DateTime> get dateControl =>
      control(_FieldKey.date) as FormControl<DateTime>;

  int? get pocketId => pocketIdControl.value;
  int? get categoryId => categoryIdControl.value;
  String? get categoryName => categoryNameControl.value;
  int? get amount => amountControl.value;
  String? get note => noteControl.value;
  DateTime? get date => dateControl.value;
}

abstract class _FieldKey {
  static const categoryId = 'category_id';
  static const categoryName = 'category_name';
  static const amount = 'amount';
  static const note = 'note';
  static const date = 'date';
}
