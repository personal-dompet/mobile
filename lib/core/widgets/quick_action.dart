import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/core/utils/open_add_account_bottom_sheet.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_action_cubit.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/assets/cubits/asset_cubit.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickAction extends StatefulWidget {
  final BuildContext parentContext;
  final Color? backgroundColor;
  final Account? selectedAccount;
  final VoidCallback? onBeforeAction;

  const QuickAction(
    this.parentContext, {
    super.key,
    this.selectedAccount,
    this.backgroundColor,
    this.onBeforeAction,
  });

  @override
  State<QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<QuickAction> {
  late AssetCubit _assetAccountCubit;
  late AssetCubit _presetAssetCubit;

  @override
  void initState() {
    super.initState();
    _assetAccountCubit = getIt<AssetCubit>()..fetch();
    _presetAssetCubit = getIt<AssetCubit>()..getPresetAssets();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
      spacing: 8,
      children: [
        _QuickAction(
          onTap: () async {
            widget.onBeforeAction?.call();
            final form = widget.selectedAccount != null
                ? TransactionForm()
                : null;

            if (form != null) {
              form.assetForm.idControl.updateValue(widget.selectedAccount!.id);
              form.assetForm.nameControl.updateValue(
                widget.selectedAccount!.name,
              );
              form.assetForm.balanceControl.updateValue(
                widget.selectedAccount!.balance,
              );
            }

            await TransactionRoute(
              type: .expense,
              form: form,
            ).push<bool>(context);
          },
          label: 'Pengeluaran',
          icon: Icons.trending_down_rounded,
          color: themeData.colorScheme.error,
          backgroundColor: widget.backgroundColor,
        ),
        _QuickAction(
          onTap: () async {
            widget.onBeforeAction?.call();
            final form = widget.selectedAccount != null
                ? TransactionForm()
                : null;

            if (form != null) {
              form.assetForm.idControl.updateValue(widget.selectedAccount!.id);
              form.assetForm.nameControl.updateValue(
                widget.selectedAccount!.name,
              );
              form.assetForm.balanceControl.updateValue(
                widget.selectedAccount!.balance,
              );
            }
            await TransactionRoute(
              type: .income,
              form: form,
            ).push<bool>(context);
          },
          label: 'Pemasukan',
          icon: Icons.trending_up_rounded,
          color: themeData.colorScheme.tertiary,
          backgroundColor: widget.backgroundColor,
        ),
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _assetAccountCubit),
            BlocProvider.value(value: _presetAssetCubit),
          ],
          child: BlocListener<AccountSignalCubit, int>(
            listener: (_, _) {
              _assetAccountCubit.fetch();
            },
            child: BlocBuilder<AssetCubit, AssetState>(
              bloc: _assetAccountCubit,
              builder: (context, state) {
                final disabled = state.maybeWhen(
                  orElse: () => true,
                  loaded: (assets) {
                    return assets.length < 2;
                  },
                );
                return BlocBuilder<AssetCubit, AssetState>(
                  bloc: _presetAssetCubit,
                  builder: (context, presetState) {
                    final presetDisabled = presetState.maybeWhen(
                      orElse: () => true,
                      loaded: (_) => false,
                    );
                    final presetAccounts = presetState.maybeWhen(
                      orElse: () => null,
                      loaded: (assets) => assets,
                    );
                    return _QuickAction(
                      onTap: disabled || presetDisabled
                          ? () {
                              widget.onBeforeAction?.call();
                              ScaffoldMessenger.of(context).showSnackBar(
                                DompetSnackbar(
                                  context,
                                  message:
                                      'Butuh minimal 2 dompet untuk membuka fitur pindah dana.',
                                  snackBarType: .info,
                                  action: SnackBarAction(
                                    label: 'Buat Dompet Baru',
                                    onPressed: () async {
                                      ScaffoldMessenger.of(
                                        widget.parentContext,
                                      ).hideCurrentSnackBar();
                                      final result =
                                          await openAddAccountBottomSheet(
                                            widget.parentContext,
                                            presetAccounts: presetAccounts,
                                          );

                                      if (result == null ||
                                          !widget.parentContext.mounted) {
                                        return;
                                      }

                                      final createAccountCubit =
                                          getIt<AccountActionCubit>();

                                      final loading = LoadingOverlay();

                                      createAccountCubit.stream.listen((state) {
                                        state.maybeWhen(
                                          orElse: () => loading.hide(),
                                          loading: () => loading.show(
                                            widget.parentContext,
                                          ),
                                        );
                                      });

                                      await getIt<AccountActionCubit>()
                                          .createAsset(result);
                                      if (!widget.parentContext.mounted) {
                                        return;
                                      }
                                      widget.parentContext
                                          .read<AccountSignalCubit>()
                                          .created();

                                      ScaffoldMessenger.of(
                                        widget.parentContext,
                                      ).showSnackBar(
                                        DompetSnackbar(
                                          widget.parentContext,
                                          message:
                                              'Dompet ${result.name} siap digunakan.',
                                          snackBarType: .success,
                                        ),
                                      );
                                    },
                                    textColor: themeData.colorScheme.onPrimary,
                                  ),
                                ),
                              );
                            }
                          : () async {
                              widget.onBeforeAction?.call();
                              final form = widget.selectedAccount != null
                                  ? TransferForm()
                                  : null;

                              if (form != null) {
                                form.sourceForm.idControl.updateValue(
                                  widget.selectedAccount!.id,
                                );
                                form.sourceForm.nameControl.updateValue(
                                  widget.selectedAccount!.name,
                                );
                                form.sourceForm.balanceControl.updateValue(
                                  widget.selectedAccount!.balance,
                                );
                              }
                              await TransferRoute(form: form).push(context);
                            },
                      label: 'Pindah dana',
                      disabled: disabled,
                      icon: Icons.swap_horiz_rounded,
                      color: themeData.colorScheme.primary,
                      backgroundColor: widget.backgroundColor,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color color;
  final Color? backgroundColor;
  final bool disabled;
  const _QuickAction({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
    this.backgroundColor,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: disabled ? 0.3 : 1,
        child: Card(
          clipBehavior: .antiAlias,
          color: backgroundColor,
          child: InkWell(
            onTap: onTap,
            splashColor: color.withValues(alpha: 0.1),
            highlightColor: color.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 6,
                children: [
                  Icon(icon, color: color),
                  AutoScrollText(
                    text: label,
                    style: TextStyle(color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
