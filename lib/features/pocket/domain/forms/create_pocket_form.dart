import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreatePocketForm extends FormGroup {
  CreatePocketForm()
      : super({
          'name': FormControl<String>(
            validators: [Validators.required],
          ),
          'color': FormControl<PocketColor>(),
          'icon': FormControl<Category?>(),
          'type': FormControl<PocketType>(),
        });

  FormControl<String> get name => control('name') as FormControl<String>;
  FormControl<PocketColor> get color =>
      control('color') as FormControl<PocketColor>;
  FormControl<Category?> get icon => control('icon') as FormControl<Category?>;
  FormControl<PocketType> get type =>
      control('type') as FormControl<PocketType>;

  String get nameValue => name.value ?? '';
  PocketColor? get colorValue => color.value;
  Category? get iconValue => icon.value;
  PocketType? get typeValue => type.value;

  Map<String, dynamic> get json => Map.fromEntries({
        'name': nameValue,
        'color': colorValue?.toHex(),
        'icon': iconValue?.iconKey,
        'type': typeValue?.value,
      }.entries);

  void setDefaultValue(CreatePocketForm form) {
    name.value = form.nameValue;
    color.value = form.colorValue;
    icon.value = form.iconValue;
    type.value = form.typeValue;
  }

  PocketModel toPocketModel() {
    return PocketModel.placeholder(
      color: colorValue,
      icon: iconValue,
      name: nameValue,
      type: typeValue,
    );
  }
}

final createPocketFormProvider = Provider<CreatePocketForm>((ref) {
  return CreatePocketForm();
});
