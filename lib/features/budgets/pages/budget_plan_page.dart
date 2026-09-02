import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/cubits/budget_plan_detail_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/budgets/models/budget_plan.dart';
import 'package:dompet_app/features/budgets/utils/close_budget_handler.dart';
import 'package:dompet_app/features/budgets/utils/show_close_choice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BudgetPlanPage extends StatefulWidget {
  final Account category;
  const BudgetPlanPage({super.key, required this.category});

  @override
  State<BudgetPlanPage> createState() => _BudgetPlanPageState();
}

class _BudgetPlanPageState extends State<BudgetPlanPage> {
  final _loading = LoadingOverlay();

  late final BudgetPlanDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BudgetPlanDetailCubit>()..fetch(widget.category.id);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _refresh() => _cubit.fetch(widget.category.id);

  Future<void> _runAction({
    required Future<String?> Function() action,
    required String loadingText,
    required String successMessage,
    bool refreshAfter = false,
  }) async {
    _loading.show(context, text: loadingText);
    final error = await action();
    if (!mounted) return;
    _loading.hide();

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        DompetSnackbar(context, message: error, snackBarType: .error),
      );
      return;
    }

    context.read<BudgetSignalCubit>().created();
    ScaffoldMessenger.of(context).showSnackBar(
      DompetSnackbar(context, message: successMessage, snackBarType: .success),
    );
    if (refreshAfter) {
      await _refresh();
    }
  }

  Future<void> _edit(BudgetPlan plan) async {
    final changed = await context.router.push<bool>(
      BudgetPlanFormRoute(category: widget.category, plan: plan),
    );
    if (changed == true && mounted) {
      await _refresh();
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus rencana?'),
        content: const Text(
          'Rencana untuk kategori ini akan dihapus. '
          'Anggaran yang sudah aktif tidak terpengaruh.',
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.router.maybePop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => dialogContext.router.maybePop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await _runAction(
      action: _cubit.deletePlan,
      loadingText: 'Menghapus rencana...',
      successMessage: 'Rencana berhasil dihapus',
      refreshAfter: false,
    );

    if (mounted) context.router.maybePop(true);
  }

  Future<void> _primary(BuildContext context, {BudgetPlanAction? action}) async {
    switch (action) {
      case BudgetPlanAction.activate:
        await _runAction(
          action: _cubit.activate,
          loadingText: 'Membuat anggaran...',
          successMessage: 'Anggaran bulan ini berhasil dibuat',
          refreshAfter: true,
        );
        break;
      case BudgetPlanAction.close:
        final activeBudget = _cubit.state.maybeWhen(
          loaded: (_, activeBudget) => activeBudget,
          orElse: () => null,
        );
        final plan = _cubit.state.maybeWhen(
          loaded: (plan, _) => plan,
          orElse: () => null,
        );
        if (activeBudget == null || plan == null) return;
        final decision = await getCloseDecision(
          context: context,
          remaining: activeBudget.remaining,
          planAmount: plan.amount,
          categoryName: widget.category.name,
          periode: activeBudget.periode,
        );
        if (decision == null || !mounted) return;
        if (decision.choice == CloseChoice.closeOnly) {
          await _runAction(
            action: _cubit.closeBudgets,
            loadingText: 'Menutup anggaran...',
            successMessage: 'Anggaran berhasil ditutup',
            refreshAfter: true,
          );
        } else {
          await _runAction(
            action: () => _cubit.closeAndStartMonth(carryAmount: decision.carryAmount),
            loadingText: decision.carryAmount > 0
                ? 'Menutup dan membawa sisa...'
                : 'Tutup anggaran lama dan buat yang baru...',
            successMessage: 'Anggaran bulan ini berhasil dibuat',
            refreshAfter: true,
          );
        }
        break;
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rencana Anggaran',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<BudgetPlanDetailCubit, BudgetPlanDetailState>(
          bloc: _cubit,
          listener: (context, state) {
            state.maybeWhen(
              loading: (plan, activeBudget) {
                if (plan == null) {
                  _loading.hide();
                  return;
                }
                _loading.show(context);
              },
              orElse: () {
                _loading.hide();
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => SizedBox.shrink(),
              error: (message) => Center(
                child: Text(
                  message,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
              loading: (plan, activeBudget) {
                return plan == null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 64),
                        child: SpinnerLoading(),
                      )
                    : _Body(
                        category: widget.category,
                        plan: plan,
                        activeBudget: activeBudget,
                        onEdit: () => _edit(plan),
                        onDelete: _delete,
                        onPrimary: (action) =>
                            _primary(context, action: action),
                      );
              },
              loaded: (plan, activeBudget) {
                return _Body(
                  category: widget.category,
                  plan: plan,
                  activeBudget: activeBudget,
                  onEdit: () => _edit(plan),
                  onDelete: _delete,
                  onPrimary: (action) => _primary(context, action: action),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Account category;
  final BudgetPlan plan;
  final Budget? activeBudget;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<BudgetPlanAction?> onPrimary;
  const _Body({
    required this.category,
    required this.plan,
    required this.onEdit,
    required this.onDelete,
    required this.onPrimary,
    this.activeBudget,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final action = BudgetPlanAction.of(activeBudget);

    return Padding(
      padding: const EdgeInsets.all(16).copyWith(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CategoryHeader(category: category),
          const SizedBox(height: 16),
          _PlanCard(plan: plan),
          const Spacer(),
          _ActionHint(action: action),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: action != null ? () => onPrimary(action) : null,
            icon: Icon(action?.icon),
            label: Text(action?.label ?? 'Anggaran sedang berjalan'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: onEdit, child: const Text('Edit Rencana')),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onDelete,
            style: TextButton.styleFrom(
              foregroundColor: themeData.colorScheme.error,
            ),
            child: const Text('Hapus Rencana'),
          ),
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final Account category;
  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: themeData.colorScheme.primaryContainer,
          foregroundColor: themeData.colorScheme.onPrimaryContainer,
          child: Icon(
            category.iconCode == null
                ? Icons.receipt_rounded
                : MaterialIconData.fromCode(category.iconCode!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            category.name,
            style: themeData.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final BudgetPlan plan;
  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Text(
              'Besar Rencana',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            Text(
              plan.amount.currency,
              style: themeData.textTheme.headlineMedium?.copyWith(
                color: themeData.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (plan.note != null) ...[
              const Divider(),
              Text(plan.note!, style: themeData.textTheme.bodyMedium),
            ],
            const Divider(),
            Text(
              'Dibuat pada ${plan.createdAt.dateTime.format(includeDay: true)}',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _BudgetPlanActionUi on BudgetPlanAction {
  String get label => switch (this) {
    BudgetPlanAction.activate => 'Aktifkan',
    BudgetPlanAction.close => 'Tutup Anggaran',
  };

  IconData get icon => switch (this) {
    BudgetPlanAction.activate => Icons.play_arrow_rounded,
    BudgetPlanAction.close => Icons.stop_rounded,
  };
}

class _ActionHint extends StatelessWidget {
  final BudgetPlanAction? action;
  const _ActionHint({required this.action});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final text = switch (action) {
      BudgetPlanAction.activate =>
        'Kategori ini belum punya anggaran aktif. Aktifkan rencana untuk membuat anggaran bulan ini.',
      BudgetPlanAction.close =>
        'Anggaran aktif untuk bulan ini sedang berjalan. Tutup untuk menghentikannya.',
      null => '',
    };
    return Text(
      text,
      textAlign: TextAlign.center,
      style: themeData.textTheme.bodySmall?.copyWith(
        color: themeData.colorScheme.onSurface.withValues(alpha: 0.8),
      ),
    );
  }
}
