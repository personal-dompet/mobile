import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/bills/cubits/bill_plan_detail_cubit.dart';
import 'package:dompet_app/features/bills/cubits/bill_signal_cubit.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/bills/models/bill_plan_detail.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:dompet_app/features/bills/widgets/bill_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Detail tagihan rutin: info plan + 5 tagihan terbaru + Lihat Semua.
@RoutePage()
class BillPlanDetailPage extends StatefulWidget {
  final int planId;
  const BillPlanDetailPage({super.key, required this.planId});

  @override
  State<BillPlanDetailPage> createState() => _BillPlanDetailPageState();
}

class _BillPlanDetailPageState extends State<BillPlanDetailPage> {
  late final BillPlanDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BillPlanDetailCubit>()..fetch(widget.planId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _edit(BillPlan plan) async {
    final changed = await context.router.push<bool>(
      BillPlanFormRoute(plan: plan),
    );
    if (changed == true && mounted) {
      context.read<BillSignalCubit>().created();
      await _cubit.refresh();
    }
  }

  Future<void> _delete(BillPlanDetail detail) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus tagihan rutin?'),
        content: Text(
          '"${detail.plan.name}" akan dihapus. '
          'Tagihan terjadwal yang belum aktif ikut dihapus. '
          'Tagihan yang sudah aktif tidak akan ikut dihapus.',
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

    final error = await _cubit.deletePlan();
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        DompetSnackbar(context, message: error, snackBarType: .error),
      );
      return;
    }
    context.read<BillSignalCubit>().created();
    context.router.maybePop(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BillSignalCubit, int>(
      listener: (context, state) => _cubit.refresh(),
      child: BlocProvider.value(
        value: _cubit,
        child: BlocBuilder<BillPlanDetailCubit, BillPlanDetailState>(
          bloc: _cubit,
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => Scaffold(
                appBar: AppBar(title: const Text('Detail Tagihan Rutin')),
                body: const SizedBox.shrink(),
              ),
              error: (message) => Scaffold(
                appBar: AppBar(title: const Text('Detail Tagihan Rutin')),
                body: Center(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              loading: (detail) {
                if (detail == null) {
                  return Scaffold(
                    appBar: AppBar(title: const Text('Detail Tagihan Rutin')),
                    body: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 64),
                        child: SpinnerLoading(),
                      ),
                    ),
                  );
                }
                return _DetailScaffold(
                  detail: detail,
                  onEdit: () => _edit(detail.plan),
                  onDelete: () => _delete(detail),
                );
              },
              loaded: (detail) => _DetailScaffold(
                detail: detail,
                onEdit: () => _edit(detail.plan),
                onDelete: () => _delete(detail),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  final BillPlanDetail detail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _DetailScaffold({
    required this.detail,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tagihan Rutin')),
      body: SafeArea(
        child: _Body(detail: detail),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 24),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: onEdit,
                child: const Text('Ubah Tagihan Rutin'),
              ),
              TextButton(
                onPressed: onDelete,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Hapus Tagihan Rutin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final BillPlanDetail detail;
  const _Body({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16).copyWith(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          _PlanHeader(detail: detail),
          _PlanCard(detail: detail),
          _HistorySection(detail: detail),
        ],
      ),
    );
  }
}

class _PlanHeader extends StatelessWidget {
  final BillPlanDetail detail;
  const _PlanHeader({required this.detail});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: themeData.colorScheme.primaryContainer,
          foregroundColor: themeData.colorScheme.onPrimaryContainer,
          child: Icon(
            detail.category.iconCode == null
                ? Icons.receipt_rounded
                : MaterialIconData.fromCode(detail.category.iconCode!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                detail.plan.name,
                style: themeData.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                detail.category.name,
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final BillPlanDetail detail;
  const _PlanCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final plan = detail.plan;
    final isMonthly = plan.period == BillPlanPeriodEnum.monthly.name;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Text(
              'Nominal Tagihan',
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
            const Divider(),
            _MetaRow(
              label: 'Ditagih setiap',
              value:
                  '${isMonthly ? 'Bulanan' : 'Tahunan'} • ${BillSchedule.format(plan.period, plan.billedSchedule)}',
            ),
            _MetaRow(
              label: 'Jatuh tempo',
              value: BillSchedule.format(
                plan.period,
                plan.dueDateSchedule,
              ),
            ),
            _MetaRow(
              label: 'Pengingat',
              value: (plan.reminderDays ?? 0) == 0
                  ? 'Tanpa pengingat'
                  : 'H-${plan.reminderDays} sebelum jatuh tempo',
            ),
            _MetaRow(
              label: 'Berakhir',
              value: plan.endedAt == null
                  ? 'Tanpa batas akhir'
                  : '${DateTime.fromMillisecondsSinceEpoch(plan.endedAt! * 1000).format()}${detail.isEnded ? ' • Berakhir' : ''}',
            ),
            if (plan.reference != null) ...[
              const Divider(),
              Text(plan.reference!, style: themeData.textTheme.bodyMedium),
            ],
            if (plan.note != null) ...[
              if (plan.reference == null) const Divider(),
              Text(plan.note!, style: themeData.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: themeData.textTheme.bodySmall?.copyWith(
              color: themeData.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: themeData.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _HistorySection extends StatelessWidget {
  final BillPlanDetail detail;
  const _HistorySection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tagihan Terbaru',
                style: themeData.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (detail.hasMore)
              GestureDetector(
                onTap: () => context.router.push(
                  BillPlanBillsRoute(
                    planId: detail.plan.id,
                    planName: detail.plan.name,
                  ),
                ),
                child: Row(
                  spacing: 2,
                  children: [
                    Text(
                      'Lihat Semua',
                      style: themeData.textTheme.labelLarge?.copyWith(
                        color: themeData.colorScheme.primary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: themeData.colorScheme.primary,
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (detail.recentBills.isEmpty)
          const Text('Belum ada tagihan.', textAlign: TextAlign.center)
        else
          Column(
            spacing: 12,
            children: [for (final bill in detail.recentBills) BillTile(bill: bill)],
          ),
      ],
    );
  }
}
