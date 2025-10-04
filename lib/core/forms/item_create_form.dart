import 'package:dompet/core/constants/pocket_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ItemCreateForm extends FormGroup {
  ItemCreateForm({
    required FormControl<String> nameControl,
    required FormControl<PocketColor?> colorControl,
    required FormControl<dynamic> typeControl,
  }) : super({
          'name': nameControl,
          'color': colorControl,
          'type': typeControl,
        });

  FormControl<String> get name => control('name') as FormControl<String>;
  FormControl<PocketColor?> get color =>
      control('color') as FormControl<PocketColor?>;
  FormControl<dynamic> get type => control('type') as FormControl<dynamic>;

  String get nameValue => name.value ?? '';
  PocketColor? get colorValue => color.value;
  dynamic get typeValue => type.value;

  Map<String, dynamic> get json => Map.fromEntries({
        'name': nameValue,
        'color': colorValue?.toHex(),
        'type': typeValue?.value,
      }.entries);
}

final itemCreateFormProvider =
    Provider.autoDispose.family<ItemCreateForm, dynamic>(
  (ref, typeValue) => ItemCreateForm(
    nameControl: FormControl<String>(validators: [Validators.required]),
    colorControl: FormControl<PocketColor?>(),
    typeControl: FormControl<dynamic>(),
  ),
);
