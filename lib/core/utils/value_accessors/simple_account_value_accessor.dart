import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A value accessor for SimpleAccountModel that displays the account name in the UI
/// but keeps the full model in the form control
class SimpleAccountValueAccessor
    extends ControlValueAccessor<SimpleAccountModel, String> {
  @override
  String? modelToViewValue(SimpleAccountModel? modelValue) {
    // Convert the model value (SimpleAccountModel) to the view value (String)
    return modelValue?.name;
  }

  @override
  SimpleAccountModel? viewToModelValue(String? viewValue) {
    // For this use case we don't convert from string back to model,
    // since we can't uniquely identify the account from just the name string.
    // This is appropriate when the field is read-only or when the model
    // is set programmatically rather than by user typing.
    return null;
  }
}
