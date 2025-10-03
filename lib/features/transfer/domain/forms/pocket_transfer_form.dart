import 'package:dompet/core/validators/amount_pocket_balance_validator.dart';
import 'package:dompet/core/validators/not_equal_validator.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PocketTransferForm extends FormGroup {
  PocketTransferForm({
    PocketModel? fromPocket,
    PocketModel? toPocket,
    int? amount,
    String? description,
  }) : super(
          {
            'fromPocket': FormControl<PocketModel>(
              value: fromPocket,
              validators: [Validators.required],
            ),
            'toPocket': FormControl<PocketModel>(
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

  FormControl<PocketModel> get fromPocketControl =>
      control('fromPocket') as FormControl<PocketModel>;
  FormControl<PocketModel> get toPocketControl =>
      control('toPocket') as FormControl<PocketModel>;
  FormControl<int> get amountControl => control('amount') as FormControl<int>;
  FormControl<String?> get descriptionControl =>
      control('description') as FormControl<String?>;

  PocketModel? get fromPocket => control('fromPocket').value;
  PocketModel? get toPocket => control('toPocket').value;
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
