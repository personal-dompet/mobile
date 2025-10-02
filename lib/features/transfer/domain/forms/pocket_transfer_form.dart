import 'package:dompet/core/validators/amount_pocket_balance_validator.dart';
import 'package:dompet/core/validators/not_equal_validator.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PocketTransferForm extends FormGroup {
  PocketTransferForm({
    SimplePocketModel? fromPocket,
    SimplePocketModel? toPocket,
    int? amount,
    String? description,
  }) : super(
          {
            'fromPocket': FormControl<SimplePocketModel>(
              value: fromPocket,
              validators: [Validators.required],
            ),
            'toPocket': FormControl<SimplePocketModel>(
              value: toPocket,
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
            NotEqualValidator('fromPocket', 'toPocket'),
            AmountPocketBalanceValidator(),
          ],
        );

  FormControl<SimplePocketModel> get fromPocketControl =>
      control('fromPocket') as FormControl<SimplePocketModel>;
  FormControl<SimplePocketModel> get toPocketControl =>
      control('toPocket') as FormControl<SimplePocketModel>;
  FormControl<int> get amountControl => control('amount') as FormControl<int>;
  FormControl<String?> get descriptionControl =>
      control('description') as FormControl<String?>;

  SimplePocketModel? get fromPocket => control('fromPocket').value;
  SimplePocketModel? get toPocket => control('toPocket').value;
  int get amount => control('amount').value ?? 0;
  String? get description => control('description').value;

  Map<String, dynamic> toJson() {
    return {
      'sourcePocketId': fromPocket?.id,
      'destinationPocketId': toPocket?.id,
      'amount': amount,
      'description': description,
    };
  }
}

final pocketTransferFormProvider =
    Provider<PocketTransferForm>((ref) => PocketTransferForm());
