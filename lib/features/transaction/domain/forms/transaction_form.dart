import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/validators/amount_account_balance_validator.dart';
import 'package:dompet/core/validators/amount_pocket_balance_validator.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TransactionForm extends FormGroup {
  TransactionForm()
      : super(
          {
            'date': FormControl<DateTime>(
              value: DateTime.now(),
              validators: [
                Validators.required,
              ],
            ),
            'account': FormControl<AccountModel>(
              validators: [Validators.required],
            ),
            'pocket': FormControl<PocketModel>(
              validators: [Validators.required],
            ),
            'amount': FormControl<int>(
              validators: [
                Validators.required,
                Validators.number(
                  allowNegatives: false,
                )
              ],
            ),
            'type': FormControl<TransactionType>(
              validators: [Validators.required],
            ),
            'description': FormControl<String>(),
            'category': FormControl<Category>(value: Category.others),
          },
          validators: [
            AmountPocketBalanceValidator(
              controlName: 'pocket',
              errorKey: 'exceedsPocketBalance',
            ),
            AmountAccountBalanceValidator(
              controlName: 'account',
              errorKey: 'exceedsAccountBalance',
            ),
          ],
        );

  FormControl<DateTime> get date => controls['date'] as FormControl<DateTime>;
  FormControl<AccountModel> get account =>
      controls['account'] as FormControl<AccountModel>;
  FormControl<PocketModel> get pocket =>
      controls['pocket'] as FormControl<PocketModel>;
  FormControl<int> get amount => controls['amount'] as FormControl<int>;
  FormControl<TransactionType> get type =>
      controls['type'] as FormControl<TransactionType>;
  FormControl<String> get description =>
      controls['description'] as FormControl<String>;
  FormControl<Category> get category =>
      controls['category'] as FormControl<Category>;

  DateTime? get dateValue => date.value;
  AccountModel? get accountValue => account.value;
  PocketModel? get pocketValue => pocket.value;
  int? get amountValue => amount.value;
  TransactionType? get typeValue => type.value;
  String? get descriptionValue => description.value;
  Category? get categoryValue => category.value;

  Map<String, dynamic> get json {
    return {
      'accountId': accountValue?.id,
      'pocketId': pocketValue?.id,
      'amount': amountValue,
      'description': descriptionValue,
      'date': dateValue != null
          ? (dateValue!.millisecondsSinceEpoch / 1000).toInt()
          : null,
      'type': typeValue?.value,
      'category': categoryValue?.iconKey,
    };
  }
}

final transactionFormProvider = Provider<TransactionForm>(
  (ref) => TransactionForm(),
);
