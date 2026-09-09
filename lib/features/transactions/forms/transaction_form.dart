import 'package:dompet_app/core/validators/dompet_amount_validators.dart';
import 'package:dompet_app/features/assets/forms/asset_selector_form.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TransactionForm extends FormGroup {
  TransactionForm()
    : super({
        _FieldKey.asset: AssetSelectorForm(),
        _FieldKey.note: FormControl<String>(),
        _FieldKey.date: FormControl<DateTime>(value: DateTime.now()),
        _FieldKey.categories: FormArray<Map<String, dynamic>>([
          _createCategoryGroup(),
        ]),
        _FieldKey.totalAmount: FormControl<int>(value: 0),
      }) {
    _listenToTotalAmount();
  }

  AssetSelectorForm get assetForm =>
      control(_FieldKey.asset) as AssetSelectorForm;

  FormControl<String> get noteControl =>
      control(_FieldKey.note) as FormControl<String>;

  FormControl<DateTime> get dateControl =>
      control(_FieldKey.date) as FormControl<DateTime>;

  FormArray<Map<String, dynamic>> get categoriesFormArray =>
      control(_FieldKey.categories) as FormArray<Map<String, dynamic>>;

  FormControl<int> get totalAmountControl =>
      control(_FieldKey.totalAmount) as FormControl<int>;

  int? get assetId => assetForm.id;
  String? get assetName => assetForm.name;
  int? get assetBalance => assetForm.balance;

  String? get note => noteControl.value;
  DateTime? get date => dateControl.value;

  int? get totalAmount => totalAmountControl.value;

  List<TransactionCategoryForm> get categories =>
      categoriesFormArray.controls.map((control) {
        return control as TransactionCategoryForm;
      }).toList();

  List<TransactionCategoryForm> get normalizedCategories {
    return categories.fold<List<TransactionCategoryForm>>([], (
      normalized,
      category,
    ) {
      final existingIndex = normalized.indexWhere(
        (n) => n.categoryId == category.categoryId && n.note == category.note,
      );

      if (existingIndex == -1) {
        normalized.add(category);
      } else {
        final existing = normalized[existingIndex];
        existing.amountControl.updateValue(
          (existing.amount ?? 0) + (category.amount ?? 0),
        );
      }

      return normalized;
    });
  }

  static FormGroup _createCategoryGroup() {
    return TransactionCategoryForm();
  }

  void addCategory() {
    final array =
        control(_FieldKey.categories) as FormArray<Map<String, dynamic>>;
    array.add(_createCategoryGroup());
  }

  void removeCategory(int index) {
    final array =
        control(_FieldKey.categories) as FormArray<Map<String, dynamic>>;
    array.removeAt(index);
  }

  void _listenToTotalAmount() {
    categoriesFormArray.valueChanges.listen((categoriesList) {
      if (categoriesList == null) return;

      final sum = categoriesList.fold<int>(0, (previousValue, element) {
        final amountValue = element?[_FieldKey.amount] as int? ?? 0;
        return previousValue + amountValue;
      });
      totalAmountControl.updateValue(sum);
    });
  }
}

class TransactionCategoryForm extends FormGroup {
  TransactionCategoryForm()
    : super({
        _FieldKey.categoryId: FormControl<int>(),
        _FieldKey.categoryName: FormControl<String>(),
        _FieldKey.amount: FormControl<int>(
          validators: DompetAmountValidators.min1(),
        ),
        _FieldKey.note: FormControl<String>(),
      });

  FormControl<int> get categoryIdControl =>
      control(_FieldKey.categoryId) as FormControl<int>;

  FormControl<String> get categoryNameControl =>
      control(_FieldKey.categoryName) as FormControl<String>;

  FormControl<int> get amountControl =>
      control(_FieldKey.amount) as FormControl<int>;

  FormControl<String> get noteControl =>
      control(_FieldKey.note) as FormControl<String>;

  int? get categoryId => categoryIdControl.value;
  String? get categoryName => categoryNameControl.value;
  int? get amount => amountControl.value;
  String? get note => noteControl.value;
}

abstract class _FieldKey {
  static const asset = 'asset';
  static const note = 'note';
  static const date = 'date';
  static const categories = 'categories';
  static const totalAmount = 'total_amount';

  // Category
  static const categoryId = 'category_id';
  static const categoryName = 'category_name';
  static const amount = 'amount';
}
