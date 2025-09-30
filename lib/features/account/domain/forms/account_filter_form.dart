import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AccountFilterForm extends FormGroup {
  AccountFilterForm()
      : super({
          'keyword': FormControl<String>(),
          'type': FormControl<AccountType>(value: AccountType.all),
        });

  FormControl<String> get keyword => control('keyword') as FormControl<String>;
  FormControl<AccountType> get type =>
      control('type') as FormControl<AccountType>;

  String? get keywordValue => keyword.value;
  AccountType? get typeValue => type.value;

  Map<String, dynamic> toJson() {
    return Map.fromEntries(
      {
        'keyword': keywordValue,
        'type': typeValue == null || typeValue == AccountType.all
            ? null
            : typeValue!.value,
      }.entries.where((entry) => entry.value != null),
    );
  }
}

final accountFilterFormProvider =
    Provider<AccountFilterForm>((ref) => AccountFilterForm());
