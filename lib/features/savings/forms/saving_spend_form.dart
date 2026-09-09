import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/validators/dompet_amount_validators.dart';
import 'package:dompet_app/features/assets/forms/asset_selector_form.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// FIX-09 (IMP-7 opsi B): belanja = tarik ke dompet + pengeluaran biasa.
/// Pocket dikunci dari konteks detail; user pilih dompet perantara
/// ("Dari Dompet") + nominal; kategori opsional (kosong → Lain-Lain).
class SavingSpendForm extends FormGroup {
  SavingSpendForm()
    : super({
        SavingPlanKey.accountId: FormControl<int>(
          validators: [Validators.required],
        ),
        _FieldKey.categoryId: FormControl<int>(),
        _FieldKey.categoryName: FormControl<String>(),
        _FieldKey.asset: AssetSelectorForm(),
        _FieldKey.amount: FormControl<int>(
          validators: DompetAmountValidators.min1(),
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
  AssetSelectorForm get assetForm =>
      control(_FieldKey.asset) as AssetSelectorForm;
  FormControl<int> get amountControl =>
      control(_FieldKey.amount) as FormControl<int>;
  FormControl<String> get noteControl =>
      control(_FieldKey.note) as FormControl<String>;
  FormControl<DateTime> get dateControl =>
      control(_FieldKey.date) as FormControl<DateTime>;

  int? get pocketId => pocketIdControl.value;
  int? get categoryId => categoryIdControl.value;
  String? get categoryName => categoryNameControl.value;
  int? get assetId => assetForm.id;
  String? get assetName => assetForm.name;
  int? get assetBalance => assetForm.balance;
  int? get amount => amountControl.value;
  String? get note => noteControl.value;
  DateTime? get date => dateControl.value;
}

abstract class _FieldKey {
  static const categoryId = 'category_id';
  static const categoryName = 'category_name';
  static const asset = 'asset';
  static const amount = 'amount';
  static const note = 'note';
  static const date = 'date';
}
