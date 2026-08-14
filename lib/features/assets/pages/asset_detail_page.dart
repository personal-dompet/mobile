import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_action_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/activities/widgets/activity_item_tile.dart';
import 'package:dompet_app/features/activities/widgets/empty_activities.dart';
import 'package:dompet_app/features/assets/cubits/asset_cubit.dart';
import 'package:dompet_app/features/assets/cubits/asset_detail_cubit.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/models/asset_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AssetDetailPage extends StatefulWidget {
  final int id;
  const AssetDetailPage({super.key, required this.id});

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  final _loading = LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<AssetDetailCubit>()..init(id: widget.id),
      child: Builder(
        builder: (providedContext) {
          return BlocListener<AccountSignalCubit, int>(
            listener: (context, state) {
              providedContext.read<AssetDetailCubit>().init(id: widget.id);
            },
            child: BlocBuilder<AssetDetailCubit, AssetDetailState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => SizedBox.shrink(),
                  error: (message) => _DetailContent(
                    id: widget.id,
                    child: Center(
                      child: Text(
                        message,
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          color: themeData.colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                  loading: () => _DetailContent(
                    id: widget.id,
                    child: Center(
                      child: SpinnerLoading(text: 'Memuat dompet...'),
                    ),
                  ),
                  loaded: (accountDetail) {
                    return BlocProvider(
                      create: (context) => getIt<AccountActionCubit>(),
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
                            loading: () => _loading.show(
                              context,
                              text: 'Mengarsip dompet...',
                            ),
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
                        child: Builder(
                          builder: (actionContext) {
                            final isDeleted = accountDetail.account.isDeleted;
                            return _DetailContent(
                              id: widget.id,
                              detail: accountDetail,
                              onEdit: () {
                                final form = AssetForm();
                                final codes = accountDetail.account.code.split(
                                  '.',
                                );
                                codes.removeLast();
                                form.nameControl.updateValue(
                                  accountDetail.account.name,
                                );
                                form.codeControl.updateValue(codes.join('.'));
                                context.router.push(
                                  AssetFormRoute(
                                    id: accountDetail.account.id,
                                    form: form,
                                  ),
                                );
                              },
                              onArchive: () async {
                                final assetAccountCubit = getIt<AssetCubit>();
                                await assetAccountCubit.fetch();

                                final assets = assetAccountCubit.state
                                    .maybeWhen(
                                      orElse: () => <Account>[],
                                      loaded: (assets) => assets,
                                    );

                                if (!context.mounted) return;

                                if (assets.length == 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    DompetSnackbar(
                                      context,
                                      message:
                                          'Proses arsip dibatalkan. Setidaknya harus ada satu Dompet aktif.',
                                      snackBarType: .error,
                                    ),
                                  );
                                  return;
                                }

                                final isConfirmed = await showDialog<bool>(
                                  context: context,
                                  useRootNavigator: false,
                                  builder: (context) {
                                    return DompetDialog(
                                      title:
                                          'Arsipkan ${accountDetail.account.name}?',
                                      subtitle:
                                          'Dompet ini tidak akan muncul di daftar aktif dan saldonya tidak lagi dihitung dalam Total Uang. Aktivitas dan riwayatnya tetap tersimpan dan bisa dilihat kapan saja.',
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
                                    !actionContext.mounted) {
                                  return;
                                }
                                await actionContext
                                    .read<AccountActionCubit>()
                                    .archiveAccount(id: widget.id);
                                if (!actionContext.mounted) return;
                                actionContext
                                    .read<AccountSignalCubit>()
                                    .created();
                              },
                              onRecover: () async {
                                await actionContext
                                    .read<AccountActionCubit>()
                                    .unarchiveAccount(id: widget.id);
                                if (!actionContext.mounted) return;
                                actionContext
                                    .read<AccountSignalCubit>()
                                    .created();
                              },
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(
                                  16,
                                ).copyWith(bottom: 24, top: isDeleted ? 0 : 16),
                                child: Column(
                                  crossAxisAlignment: .stretch,
                                  children: [
                                    if (isDeleted) ...[
                                      Row(
                                        mainAxisAlignment: .start,
                                        children: [
                                          Chip(
                                            label: Text('Diarsipkan'),
                                            avatar: Icon(
                                              Icons.archive_rounded,
                                              color: themeData
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                            visualDensity: .compact,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 24),
                                    ],
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 24,
                                        ),
                                        child: Column(
                                          mainAxisSize: .min,
                                          children: [
                                            Text(
                                              accountDetail
                                                  .account
                                                  .balance
                                                  .currency,
                                              style: themeData
                                                  .textTheme
                                                  .displaySmall
                                                  ?.copyWith(
                                                    fontWeight: .w600,
                                                    color: themeData
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                            ),

                                            if (!accountDetail
                                                .account
                                                .isDeleted) ...[
                                              SizedBox(height: 16),
                                              OutlinedButton.icon(
                                                onPressed: () {
                                                  context.router.push(
                                                    BalanceAdjustmentRoute(
                                                      account:
                                                          accountDetail.account,
                                                    ),
                                                  );
                                                },
                                                label: Text('Sesuaikan saldo'),
                                                icon: Icon(Icons.edit_rounded),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 36),
                                    Column(
                                      crossAxisAlignment: .stretch,
                                      spacing: 8,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Aktivitas Terbaru',
                                                style: themeData
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      fontWeight: .w700,
                                                    ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context.router.push(
                                                  AssetActivityRoute(
                                                    account:
                                                        accountDetail.account,
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                spacing: 2,
                                                children: [
                                                  Text(
                                                    'Lihat Semua',
                                                    style: themeData
                                                        .textTheme
                                                        .labelLarge
                                                        ?.copyWith(
                                                          color: themeData
                                                              .colorScheme
                                                              .primary,
                                                        ),
                                                  ),
                                                  Icon(
                                                    Icons.chevron_right_rounded,
                                                    color: themeData
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (accountDetail
                                            .recentActivities
                                            .isEmpty)
                                          EmptyActivities(
                                            emptyText:
                                                'Mulai dengan mencatat pemasukan atau pengeluaran pertamamu pada Dompet ${accountDetail.account.name}.',
                                            selectedAccount:
                                                accountDetail.account,
                                          )
                                        else
                                          Column(
                                            mainAxisSize: .min,
                                            spacing: 12,
                                            children: List.generate(
                                              accountDetail
                                                  .recentActivities
                                                  .length,
                                              (index) {
                                                final activity = accountDetail
                                                    .recentActivities[index];
                                                return ActivityItemTile(
                                                  activity: activity,
                                                  accountId:
                                                      accountDetail.account.id,
                                                );
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final int id;
  final Widget child;
  final AssetDetail? detail;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onRecover;
  const _DetailContent({
    required this.id,
    required this.child,
    this.detail,
    this.onEdit,
    this.onArchive,
    this.onRecover,
  });

  bool get _isDeleted => detail?.account.isDeleted ?? false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return BlocListener<ActivitySignalCubit, int>(
      listener: (context, state) {
        context.read<AssetDetailCubit>().init(id: id);
      },
      child: Scaffold(
        appBar: AppBar(
          title: detail == null
              ? Text('Detail Dompet')
              : Text('Dompet ${detail!.account.name}'),
          actions: [
            MenuAnchor(
              menuChildren: _isDeleted
                  ? [
                      MenuItemButton(
                        onPressed: onRecover,
                        child: Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.unarchive_rounded),
                            Text('Pulihkan'),
                          ],
                        ),
                      ),
                    ]
                  : [
                      MenuItemButton(
                        onPressed: onEdit,
                        child: Row(
                          spacing: 4,
                          children: [Icon(Icons.edit_rounded), Text('Ubah')],
                        ),
                      ),
                      MenuItemButton(
                        onPressed: onArchive,
                        child: Row(
                          spacing: 4,
                          children: [
                            Icon(
                              Icons.archive_rounded,
                              color: themeData.colorScheme.error,
                            ),
                            Text(
                              'Arsipkan',
                              style: TextStyle(
                                color: themeData.colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
              builder:
                  (
                    BuildContext context,
                    MenuController controller,
                    Widget? child,
                  ) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                          return;
                        }
                        controller.open();
                      },
                      icon: Icon(Icons.more_vert_rounded),
                    );
                  },
            ),
          ],
        ),
        floatingActionButton: detail != null && !_isDeleted
            ? DompetFab(selectedAccount: detail!.account)
            : null,
        body: SafeArea(child: child),
      ),
    );
  }
}
