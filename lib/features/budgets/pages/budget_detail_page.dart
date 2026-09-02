import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/activities/extensions/list_activity.dart';
import 'package:dompet_app/features/activities/models/activity_list_item.dart';
import 'package:dompet_app/features/activities/widgets/activity_item_tile.dart';
import 'package:dompet_app/features/activities/widgets/empty_activities.dart';
import 'package:dompet_app/features/budgets/cubits/budget_detail_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:dompet_app/features/budgets/models/budget_detail.dart';
import 'package:dompet_app/features/budgets/utils/close_budget_handler.dart';
import 'package:dompet_app/features/budgets/utils/show_close_choice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class BudgetDetailPage extends StatefulWidget {
  final int budgetId;
  const BudgetDetailPage({super.key, required this.budgetId});

  @override
  State<BudgetDetailPage> createState() => _BudgetDetailPageState();
}

class _BudgetDetailPageState extends State<BudgetDetailPage> {
  late final BudgetDetailCubit _cubit;
  final _loading = LoadingOverlay();

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BudgetDetailCubit>()..fetch(widget.budgetId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _handleClose(BudgetDetail detail) async {
    if (!detail.canClose) {
      ScaffoldMessenger.of(context).showSnackBar(
        DompetSnackbar(
          context,
          message: 'Anggaran belum melewati periode, belum bisa ditutup',
          snackBarType: .error,
        ),
      );
      return;
    }
    final decision = await getCloseDecision(
      context: context,
      remaining: detail.budget.remaining,
      planAmount: detail.budget.budgetAmount,
      categoryName: detail.category.name,
      periode: detail.budget.periode,
    );
    if (decision == null || !mounted) return;

    _loading.show(
      context,
      text: decision.choice == CloseChoice.closeOnly
          ? 'Menutup anggaran...'
          : decision.carryAmount > 0
              ? 'Menutup dan membawa sisa...'
              : 'Menutup dan membuat baru...',
    );
    final String? error;
    if (decision.choice == CloseChoice.closeOnly) {
      error = await _cubit.closeBudget();
    } else {
      error = await _cubit.closeAndCreate(carryAmount: decision.carryAmount);
    }
    if (!mounted) return;
    _loading.hide();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        DompetSnackbar(context, message: error, snackBarType: .error),
      );
      return;
    }
    if (!mounted) return;
    context.read<BudgetSignalCubit>().created();
    ScaffoldMessenger.of(context).showSnackBar(
      DompetSnackbar(
        context,
        message: decision.choice == CloseChoice.closeOnly
            ? 'Anggaran berhasil ditutup'
            : 'Anggaran bulan ini berhasil dibuat',
        snackBarType: .success,
      ),
    );
    context.router.maybePop(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<ActivitySignalCubit, int>(
        listener: (_, _) => _cubit.refresh(),
        child: BlocBuilder<BudgetDetailCubit, BudgetDetailState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => Scaffold(
                appBar: AppBar(title: const Text('Detail Anggaran')),
                body: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 64),
                    child: SpinnerLoading(),
                  ),
                ),
              ),
              loading: () => Scaffold(
                appBar: AppBar(title: const Text('Detail Anggaran')),
                body: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 64),
                    child: SpinnerLoading(),
                  ),
                ),
              ),
              loaded: (detail) => _DetailScaffold(
                detail: detail,
                onClose: () => _handleClose(detail),
              ),
              error: (message) => Scaffold(
                appBar: AppBar(title: const Text('Detail Anggaran')),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  final BudgetDetail detail;
  final VoidCallback onClose;
  const _DetailScaffold({required this.detail, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _BudgetDetailView(detail: detail, onClose: onClose),
    );
  }
}

/// Single widget yang meng-handle seluruh halaman detail (sesuai permintaan: 1 halaman = 1 widget baru).
/// Menampung 4 bagian utama: Header, Kondisi, Statistik, Riwayat.
/// Fetch tanpa pagination (semua aktivitas sebulan) + lazy render via SliverList.builder
/// hanya widget yang terlihat di viewport yang di-build.
class _BudgetDetailView extends StatelessWidget {
  final BudgetDetail detail;
  final VoidCallback onClose;
  const _BudgetDetailView({required this.detail, required this.onClose});

  String _groupLabel(DateTime date, DateTime now) {
    final diff = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(date.year, date.month, date.day)).inDays;
    if (diff == 0) return 'Hari Ini';
    if (diff == 1) return 'Kemarin';
    if (diff < 7) return date.dayName;
    return date.format();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activities = detail.activities;
    final hasHistory = activities.isNotEmpty;
    final grouped = hasHistory ? activities.groupedItems : null;
    final now = DateTime.now();

    return CustomScrollView(
      slivers: [
        _DetailAppBar(detail: detail),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _ConditionSection(detail: detail, onClose: onClose),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverToBoxAdapter(child: _StatsSection(detail: detail)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Riwayat Pengeluaran',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  detail.budget.periode,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!hasHistory)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: EmptyActivities(
                emptyText:
                    'Belum ada pengeluaran untuk "${detail.category.name}" pada periode ini.',
                selectedAccount: detail.category,
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: grouped!.length,
              itemBuilder: (context, index) {
                final item = grouped[index];
                return switch (item) {
                  ActivityDateHeader(:final date) => Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(
                      _groupLabel(date, now),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ActivityItem(:final activity) => ActivityItemTile(
                    activity: activity,
                    hideDate: true,
                    accountId: detail.category.id,
                  ),
                  ActivitySpacing(:final height) => SizedBox(height: height),
                };
              },
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  final BudgetDetail detail;
  const _DetailAppBar({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = detail.budget.periodStartDate;
    final end = detail.budget.periodEndDate;
    final isSameMonth = start.year == end.year && start.month == end.month;
    final periodLabel = isSameMonth
        ? '${DateFormat('d', 'id').format(start)} – ${DateFormat('d MMM yyyy', 'id').format(end)}'
        : '${DateFormat('d MMM', 'id').format(start)} – ${DateFormat('d MMM yyyy', 'id').format(end)}';
    return SliverAppBar(
      pinned: true,
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.router.maybePop(),
      ),
      title: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: Icon(
              detail.category.iconCode == null
                  ? Icons.receipt_rounded
                  : MaterialIconData.fromCode(detail.category.iconCode!),
              size: 18,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 1,
              children: [
                Text(
                  detail.category.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
                  spacing: 4,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    Expanded(
                      child: Text(
                        periodLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: const [],
    );
  }
}

class _ConditionSection extends StatelessWidget {
  final BudgetDetail detail;
  final VoidCallback onClose;
  const _ConditionSection({required this.detail, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final budget = detail.budget;
    final isOver = detail.isOverBudget;
    final isOverPeriod = detail.daysRemaining == 0;
    final percent = (budget.useageRatio * 100).round().clamp(0, 999);
    final hasDaily = !isOverPeriod && !isOver && detail.dailyAllowance > 0;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            // Baris 1: nominal / nominal + percent pill (tanpa kata "terpakai"/"dari")
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: budget.actualSpend.currency,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isOver
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: ' / ${budget.actualBudgetAmount.currency}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.45,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (budget.hasCarry)
                          TextSpan(
                            text: '*',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOver
                        ? theme.colorScheme.error.withValues(alpha: 0.12)
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$percent%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isOver
                          ? theme.colorScheme.error
                          : theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            _UsageBar(ratio: budget.useageRatio, isOverBudget: isOver),
            // Baris 2: sisa + hari (satu baris, lebih ringkas)
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Text(
                    isOver
                        ? 'Melebihi ${budget.remaining.abs().currency}'
                        : '${budget.remaining.currency} tersisa',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isOver
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                Text(
                  isOverPeriod
                      ? 'Selesai'
                      : '${detail.daysRemaining} hari lagi',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            // Baris 3: hint harian — hanya jika relevan, tampil soft
            if (hasDaily)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.6,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: detail.dailyAllowance.currency,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextSpan(
                              text: ' / hari',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'sisa harian',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (isOverPeriod)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isOver
                      ? theme.colorScheme.errorContainer.withValues(alpha: 0.35)
                      : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(
                      isOver
                          ? Icons.warning_amber_rounded
                          : Icons.event_available_rounded,
                      size: 16,
                      color: isOver
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    Expanded(
                      child: Text(
                        isOver ? 'Melebihi anggaran' : 'Periode telah berakhir',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isOver
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: detail.canClose ? onClose : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(
                          color: theme.colorScheme.error.withValues(alpha: 0.5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(0, 32),
                        visualDensity: VisualDensity.compact,
                        textStyle: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              ),
            if (budget.hasCarry)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '*',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text: ' termasuk ${budget.carryAmount.currency} sisa bulan lalu',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UsageBar extends StatelessWidget {
  final double ratio;
  final bool isOverBudget;
  const _UsageBar({required this.ratio, required this.isOverBudget});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final clamped = ratio.clamp(0.0, 1.0);
    final fillColor = isOverBudget ? colorScheme.error : colorScheme.primary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          Container(
            height: 6,
            color: colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: clamped,
            child: Container(height: 6, color: fillColor),
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final BudgetDetail detail;
  const _StatsSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: _StatCard(
            label: 'Pengeluaran',
            value: detail.budget.actualSpend.currency,
            valueColor: theme.colorScheme.error,
          ),
        ),
        Expanded(
          child: _StatCard(
            label: 'Transaksi',
            value: '${detail.transactionCount}',
          ),
        ),
        Expanded(
          child: _StatCard(
            label: 'Rata-rata',
            value: detail.averageSpend == 0
                ? '-'
                : detail.averageSpend.currency,
            subLabel: detail.transactionCount == 0 ? null : '/ trx',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subLabel;
  final Color? valueColor;
  const _StatCard({
    required this.label,
    required this.value,
    this.subLabel,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 2,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: valueColor ?? theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (subLabel != null)
                  Text(
                    subLabel!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
