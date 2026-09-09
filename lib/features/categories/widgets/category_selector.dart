import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CategorySelector extends StatefulWidget {
  final TransactionType type;
  final int? selectedId;
  final bool withBudget;
  const CategorySelector({
    super.key,
    required this.type,
    this.selectedId,
    this.withBudget = false,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final _searchFormControl = FormControl<String>();
  late FormGroup _form;
  final ValueNotifier<int> _selectedIdNotifier = ValueNotifier<int>(0);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _form = FormGroup({'keyowrd': _searchFormControl});
    _selectedIdNotifier.value = widget.selectedId ?? 0;
    _searchFormControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        context.read<CategoryCubit>().fetch(
          keyword: keyword,
          type: widget.type,
          withBudget: widget.withBudget,
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    _searchFormControl.dispose();
  }

  // FIX-13: clear reset field + fetch ulang eksplisit tanpa keyword (Q13 A).
  void _clearSearch() {
    _debounce?.cancel();
    context.read<CategoryCubit>().fetch(
      type: widget.type,
      withBudget: widget.withBudget,
    );
  }

  bool get _isSearching {
    final keyword = _searchFormControl.value;
    return keyword != null && keyword.isNotEmpty;
  }

  void _onSelect(BuildContext context, {required Account account}) {
    context.router.maybePop((
      account: account,
      hasPlan: account.activeBudgetPlanCount > 0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocListener<AccountSignalCubit, int>(
      listener: (context, state) {
        context.read<CategoryCubit>().fetch(
          keyword: _searchFormControl.value,
          type: widget.type,
          withBudget: widget.withBudget,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pilih Kategori'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                onPressed: () async {
                  final form = CategoryForm();
                  form.typeControl.updateValue(
                    widget.type == .expense ? .expense : .income,
                  );
                  final category = await context.router.push<Account?>(
                    CategoryFormRoute(form: form),
                  );

                  if (!context.mounted || category == null) return;
                  _onSelect(context, account: category);
                },
                icon: Icon(Icons.add_rounded),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                ReactiveForm(
                  formGroup: _form,
                  child: DompetTextField(
                    placeholder: 'Cari nama kategori...',
                    formControl: _searchFormControl,
                    textInputAction: .search,
                    clearable: true,
                    onClear: _clearSearch,
                  ),
                ),
                BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => SizedBox.shrink(),
                      loading: () {
                        return Padding(
                          padding: const EdgeInsets.only(top: 64),
                          child: SpinnerLoading(),
                        );
                      },
                      loaded: (expenses) {
                        // FIX-13: hasil kosong saat mencari tampilkan empty
                        // state + reset, bukan list blank (Q14 A).
                        if (expenses.isEmpty && _isSearching) {
                          return Expanded(
                            child: Center(
                              child: DompetEmptySearch(
                                subject: 'kategori',
                                onReset: () {
                                  _searchFormControl.reset();
                                  _clearSearch();
                                },
                              ),
                            ),
                          );
                        }
                        return ValueListenableBuilder(
                          valueListenable: _selectedIdNotifier,
                          builder: (context, selectedId, _) {
                            return Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 24),
                                itemCount: expenses.length,
                                itemBuilder: (context, index) {
                                  final expense = expenses[index];
                                  return SizedBox(
                                    key: ValueKey(expense.id),
                                    child: _ListTile(
                                      expense: expense,
                                      selectedId: selectedId,
                                      onTap: () {
                                        _onSelect(context, account: expense);
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      error: (message) => Text(
                        message,
                        style: TextStyle(color: themeData.colorScheme.error),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final Account expense;
  final int selectedId;
  final VoidCallback onTap;
  const _ListTile({
    required this.expense,
    required this.onTap,
    required this.selectedId,
  });

  bool get _hasPlan => expense.activeBudgetPlanCount > 0;

  Widget? _subtitle(BuildContext context) {
    final themeData = Theme.of(context);

    final hasBudget = expense.activeBudgetCount > 0;

    if (!_hasPlan && !hasBudget) {
      return null;
    }

    return Row(
      spacing: 8,
      children: [
        if (_hasPlan)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: themeData.colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Text(
              'Terencana',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.primary,
              ),
            ),
          ),
        if (hasBudget)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: themeData.colorScheme.tertiary.withValues(alpha: 0.1),
            ),
            child: Text(
              'Anggaran Aktif',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.tertiary,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: expense.id == selectedId
            ? selectedColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          title: Text(expense.name),
          leading: Icon(
            expense.iconCode == null
                ? Icons.receipt_rounded
                : MaterialIconData.fromCode(expense.iconCode!),
          ),
          trailing: expense.id == selectedId
              ? Icon(Icons.check_rounded, color: selectedColor)
              : null,
          subtitle: _subtitle(context),
          onTap: onTap,
        ),
      ),
    );
  }
}
