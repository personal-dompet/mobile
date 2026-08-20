import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/cubits/account_budget_status_cubit.dart';
import 'package:dompet_app/features/budgets/models/account_budget_status.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class CategorySelectorPage extends StatefulWidget {
  final TransactionType type;
  final bool showBudgetStatus;
  const CategorySelectorPage({
    super.key,
    required this.type,
    this.showBudgetStatus = false,
  });

  @override
  State<CategorySelectorPage> createState() => _CategorySelectorPageState();
}

class _CategorySelectorPageState extends State<CategorySelectorPage> {
  final _keywordControl = FormControl<String>();

  Timer? _debounce;

  final _categoryAccountCubit = getIt<CategoryCubit>();

  AccountBudgetStatusCubit? _statusCubit;

  @override
  void initState() {
    super.initState();
    _keywordControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        _categoryAccountCubit.fetch(keyword: keyword, type: widget.type);
      });
    });

    if (widget.showBudgetStatus) {
      _statusCubit = getIt<AccountBudgetStatusCubit>()..fetch();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _categoryAccountCubit.close();
    _statusCubit?.close();
    _keywordControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _categoryAccountCubit
        ..fetch(type: widget.type, keyword: _keywordControl.value),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pilih Kategori ${widget.type == .expense ? 'Pengeluaran' : 'Pemasukan'}',
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 24),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                DompetTextField(
                  placeholder: 'Cari nama kategori...',
                  formControl: _keywordControl,
                  textInputAction: .search,
                  clearable: true,
                ),
                Expanded(child: _buildStatusGate()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusGate() {
    final statusCubit = _statusCubit;
    if (!widget.showBudgetStatus || statusCubit == null) {
      return _buildCategoryList(status: null);
    }

    return BlocBuilder<AccountBudgetStatusCubit, AccountBudgetStatusState>(
      bloc: statusCubit,
      builder: (context, state) {
        return state.when(
          initial: () => _buildCategoryList(status: null),
          loading: () {
            return Padding(
              padding: const EdgeInsets.only(top: 64),
              child: SpinnerLoading(),
            );
          },
          loaded: (status) => _buildCategoryList(status: status),
          error: (_) => _buildCategoryList(status: null),
        );
      },
    );
  }

  Widget _buildCategoryList({required AccountBudgetStatus? status}) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      bloc: _categoryAccountCubit,
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => SizedBox.shrink(),
          error: (message) => Center(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: .center,
            ),
          ),
          loading: () {
            return Padding(
              padding: const EdgeInsets.only(top: 64),
              child: SpinnerLoading(),
            );
          },
          loaded: (categories) => _categoryList(categories, status),
          refreshing: (categories) => _categoryList(categories, status),
        );
      },
    );
  }

  Widget _categoryList(List<Account> categories, AccountBudgetStatus? status) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryListTile(
          category: category,
          hasActiveBudget:
              status?.activeBudgetAccountIds.contains(category.id) == true,
          hasPlan: status?.planAccountIds.contains(category.id) == true,
          onTap: () {
            debugPrint('Selected category: ${category.name}');
            Navigator.of(context).pop<Account>(category);
          },
        );
      },
    );
  }
}

class _CategoryListTile extends StatelessWidget {
  final Account category;
  final bool hasActiveBudget;
  final bool hasPlan;
  final VoidCallback onTap;
  const _CategoryListTile({
    required this.category,
    required this.hasActiveBudget,
    required this.hasPlan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ListTile(
      title: Text(category.name),
      leading: Icon(
        category.iconCode == null
            ? Icons.receipt_rounded
            : MaterialIconData.fromCode(category.iconCode!),
      ),
      subtitle: hasActiveBudget || hasPlan
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                spacing: 6,
                children: [
                  if (hasActiveBudget)
                    _StatusPill(
                      label: 'Anggaran aktif',
                      color: themeData.colorScheme.primary,
                    ),
                  if (hasPlan)
                    _StatusPill(
                      label: 'Ada rencana',
                      color: themeData.colorScheme.tertiary,
                    ),
                ],
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}