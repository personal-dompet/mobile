import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PocketCreateForm extends FormGroup {
  PocketCreateForm()
      : super({
          'name': FormControl<String>(
            validators: [Validators.required],
          ),
          'color': FormControl<PocketColor>(),
          'icon': FormControl<Category?>(),
          'type': FormControl<PocketType>(),
        });

  FormControl<String> get nameControl => control('name') as FormControl<String>;
  FormControl<PocketColor> get colorControl =>
      control('color') as FormControl<PocketColor>;
  FormControl<Category?> get iconControl =>
      control('icon') as FormControl<Category?>;
  FormControl<PocketType> get typeControl =>
      control('type') as FormControl<PocketType>;

  String get name => nameControl.value ?? '';
  PocketColor? get color => colorControl.value;
  Category? get icon => iconControl.value;
  PocketType? get type => typeControl.value;

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color?.toHex(),
        'icon': icon?.iconKey,
        'type': type?.value,
      };
}

final pocketCreateFormProvider = Provider<PocketCreateForm>((ref) {
  return PocketCreateForm();
});
