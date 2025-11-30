import 'package:dompet/core/enum/sort_order.dart';
import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TransferFilterForm<T extends FinancialEntityModel> extends FormGroup {
  TransferFilterForm()
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
          'source': FormControl<T>(),
          'destiation': FormControl<T>(),
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
          'sortBy': FormControl<TransferSortBy>(
            value: TransferSortBy.date,
          ),
          'sortOrder': FormControl<SortOrder>(
            value: SortOrder.desc,
          ),
        });

  FormControl<int> get page => control('page') as FormControl<int>;
  FormControl<int> get limit => control('limit') as FormControl<int>;
  FormControl<T> get source => control('source') as FormControl<T>;
  FormControl<T> get destiation => control('destiation') as FormControl<T>;
  FormControl<int> get minAmount => control('minAmount') as FormControl<int>;
  FormControl<int> get maxAmount => control('maxAmount') as FormControl<int>;
  FormControl<DateTime> get startDate =>
      control('startDate') as FormControl<DateTime>;
  FormControl<DateTime> get endDate =>
      control('endDate') as FormControl<DateTime>;
  FormControl<String> get search => control('search') as FormControl<String>;
  FormControl<TransferSortBy> get sortBy =>
      control('sortBy') as FormControl<TransferSortBy>;
  FormControl<SortOrder> get sortOrder =>
      control('sortOrder') as FormControl<SortOrder>;

  int get pageValue => page.value ?? 1;
  int get limitValue => limit.value ?? 20;
  T? get sourceValue => source.value;
  T? get destiationValue => destiation.value;
  int? get minAmountValue => minAmount.value;
  int? get maxAmountValue => maxAmount.value;
  DateTime? get startDateValue => startDate.value;
  DateTime? get endDateValue => endDate.value;
  String? get searchValue => search.value;
  TransferSortBy get sortByValue => sortBy.value ?? TransferSortBy.date;
  SortOrder get sortOrderValue => sortOrder.value ?? SortOrder.desc;

  Map<String, dynamic> get json => Map.fromEntries({
        'page': pageValue,
        'limit': limitValue,
        'sourceId': sourceValue?.id,
        'destiationId': destiationValue?.id,
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

enum TransferSortBy {
  createdAt,
  amount,
  date,
}

final pocketTransferFilterFormProvider =
    Provider.autoDispose<TransferFilterForm>((ref) {
  return TransferFilterForm<PocketModel>();
});

final accountTransferFilterFormProvider =
    Provider.autoDispose<TransferFilterForm>((ref) {
  return TransferFilterForm<AccountModel>();
});
