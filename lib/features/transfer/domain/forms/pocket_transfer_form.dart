import 'package:dompet/core/validators/amount_balance_validator.dart';
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
            AmountBalanceValidator.forPocket(controlName: 'fromPocket'),
          ],
        );

  FormControl<PocketModel> get fromPocket =>
      control('fromPocket') as FormControl<PocketModel>;
  FormControl<PocketModel> get toPocket =>
      control('toPocket') as FormControl<PocketModel>;
  FormControl<int> get amount => control('amount') as FormControl<int>;
  FormControl<String?> get description =>
      control('description') as FormControl<String?>;

  PocketModel get fromPocketValue {
    final value = fromPocket.value;
    if (value == null) {
      return PocketModel.placeholder(name: 'Select Pocket');
    }
    return value;
  }

  PocketModel get toPocketValue {
    final value = toPocket.value;
    if (value == null) {
      return PocketModel.placeholder(name: 'Select Pocket');
    }
    return value;
  }

  int get amountValue => amount.value ?? 0;
  String? get descriptionValue => description.value;

  Map<String, dynamic> get json {
    return {
      'sourceId': fromPocketValue.id,
      'destinationId': toPocketValue.id,
      'amount': amountValue,
      'description': descriptionValue,
    };
  }
}

final pocketTransferFormProvider =
    Provider<PocketTransferForm>((ref) => PocketTransferForm());
