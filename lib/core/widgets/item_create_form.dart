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

  FormControl<String> get nameControl => control('name') as FormControl<String>;
  FormControl<PocketColor?> get colorControl => control('color') as FormControl<PocketColor?>;
  FormControl<dynamic> get typeControl => control('type') as FormControl<dynamic>;

  String get name => nameControl.value ?? '';
  PocketColor? get color => colorControl.value;
  dynamic get type => typeControl.value;

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color?.toHex(),
        'type': type?.value,
      };
}

final itemCreateFormProvider = Provider.autoDispose.family<ItemCreateForm, dynamic>(
  (ref, typeValue) => ItemCreateForm(
    nameControl: FormControl<String>(validators: [Validators.required]),
    colorControl: FormControl<PocketColor?>(),
    typeControl: FormControl<dynamic>(),
  ),
);