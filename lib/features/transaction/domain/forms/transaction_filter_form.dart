import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/enum/sort_order.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TransactionFilterForm extends FormGroup {
  TransactionFilterForm()
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
          'pocket': FormControl<PocketModel>(),
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
          'type': FormControl<TransactionType>(),
          'category': FormControl<Category>(),
          'search': FormControl<String>(),
          'sortBy': FormControl<TransactionSortBy>(
            value: TransactionSortBy.date,
          ),
          'sortOrder': FormControl<SortOrder>(
            value: SortOrder.desc,
          ),
        });

  FormControl<int> get page => control('page') as FormControl<int>;
  FormControl<int> get limit => control('limit') as FormControl<int>;
  FormControl<PocketModel> get pocket =>
      control('pocket') as FormControl<PocketModel>;
  FormControl<int> get minAmount => control('minAmount') as FormControl<int>;
  FormControl<int> get maxAmount => control('maxAmount') as FormControl<int>;
  FormControl<DateTime> get startDate =>
      control('startDate') as FormControl<DateTime>;
  FormControl<DateTime> get endDate =>
      control('endDate') as FormControl<DateTime>;
  FormControl<TransactionType> get type =>
      control('type') as FormControl<TransactionType>;
  FormControl<Category> get category =>
      control('category') as FormControl<Category>;
  FormControl<String> get search => control('search') as FormControl<String>;
  FormControl<TransactionSortBy> get sortBy =>
      control('sortBy') as FormControl<TransactionSortBy>;
  FormControl<SortOrder> get sortOrder =>
      control('sortOrder') as FormControl<SortOrder>;

  int get pageValue => page.value ?? 1;
  int get limitValue => limit.value ?? 20;
  PocketModel? get pocketValue => pocket.value;
  int? get minAmountValue => minAmount.value;
  int? get maxAmountValue => maxAmount.value;
  DateTime? get startDateValue => startDate.value;
  DateTime? get endDateValue => endDate.value;
  TransactionType? get typeValue => type.value;
  Category? get categoryValue => category.value;
  String? get searchValue => search.value;
  TransactionSortBy get sortByValue => sortBy.value ?? TransactionSortBy.date;
  SortOrder get sortOrderValue => sortOrder.value ?? SortOrder.desc;

  Map<String, dynamic> get json => Map.fromEntries({
        'page': pageValue,
        'limit': limitValue,
        'pocketId': pocketValue?.id,
        'minAmount': minAmountValue,
        'maxAmount': maxAmountValue,
        'startDate': startDateValue == null
            ? null
            : (startDateValue!.millisecondsSinceEpoch / 1000).toInt(),
        'endDate': endDateValue == null
            ? null
            : (endDateValue!.millisecondsSinceEpoch / 1000).toInt(),
        'type': typeValue?.value,
        'category': categoryValue?.iconKey,
        'search': searchValue,
        'sortBy': sortByValue.name,
        'sortOrder': sortOrderValue.name,
      }.entries.where((entry) => entry.value != null));
}

enum TransactionSortBy {
  createdAt,
  amount,
  date,
}
