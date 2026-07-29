import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/assets/forms/asset_selector_form.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TransferForm extends FormGroup {
  TransferForm()
    : super({
        _FieldKey.source: AssetSelectorForm(),
        _FieldKey.destination: AssetSelectorForm(),
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

  AssetSelectorForm get sourceForm =>
      control(_FieldKey.source) as AssetSelectorForm;

  AssetSelectorForm get destinationForm =>
      control(_FieldKey.destination) as AssetSelectorForm;

  FormControl<int> get amountControl =>
      control(_FieldKey.amount) as FormControl<int>;

  FormControl<String> get noteControl =>
      control(_FieldKey.note) as FormControl<String>;

  FormControl<DateTime> get dateControl =>
      control(_FieldKey.date) as FormControl<DateTime>;

  int? get accountSourceId => sourceForm.id;
  String? get accountSourceName => sourceForm.name;
  int? get accountSourceBalance => sourceForm.balance;
  int? get accountDestinationId => destinationForm.id;
  String? get accountDestinationName => destinationForm.name;
  int? get accountDestinationeBalance => destinationForm.balance;
  int? get amount => amountControl.value;
  String? get note => noteControl.value;
  DateTime? get date => dateControl.value;
}

abstract class _FieldKey {
  static const amount = 'amount';
  static const source = 'source';
  static const destination = 'destination';
  static const note = 'note';
  static const date = 'date';
}

class AccountValueAccessor extends ControlValueAccessor<Account, String> {
  @override
  String modelToViewValue(Account? modelValue) {
    return modelValue == null ? '' : modelValue.name;
  }

  @override
  Account? viewToModelValue(String? viewValue) {
    return null;
  }
}
