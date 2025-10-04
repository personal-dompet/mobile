import 'package:dompet/core/enum/sort_order.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PocketTransferFilterForm extends FormGroup {
  PocketTransferFilterForm()
      : super({
          'page': FormControl<int>(
            value: 1,
            validators: [
              Validators.required,
              Validators.number(),
              Validators.min(1),
            ],
          ),
          'limit': FormControl<int>(
            value: 20,
            validators: [
              Validators.required,
              Validators.number(),
              Validators.max(100),
              Validators.min(5),
            ],
          ),
          'sourcePocket': FormControl<PocketModel>(),
          'destiationPocket': FormControl<PocketModel>(),
          'minAmount': FormControl<int>(
            validators: [
              Validators.required,
              Validators.number(),
            ],
          ),
          'maxAmount': FormControl<int>(
            validators: [
              Validators.required,
              Validators.number(),
            ],
          ),
          'startDate': FormControl<DateTime>(),
          'endDate': FormControl<DateTime>(),
          'search': FormControl<String>(),
          'sortBy': FormControl<PocketTransferSortBy>(
            value: PocketTransferSortBy.date,
          ),
          'sortOrder': FormControl<SortOrder>(
            value: SortOrder.desc,
          ),
        });

  FormControl<int> get page => control('page') as FormControl<int>;
  FormControl<int> get limit => control('limit') as FormControl<int>;
  FormControl<PocketModel> get sourcePocket =>
      control('sourcePocket') as FormControl<PocketModel>;
  FormControl<PocketModel> get destiationPocket =>
      control('destiationPocket') as FormControl<PocketModel>;
  FormControl<int> get minAmount => control('minAmount') as FormControl<int>;
  FormControl<int> get maxAmount => control('maxAmount') as FormControl<int>;
  FormControl<DateTime> get startDate =>
      control('startDate') as FormControl<DateTime>;
  FormControl<DateTime> get endDate =>
      control('endDate') as FormControl<DateTime>;
  FormControl<String> get search => control('search') as FormControl<String>;
  FormControl<PocketTransferSortBy> get sortBy =>
      control('sortBy') as FormControl<PocketTransferSortBy>;
  FormControl<SortOrder> get sortOrder =>
      control('sortOrder') as FormControl<SortOrder>;

  int get pageValue => page.value ?? 1;
  int get limitValue => limit.value ?? 20;
  PocketModel? get sourcePocketValue => sourcePocket.value;
  PocketModel? get destiationPocketValue => destiationPocket.value;
  int? get minAmountValue => minAmount.value;
  int? get maxAmountValue => maxAmount.value;
  DateTime? get startDateValue => startDate.value;
  DateTime? get endDateValue => endDate.value;
  String? get searchValue => search.value;
  PocketTransferSortBy get sortByValue =>
      sortBy.value ?? PocketTransferSortBy.date;
  SortOrder get sortOrderValue => sortOrder.value ?? SortOrder.desc;

  Map<String, dynamic> get json => Map.fromEntries({
        'page': pageValue,
        'limit': limitValue,
        'sourcePocketId': sourcePocketValue?.id,
        'destiationPocketId': destiationPocketValue?.id,
        'minAmount': minAmountValue,
        'maxAmount': maxAmountValue,
        'startDate': startDateValue == null
            ? null
            : (startDateValue!.millisecondsSinceEpoch / 1000).toInt(),
        'endDate': endDateValue == null
            ? null
            : (endDateValue!.millisecondsSinceEpoch / 1000).toInt(),
        'search': searchValue,
        'sortBy': sortByValue.name,
        'sortOrder': sortOrderValue.name,
      }.entries.where((entry) => entry.value != null));
}

enum PocketTransferSortBy {
  createdAt,
  amount,
  date,
}

final pocketTransferFilterFormProvider =
    Provider.autoDispose<PocketTransferFilterForm>((ref) {
  return PocketTransferFilterForm();
});
