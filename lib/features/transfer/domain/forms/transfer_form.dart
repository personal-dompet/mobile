import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TransferForm {
  final FormControl<SimplePocketModel> _fromPocketControl;
  final FormControl<SimplePocketModel> _toPocketControl;
  final FormControl<int> _amountControl;
  final FormControl<String> _descriptionControl;

  late final FormGroup _formGroup;

  TransferForm({
    SimplePocketModel? fromPocket,
    SimplePocketModel? toPocket,
    int? amount,
    String? description,
  })  : _fromPocketControl = FormControl<SimplePocketModel>(
          value: fromPocket,
          validators: [Validators.required],
        ),
        _toPocketControl = FormControl<SimplePocketModel>(
          value: toPocket,
          validators: [Validators.required],
        ),
        _amountControl = FormControl<int>(
          value: amount ?? 0,
          validators: [Validators.required, Validators.min(1)],
        ),
        _descriptionControl = FormControl<String>(
          value: description ?? '',
        ) {
    _formGroup = FormGroup({
      'fromPocket': _fromPocketControl,
      'toPocket': _toPocketControl,
      'amount': _amountControl,
      'description': _descriptionControl,
    });
  }

  FormGroup get formGroup => _formGroup;

  FormControl<SimplePocketModel> get fromPocketControl => _fromPocketControl;
  FormControl<SimplePocketModel> get toPocketControl => _toPocketControl;
  FormControl<int> get amountControl => _amountControl;
  FormControl<String> get descriptionControl => _descriptionControl;

  SimplePocketModel? get fromPocket => _fromPocketControl.value;
  SimplePocketModel? get toPocket => _toPocketControl.value;
  int? get amount => _amountControl.value;
  String? get description => _descriptionControl.value;
}