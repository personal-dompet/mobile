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

  FormControl<AccountModel> get accountControl =>
      control('account') as FormControl<AccountModel>;
  FormControl<int> get amountControl => control('amount') as FormControl<int>;
  FormControl<String?> get descriptionControl =>
      control('description') as FormControl<String?>;
  FormControl<DateTime> get dateControl =>
      control('date') as FormControl<DateTime>;

  AccountModel? get account => control('account').value;
  int get amount => control('amount').value ?? 0;
  String? get description => control('description').value;
  DateTime get date => control('date').value ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'accountId': account?.id,
      'amount': amount,
      'description': description,
      'date': (date.millisecondsSinceEpoch / 1000).toInt(),
    };
  }
}

final topUpFormProvider = Provider<TopUpForm>((ref) => TopUpForm());
