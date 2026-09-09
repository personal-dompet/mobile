import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/validators/dompet_amount_validators.dart';
import 'package:dompet_app/features/assets/forms/asset_selector_form.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Form alokasi (topup) & penarikan (withdraw) pocket.
/// Arah ditentukan pemanggil: topup = asset cair -> pocket,
/// withdraw = pocket -> asset cair.
class SavingAllocationForm extends FormGroup {
  SavingAllocationForm()
    : super({
        SavingPlanKey.accountId: FormControl<int>(
          validators: [Validators.required],
        ),
        _FieldKey.asset: AssetSelectorForm(),
        _FieldKey.amount: FormControl<int>(
          validators: DompetAmountValidators.min1(),
        ),
        _FieldKey.note: FormControl<String>(),
        _FieldKey.date: FormControl<DateTime>(value: DateTime.now()),
      });

  FormControl<int> get pocketIdControl =>
      control(SavingPlanKey.accountId) as FormControl<int>;

  AssetSelectorForm get assetForm =>
      control(_FieldKey.asset) as AssetSelectorForm;

  FormControl<int> get amountControl =>
      control(_FieldKey.amount) as FormControl<int>;

  FormControl<String> get noteControl =>
      control(_FieldKey.note) as FormControl<String>;

  FormControl<DateTime> get dateControl =>
      control(_FieldKey.date) as FormControl<DateTime>;

  int? get pocketId => pocketIdControl.value;
  int? get assetId => assetForm.id;
  String? get assetName => assetForm.name;
  int? get assetBalance => assetForm.balance;
  int? get amount => amountControl.value;
  String? get note => noteControl.value;
  DateTime? get date => dateControl.value;
}

abstract class _FieldKey {
  static const asset = 'asset';
  static const amount = 'amount';
  static const note = 'note';
  static const date = 'date';
}
