import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/constants/category_icon_options.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/models/app_configuration.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:dompet_app/core/widgets/dompet_snackbar.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/core/widgets/loading_overlay.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/accounts/cubits/account_action_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/app_configurations/cubits/app_configuration_cubit.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class CategoryPage extends StatefulWidget {
  final TransactionType type;
  const CategoryPage({super.key, required this.type});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _keywordControl = FormControl<String>();

  Timer? _debounce;

  final _loading = LoadingOverlay();

  final _categoryAccountCubit = getIt<CategoryCubit>();

  @override
  void initState() {
    super.initState();
    _keywordControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        _categoryAccountCubit.fetch(keyword: keyword, type: widget.type);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _categoryAccountCubit.close();
    _keywordControl.dispose();
    super.dispose();
  }

  Future<void> _createCategory() async {
    final form = CategoryForm();
    form.typeControl.updateValue(widget.type == .expense ? .expense : .income);
    await context.router.push<Account?>(CategoryFormRoute(form: form));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountSignalCubit, int>(
      listener: (context, state) {
        _categoryAccountCubit.refresh();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: _categoryAccountCubit
              ..fetch(type: widget.type, keyword: _keywordControl.value),
          ),
          BlocProvider(create: (context) => getIt<AccountActionCubit>()),
        ],
        child: BlocListener<AccountActionCubit, ActionState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {
                _loading.hide();
              },
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
              loading: () =>
                  _loading.show(context, text: 'Menambah kategori...'),
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
                'Kategori ${widget.type == .expense ? 'Pengeluaran' : 'Pemasukan'}',
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    onPressed: _createCategory,
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
                    DompetTextField(
                      placeholder: 'Cari nama kategori...',
                      formControl: _keywordControl,
                      textInputAction: .search,
                      clearable: true,
                    ),
                    Expanded(
                      child: BlocBuilder<CategoryCubit, CategoryState>(
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
                            loaded: (categories) {
                              return _CategoryList(
                                categories: categories,
                                onCreate: _createCategory,
                                type: widget.type,
                              );
                            },
                            refreshing: (categories) {
                              return _CategoryList(
                                categories: categories,
                                onCreate: _createCategory,
                                type: widget.type,
                              );
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

class _CategoryList extends StatelessWidget {
  final List<Account> categories;
  final TransactionType type;
  final VoidCallback onCreate;
  const _CategoryList({
    required this.categories,
    required this.type,
    required this.onCreate,
  });

  List<Account> get systemCategories =>
      categories.where((category) => category.isSystem).toList();
  List<Account> get userCategories =>
      categories.where((category) => !category.isSystem).toList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppConfigurationCubit, AppConfiguration?>(
      builder: (context, state) {
        if (state == null) return SizedBox.shrink();
        final config = state;
        final isCategoryHintClosed = config.hint.categorySwipeHint;

        return SlidableAutoCloseBehavior(
          child: CustomScrollView(
            slivers: [
              if (userCategories.isNotEmpty && !isCategoryHintClosed) ...[
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.info_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Expanded(
                              child: Text(
                                'Geser kategori buatanmu untuk melihat opsi lainnya.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: .end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                              ),
                              onPressed: () {
                                context.read<AppConfigurationCubit>().update(
                                  config.copyWith(
                                    hint: config.hint.copyWith(
                                      categorySwipeHint: true,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Oke'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12)),
              ],
              SliverToBoxAdapter(
                child: Text(
                  'Kategori Saya',
                  style: TextStyle(fontWeight: .w600),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 8)),
              if (userCategories.isEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Belum ada kategori baru.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      Text(
                        'Buat kategori baru yang sesuai dengan kebutuhan.',
                        textAlign: .start,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextButton(
                        onPressed: onCreate,
                        child: Row(
                          spacing: 4,
                          mainAxisSize: .min,
                          children: [
                            Text('Tambah Kategori'),
                            Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                SliverList.builder(
                  itemCount: userCategories.length,
                  itemBuilder: (context, index) {
                    final category = userCategories[index];
                    return Builder(
                      builder: (providedContext) {
                        return Slidable(
                          key: ValueKey(category),
                          startActionPane: ActionPane(
                            motion:
                                const BehindMotion(), // or BehindMotion, ScrollMotion, StretchMotion
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  final form = CategoryForm();
                                  form.typeControl.updateValue(
                                    type == .expense ? .expense : .income,
                                  );
                                  form.iconControl.updateValue(
                                    categoryIconOptionFromCode(
                                      iconCode: category.iconCode,
                                    ),
                                  );
                                  form.nameControl.updateValue(category.name);
                                  context.router.push<Account?>(
                                    CategoryFormRoute(
                                      form: form,
                                      id: category.id,
                                    ),
                                  );
                                },
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15),
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                icon: Icons.edit,
                                label: 'Ubah',
                              ),
                              SlidableAction(
                                onPressed: (_) async {
                                  final isConfirmed = await showDialog<bool>(
                                    context: providedContext,
                                    useRootNavigator: false,
                                    builder: (context) {
                                      return DompetDialog(
                                        title: 'Arsipkan ${category.name}?',
                                        subtitle:
                                            'Kategori ini tidak akan muncul di daftar kategori. Aktivitas dan riwayatnya tetap tersimpan dan bisa dilihat kapan saja.',
                                        onCancel: () {
                                          Navigator.pop(context, false);
                                        },
                                        onConfirm: () {
                                          Navigator.pop(context, true);
                                        },
                                        confirmationText: 'Arsipkan',
                                      );
                                    },
                                  );
                                  if (isConfirmed != true ||
                                      !providedContext.mounted) {
                                    return;
                                  }
                                  await providedContext
                                      .read<AccountActionCubit>()
                                      .archiveAccount(id: category.id);
                                  if (!providedContext.mounted) {
                                    return;
                                  }
                                  providedContext
                                      .read<AccountSignalCubit>()
                                      .created();
                                },
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error.withValues(alpha: 0.15),
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                icon: Icons.archive_rounded,
                                label: 'Arsip',
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(category.name),
                            leading: Icon(
                              category.iconCode == null
                                  ? Icons.receipt_rounded
                                  : MaterialIconData.fromCode(
                                      category.iconCode!,
                                    ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: Text(
                  'Kategori Bawaan',
                  style: TextStyle(fontWeight: .w600),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverList.builder(
                itemCount: systemCategories.length,
                itemBuilder: (context, index) {
                  final category = systemCategories[index];
                  return ListTile(
                    title: Text(category.name),
                    leading: Icon(
                      category.iconCode == null
                          ? Icons.receipt_rounded
                          : MaterialIconData.fromCode(category.iconCode!),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
