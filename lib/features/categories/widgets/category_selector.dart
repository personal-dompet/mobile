import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/cubits/account_budget_status_cubit.dart';
import 'package:dompet_app/features/budgets/models/account_budget_status.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CategorySelector extends StatefulWidget {
  final FormControl<int> idControl;
  final FormControl<String> nameControl;
  final TransactionType type;
  const CategorySelector({
    super.key,
    required this.idControl,
    required this.nameControl,
    required this.type,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final _searchFormControl = FormControl<String>();
  late FormGroup _form;
  late AccountBudgetStatusCubit _accountBudgetStatusCubit;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({'keyowrd': _searchFormControl});
    _accountBudgetStatusCubit = getIt<AccountBudgetStatusCubit>()..fetch();

    _searchFormControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        context.read<CategoryCubit>().fetch(
          keyword: keyword,
          type: widget.type,
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _accountBudgetStatusCubit.close();
    _debounce?.cancel();
    _searchFormControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final selectedColor = themeData.colorScheme.primary;
    return BlocListener<AccountSignalCubit, int>(
      listener: (context, state) {
        context.read<CategoryCubit>().fetch(
          keyword: _searchFormControl.value,
          type: widget.type,
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
                  widget.idControl.updateValue(category?.id);
                  widget.nameControl.updateValue(category?.name);

                  if (!context.mounted) return;
                  context.router.maybePop();
                },
                icon: Icon(Icons.add_rounded),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 24),
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
                        return ReactiveValueListenableBuilder(
                          formControl: widget.idControl,
                          builder: (context, control, _) {
                            final accountControl = control as FormControl<int>;
                            return Expanded(
                              child: ListView.builder(
                                itemCount: expenses.length,
                                itemBuilder: (context, index) {
                                  final expense = expenses[index];
                                  return BlocBuilder<
                                    AccountBudgetStatusCubit,
                                    AccountBudgetStatusState
                                  >(
                                    bloc: _accountBudgetStatusCubit,
                                    builder: (context, status) {
                                      return status.maybeWhen(
                                        orElse: () => _ListTile(
                                          expense: expense,
                                          accountControl: accountControl,
                                          selectedColor: selectedColor,
                                          themeData: themeData,
                                          nameControl: widget.nameControl,
                                        ),
                                        loading: () => _ListTile(
                                          expense: expense,
                                          accountControl: accountControl,
                                          selectedColor: selectedColor,
                                          themeData: themeData,
                                          nameControl: widget.nameControl,
                                          isLoading: true,
                                        ),
                                        loaded: (status) => _ListTile(
                                          expense: expense,
                                          accountControl: accountControl,
                                          themeData: themeData,
                                          nameControl: widget.nameControl,
                                          status: status,
                                          selectedColor: selectedColor,
                                        ),
                                      );
                                    },
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
  final FormControl<int> accountControl;
  final Color selectedColor;
  final ThemeData themeData;
  final FormControl<String> nameControl;
  final AccountBudgetStatus? status;
  final bool isLoading;
  const _ListTile({
    required this.expense,
    required this.accountControl,
    required this.selectedColor,
    required this.themeData,
    required this.nameControl,
    this.status,
    this.isLoading = false,
  });

  Widget? subtitle() {
    if (isLoading) {
      return Text(
        'Loading...',
        style: themeData.textTheme.bodySmall?.copyWith(
          fontStyle: .italic,
          color: themeData.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      );
    }
    final hasPlan =
        status != null && status!.planAccountIds.contains(expense.id);
    final hasBudget =
        status != null && status!.activeBudgetAccountIds.contains(expense.id);

    if (!hasPlan && !hasBudget) {
      return null;
    }

    return Row(
      spacing: 8,
      children: [
        if (status!.planAccountIds.contains(expense.id))
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
        if (status!.activeBudgetAccountIds.contains(expense.id))
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
    return ListTile(
      title: Text(expense.name),
      selected: expense.id == accountControl.value,
      selectedTileColor: selectedColor.withValues(alpha: 0.1),
      leading: Icon(
        expense.iconCode == null
            ? Icons.receipt_rounded
            : MaterialIconData.fromCode(expense.iconCode!),
      ),
      trailing: expense.id == accountControl.value
          ? Icon(Icons.check_rounded, color: selectedColor)
          : null,
      subtitle: subtitle(),
      onTap: () {
        accountControl.value = expense.id;
        nameControl.value = expense.name;
        Navigator.pop(context);
      },
    );
  }
}
