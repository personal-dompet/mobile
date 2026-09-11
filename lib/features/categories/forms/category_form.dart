import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/models/account_icon_option.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CategoryForm extends FormGroup {
  CategoryForm()
    : super({
        AccountKey.name: FormControl<String>(validators: [Validators.required]),
        AccountKey.type: FormControl<AccountType>(
          validators: [Validators.required],
        ),
        'icon': FormControl<AccountIconOption>(),
      });

  FormControl<String> get nameControl =>
      control(AccountKey.name) as FormControl<String>;
  FormControl<AccountType> get typeControl =>
      control(AccountKey.type) as FormControl<AccountType>;
  FormControl<AccountIconOption> get iconControl =>
      control('icon') as FormControl<AccountIconOption>;

  String? get name => nameControl.value;
  AccountType? get type => typeControl.value;
  AccountIconOption? get icon => iconControl.value;

  /// Default ikon per tipe bila user tak memilih (dipakai repository
  /// agar data layer bebas dependensi material).
  int get resolvedIconCode => switch (type) {
    .expense => icon?.icon.codePoint ?? Icons.account_balance_wallet_rounded.codePoint,
    .income => icon?.icon.codePoint ?? Icons.payment_rounded.codePoint,
    _ => Icons.wallet_rounded.codePoint,
  };
}
