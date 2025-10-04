import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ItemListFilterForm<T> extends FormGroup {
  ItemListFilterForm({
    required FormControl<String> keywordControl,
    required FormControl<T?> typeControl,
  }) : super({
          'keyword': keywordControl,
          'type': typeControl,
        });

  FormControl<String> get keyword => control('keyword') as FormControl<String>;
  FormControl<T?> get type => control('type') as FormControl<T?>;

  String? get keywordValue => keyword.value;
  T? get typeValue => type.value;

  Map<String, dynamic> get json {
    return Map.fromEntries(
      {
        'keyword': keywordValue,
        'type': typeValue,
      }.entries.where((entry) => entry.value != null),
    );
  }
}

final itemListFilterFormProvider =
    Provider.autoDispose.family<ItemListFilterForm, dynamic>(
  (ref, typeAllValue) => ItemListFilterForm(
    keywordControl: FormControl<String>(),
    typeControl: FormControl<dynamic>(value: typeAllValue),
  ),
);
