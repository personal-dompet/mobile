import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/constants/category_icon_options.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/models/app_configuration.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:dompet_app/features/accounts/cubits/account_action_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/app_configurations/cubits/app_configuration_cubit.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryGroupedList extends StatelessWidget {
  final List<Account> categories;
  final TransactionType type;
  final VoidCallback onCreate;
  const CategoryGroupedList({
    super.key,
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
