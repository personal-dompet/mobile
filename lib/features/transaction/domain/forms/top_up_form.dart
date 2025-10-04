import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TopUpForm extends FormGroup {
  TopUpForm()
      : super({
          'account': FormControl<AccountModel>(
            validators: [Validators.required],
            value: null,
          ),
          'amount': FormControl<int>(
            validators: [Validators.required, Validators.min(1)],
          ),
          'description': FormControl<String?>(),
          'date': FormControl<DateTime>(
            validators: [Validators.required],
          ),
        });

  FormControl<AccountModel> get account =>
      control('account') as FormControl<AccountModel>;
  FormControl<int> get amount => control('amount') as FormControl<int>;
  FormControl<String?> get description =>
      control('description') as FormControl<String?>;
  FormControl<DateTime> get date => control('date') as FormControl<DateTime>;

  AccountModel? get accountValue => control('account').value;
  int get amountValue => control('amount').value ?? 0;
  String? get descriptionValue => control('description').value;
  DateTime get dateValue => control('date').value ?? DateTime.now();

  Map<String, dynamic> get json {
    return {
      'accountId': accountValue?.id,
      'amount': amountValue,
      'description': descriptionValue,
      'date': (dateValue.millisecondsSinceEpoch / 1000).toInt(),
    };
  }
}

final topUpFormProvider = Provider<TopUpForm>((ref) => TopUpForm());
