import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PocketFilterForm extends FormGroup {
  PocketFilterForm()
      : super({
          'keyword': FormControl<String>(),
          'type': FormControl<PocketType>(value: PocketType.all),
        });

  FormControl<String> get keyword => control('keyword') as FormControl<String>;
  FormControl<PocketType> get type =>
      control('type') as FormControl<PocketType>;

  String? get keywordValue => keyword.value;
  PocketType? get typeValue => type.value;

  Map<String, dynamic> toJson() {
    return Map.fromEntries(
      {
        'keyword': keywordValue,
        'type': typeValue == null || typeValue == PocketType.all
            ? null
            : typeValue!.value,
      }.entries.where((entry) => entry.value != null),
    );
  }
}

final pocketFilterFormProvider =
    Provider.autoDispose<PocketFilterForm>((ref) => PocketFilterForm());
