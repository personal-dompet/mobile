import 'package:dompet/core/validators/amount_account_balance_validator.dart';
import 'package:dompet/core/validators/not_equal_validator.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AccountTransferForm extends FormGroup {
  AccountTransferForm({
    AccountModel? fromAccount,
    AccountModel? toAccount,
    int? amount,
    String? description,
  }) : super(
          {
            'fromAccount': FormControl<AccountModel>(
              value: fromAccount,
              validators: [Validators.required],
            ),
            'toAccount': FormControl<AccountModel>(
              value: toAccount,
              validators: [Validators.required],
            ),
            'amount': FormControl<int>(
              validators: [Validators.required, Validators.min(1)],
            ),
            'description': FormControl<String?>(
              value: description,
            ),
          },
          validators: [
            NotEqualValidator('fromAccount', 'toAccount'),
            AmountAccountBalanceValidator(controlName: 'fromAccount'),
          ],
        );

  FormControl<AccountModel> get fromAccount =>
      control('fromAccount') as FormControl<AccountModel>;
  FormControl<AccountModel> get toAccount =>
      control('toAccount') as FormControl<AccountModel>;
  FormControl<int> get amount => control('amount') as FormControl<int>;
  FormControl<String?> get description =>
      control('description') as FormControl<String?>;

  AccountModel get fromAccountValue {
    final value = fromAccount.value;
    if (value == null) {
      return AccountModel.placeholder(name: 'Select Pocket');
    }
    return value;
  }

  AccountModel get toAccountValue {
    final value = toAccount.value;
    if (value == null) {
      return AccountModel.placeholder(name: 'Select Pocket');
    }
    return value;
  }

  int get amountValue => amount.value ?? 0;
  String? get descriptionValue => description.value;

  Map<String, dynamic> get json {
    return {
      'sourceId': fromAccountValue.id,
      'destinationId': toAccountValue.id,
      'amount': amountValue,
      'description': descriptionValue,
    };
  }
}

final accountTransferFormProvider =
    Provider<AccountTransferForm>((ref) => AccountTransferForm());
