import 'dart:async';

import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/dompet_empty_search.dart';
import 'package:dompet_app/core/widgets/dompet_snackbar.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/core/widgets/loading_overlay.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/accounts/cubits/account_action_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// FIX-14 (IMP-3): list kategori arsip per tipe, mirror list aktif.
/// Geser item → tombol Pulihkan (sama pola section "Kategori Saya").
/// Entry via ikon arsip di [CategoryPage].
@RoutePage()
class CategoryArchivedPage extends StatefulWidget {
  final TransactionType type;
  const CategoryArchivedPage({super.key, required this.type});

  @override
  State<CategoryArchivedPage> createState() => _CategoryArchivedPageState();
}

class _CategoryArchivedPageState extends State<CategoryArchivedPage> {
  final _keywordControl = FormControl<String>();
  Timer? _debounce;
  final _loading = LoadingOverlay();
  final _cubit = getIt<CategoryCubit>();

  @override
  void initState() {
    super.initState();
    _keywordControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        _cubit.fetchArchived(keyword: keyword, type: widget.type);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cubit.close();
    _keywordControl.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _debounce?.cancel();
    _cubit.fetchArchived(type: widget.type);
  }

  bool get _isSearching {
    final keyword = _keywordControl.value;
    return keyword != null && keyword.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountSignalCubit, int>(
      listener: (context, state) {
        _cubit.fetchArchived(
          keyword: _keywordControl.value,
          type: widget.type,
        );
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: _cubit
              ..fetchArchived(
                type: widget.type,
                keyword: _keywordControl.value,
              ),
          ),
          BlocProvider(create: (context) => getIt<AccountActionCubit>()),
        ],
        child: BlocListener<AccountActionCubit, ActionState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () => _loading.hide(),
              error: (message) {
                _loading.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  DompetSnackbar(
                    context,
                    message: message,
                    snackBarType: .error,
                  ),
                );
              },
              loading: () => _loading.show(context, text: 'Memulihkan...'),
              success: (message) {
                _loading.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  DompetSnackbar(
                    context,
                    message: message,
                    snackBarType: .success,
                  ),
                );
              },
            );
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Kategori ${widget.type == .expense ? 'Pengeluaran' : 'Pemasukan'} Diarsipkan',
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
                      onClear: _clearSearch,
                    ),
                    Expanded(
                      child: BlocBuilder<CategoryCubit, CategoryState>(
                        bloc: _cubit,
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
                            loading: () => Padding(
                              padding: const EdgeInsets.only(top: 64),
                              child: SpinnerLoading(),
                            ),
                            refreshing: (categories) =>
                                _ArchivedList(categories: categories),
                            loaded: (categories) {
                              if (categories.isEmpty && _isSearching) {
                                return Center(
                                  child: DompetEmptySearch(
                                    subject: 'kategori',
                                    onReset: () {
                                      _keywordControl.reset();
                                      _clearSearch();
                                    },
                                  ),
                                );
                              }
                              if (categories.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Belum ada kategori yang diarsipkan.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                );
                              }
                              return _ArchivedList(categories: categories);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArchivedList extends StatelessWidget {
  final List<Account> categories;
  const _ArchivedList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Builder(
            builder: (providedContext) {
              return Slidable(
                key: ValueKey(category.id),
                startActionPane: ActionPane(
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) async {
                        await providedContext
                            .read<AccountActionCubit>()
                            .unarchiveAccount(id: category.id);
                        if (!providedContext.mounted) return;
                        providedContext.read<AccountSignalCubit>().created();
                        // TC2-BGT-001: pulihkan kategori mengubah flag
                        // categoryArchived di list anggaran aktif —
                        // segarkan list + rencana via sinyal budget.
                        providedContext.read<BudgetSignalCubit>().created();
                      },
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      icon: Icons.unarchive_rounded,
                      label: 'Pulihkan',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(category.name),
                  leading: Icon(
                    category.iconCode == null
                        ? Icons.receipt_rounded
                        : MaterialIconData.fromCode(category.iconCode!),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
