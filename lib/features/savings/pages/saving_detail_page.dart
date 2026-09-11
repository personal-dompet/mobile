import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/activities/extensions/list_activity.dart';
import 'package:dompet_app/features/bills/cubits/bill_signal_cubit.dart';
import 'package:dompet_app/features/activities/models/activity_list_item.dart';
import 'package:dompet_app/features/activities/widgets/activity_item_tile.dart';
import 'package:dompet_app/features/activities/widgets/empty_activities.dart';
import 'package:dompet_app/features/savings/cubits/saving_detail_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:dompet_app/features/savings/models/saving_detail.dart';
import 'package:dompet_app/features/savings/models/saving_insight.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SavingDetailPage extends StatefulWidget {
  final int accountId;
  const SavingDetailPage({super.key, required this.accountId});

  @override
  State<SavingDetailPage> createState() => _SavingDetailPageState();
}

class _SavingDetailPageState extends State<SavingDetailPage> {
  final _loading = LoadingOverlay();

  late final SavingDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<SavingDetailCubit>()..fetch(widget.accountId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _refresh() => _cubit.fetch(widget.accountId);

  /// Dompet cair dari state (aturan 5). Kosong bila state belum loaded.
  List<Account> _currentLiquidAssets() => _cubit.state.maybeWhen(
    loaded: (detail) => detail.liquidAssets,
    orElse: () => const [],
  );

  void _emitSignals() {
    if (!mounted) return;
    try {
      context.read<SavingSignalCubit>().created();
      context.read<AccountSignalCubit>().created();
      context.read<ActivitySignalCubit>().created();
      context.read<BillSignalCubit>().created();
    } catch (_) {}
  }

  Future<void> _runAction({
    required Future<String?> Function() action,
    required String loadingText,
    required String successMessage,
    bool popAfter = false,
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

    _emitSignals();
    ScaffoldMessenger.of(context).showSnackBar(
      DompetSnackbar(context, message: successMessage, snackBarType: .success),
    );
    if (popAfter) {
      context.router.maybePop(true);
    } else {
      await _refresh();
    }
  }

  Future<void> _edit(SavingPlan plan) async {
    final changed = await context.router.push<bool>(
      SavingFormRoute(plan: plan),
    );
    if (changed == true && mounted) {
      _emitSignals();
      await _refresh();
    }
  }

  Future<void> _delete(SavingPlan plan) async {
    // Saldo 0: hapus langsung tanpa jurnal.
    if (plan.balance <= 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Hapus target?'),
          content: Text(
            'Target "${plan.accountName}" akan dihapus. '
            'Riwayat alokasi tidak terpengaruh. '
            'Transaksi yang sudah dicatat tidak akan ikut dihapus.',
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
        action: _cubit.deletePocket,
        loadingText: 'Menghapus target...',
        successMessage: 'Target berhasil dihapus',
        popAfter: true,
      );
      return;
    }

    // Saldo > 0: sisa harus kembali ke dompet cair dalam transaksi yang
    // sama dengan penghapusan. Kalau tidak, sisa terkunci selamanya di
    // pocket non-liquid yang ter-soft-delete (tak terlihat di daftar
    // maupun Total Uang).
    final assetId = await _pickWithdrawDestination(
      balance: plan.balance,
      assets: _currentLiquidAssets(),
    );
    if (assetId == null || !mounted) return;

    await _runAction(
      action: () => _cubit.deleteWithWithdraw(assetId: assetId),
      loadingText: 'Menarik sisa dan menghapus target...',
      successMessage: 'Target dihapus, sisa kembali ke dompet',
      popAfter: true,
    );
  }

  /// Dialog pilih dompet cair tujuan pengembalian sisa saat hapus.
  /// [assets] dari state (aturan 5). Mengembalikan `null` jika user batal.
  Future<int?> _pickWithdrawDestination({
    required int balance,
    required List<Account> assets,
  }) async {
    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        int? selectedId;
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('Hapus target?'),
              content: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: 12,
                children: [
                  Text(
                    'Sisa ${balance.currency} akan dikembalikan ke dompet:',
                  ),
                  _LiquidAssetDropdown(
                    assets: assets,
                    selectedId: selectedId,
                    labelText: 'Ke Dompet',
                    onChanged: (value) =>
                        setState(() => selectedId = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => dialogContext.router.maybePop(),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: selectedId == null
                      ? null
                      : () =>
                            dialogContext.router.maybePop(selectedId),
                  child: const Text('Hapus & Tarik'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openMutation(SavingPlan plan, _MutationKind kind) async {
    final router = context.router;
    final changed = switch (kind) {
      _MutationKind.topup => await router.push<bool>(
        SavingAllocationRoute(accountId: plan.accountId),
      ),
      _MutationKind.withdraw => await router.push<bool>(
        SavingAllocationRoute(accountId: plan.accountId, isWithdraw: true),
      ),
      _MutationKind.spend => await router.push<bool>(
        SavingSpendRoute(accountId: plan.accountId),
      ),
    };
    if (changed == true && mounted) {
      _emitSignals();
      await _refresh();
    }
  }

  Future<void> _payLinkedBill(SavingDetail detail) async {
    final bill = detail.linkedBill;
    if (bill == null) return;
    final assetId = await _pickTransitAsset(
      amount: bill.amount,
      assets: detail.liquidAssets,
    );
    if (assetId == null || !mounted) return;

    await _runAction(
      action: () => _cubit.payLinkedBill(assetId: assetId),
      loadingText: 'Membayar tagihan dari target...',
      successMessage: 'Tagihan berhasil dibayar dari target',
    );
  }

  /// Dialog pilih dompet perantara (transit) pembayaran dari target.
  /// [assets] dari state (aturan 5). Mengembalikan `null` jika user batal.
  Future<int?> _pickTransitAsset({
    required int amount,
    required List<Account> assets,
  }) async {
    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        int? selectedId;
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('Bayar tagihan'),
              content: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: 12,
                children: [
                  Text('Bayar ${amount.currency} dari target lewat dompet:'),
                  _LiquidAssetDropdown(
                    assets: assets,
                    selectedId: selectedId,
                    labelText: 'Lewat Dompet',
                    onChanged: (value) =>
                        setState(() => selectedId = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => dialogContext.router.maybePop(),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: selectedId == null
                      ? null
                      : () => dialogContext.router.maybePop(selectedId),
                  child: const Text('Bayar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavingSignalCubit, int>(
      listener: (context, state) => _refresh(),
      child: BlocConsumer<SavingDetailCubit, SavingDetailState>(
      bloc: _cubit,
      listener: (context, state) {
        state.maybeWhen(
          loading: (plan) {
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
          orElse: () => Scaffold(
            appBar: AppBar(title: const Text('Detail Target')),
            body: const SizedBox.shrink(),
          ),
          error: (message) => Scaffold(
            appBar: AppBar(title: const Text('Detail Target')),
            body: Center(
              child: Text(
                message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          loading: (plan) {
            if (plan == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Detail Target')),
                body: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 64),
                    child: SpinnerLoading(),
                  ),
                ),
              );
            }
            return _DetailScaffold(
              plan: plan,
              detail: null,
              onEdit: () => _edit(plan),
              onDelete: () => _delete(plan),
              onMutation: (kind) => _openMutation(plan, kind),
              onPayBill: null,
            );
          },
          loaded: (detail) {
            final plan = detail.plan;
            return _DetailScaffold(
              plan: plan,
              detail: detail,
              onEdit: () => _edit(plan),
              onDelete: () => _delete(plan),
              onMutation: (kind) => _openMutation(plan, kind),
              onPayBill: () => _payLinkedBill(detail),
            );
          },
        );
      },
      ),
    );
  }
}

enum _MutationKind { topup, withdraw, spend }

/// Dropdown dompet cair bersama untuk dialog hapus/bayar.
class _LiquidAssetDropdown extends StatelessWidget {
  final List<Account> assets;
  final int? selectedId;
  final String labelText;
  final ValueChanged<int?> onChanged;
  const _LiquidAssetDropdown({
    required this.assets,
    required this.selectedId,
    required this.labelText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return Text(
        'Tidak ada dompet cair. Buat dompet dulu.',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    }
    return DropdownButtonFormField<int>(
      initialValue: selectedId,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      items: assets.map((asset) {
        return DropdownMenuItem(
          value: asset.id,
          child: Text(
            '${asset.name} (${asset.balance.currency})',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  final SavingPlan plan;
  final SavingDetail? detail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<_MutationKind> onMutation;
  final VoidCallback? onPayBill;
  const _DetailScaffold({
    required this.plan,
    required this.detail,
    required this.onEdit,
    required this.onDelete,
    required this.onMutation,
    this.onPayBill,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Target',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: _Body(
          plan: plan,
          detail: detail,
          onMutation: onMutation,
          onPayBill: onPayBill,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 24),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            spacing: 8,
            children: [
              OutlinedButton(onPressed: onEdit, child: const Text('Edit Target')),
              TextButton(
                onPressed: onDelete,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Hapus Target'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final SavingPlan plan;
  final SavingDetail? detail;
  final ValueChanged<_MutationKind> onMutation;
  final VoidCallback? onPayBill;
  const _Body({
    required this.plan,
    required this.detail,
    required this.onMutation,
    this.onPayBill,
  });

  @override
  Widget build(BuildContext context) {
    final detail = this.detail;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16).copyWith(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          _PlanHeader(plan: plan),
          _PlanCard(plan: plan),
          if (detail != null)
            _LinkedBillSection(detail: detail, onPayBill: onPayBill),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => onMutation(_MutationKind.topup),
                  icon: Icon(Icons.add_rounded),
                  label: const Text('Alokasi'),
                ),
              ),
              // Target sisihan tagihan rutin tak boleh dibelanjakan:
              // keluar dana hanya via Tarik atau Bayar Tagihan agar
              // tagihan tetap terlunasi lewat jurnal bill_payment.
              if (!plan.isBillSinkingFund)
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => onMutation(_MutationKind.spend),
                    icon: Icon(Icons.shopping_bag_rounded),
                    label: const Text('Belanja'),
                  ),
                ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onMutation(_MutationKind.withdraw),
                  icon: Icon(Icons.output_rounded),
                  label: const Text('Tarik'),
                ),
              ),
            ],
          ),
          if (detail != null) _InsightSection(detail: detail),
          if (detail != null) _HistorySection(detail: detail),
        ],
      ),
    );
  }
}

class _PlanHeader extends StatelessWidget {
  final SavingPlan plan;
  const _PlanHeader({required this.plan});

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
            plan.iconCode == null
                ? Icons.savings_rounded
                : MaterialIconData.fromCode(plan.iconCode!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                plan.accountName,
                style: themeData.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                plan.hasTarget
                    ? '${plan.balance.currency} dari ${plan.targetAmount!.currency}'
                    : plan.balance.currency,
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
  final SavingPlan plan;
  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final ratio = plan.progressRatio;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Text(
              'Terkumpul',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            Text(
              plan.balance.currency,
              style: themeData.textTheme.headlineMedium?.copyWith(
                color: themeData.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (ratio != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      color: themeData.colorScheme.onSurface.withValues(
                        alpha: 0.15,
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: .centerLeft,
                      widthFactor: ratio.clamp(0.0, 1.0),
                      child: Container(
                        height: 6,
                        color: themeData.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                plan.hasTarget
                    ? '${((ratio) * 100).round()}% dari ${plan.targetAmount!.currency}'
                    : plan.balance.currency,
                style: themeData.textTheme.bodySmall,
              ),
            ],
            if (plan.note != null) ...[
              const Divider(),
              Text(plan.note!, style: themeData.textTheme.bodyMedium),
            ],
            const Divider(),
            _MetaFooter(plan: plan),
          ],
        ),
      ),
    );
  }
}

/// Tagihan terkait target sisihan: status + tombol bayar langsung.
/// Hanya tampil untuk target ter-link tagihan rutin.
class _LinkedBillSection extends StatelessWidget {
  final SavingDetail detail;
  final VoidCallback? onPayBill;
  const _LinkedBillSection({required this.detail, this.onPayBill});

  @override
  Widget build(BuildContext context) {
    final plan = detail.plan;
    if (!plan.isBillSinkingFund) return const SizedBox.shrink();

    final themeData = Theme.of(context);
    final bill = detail.linkedBill;
    final onPay = onPayBill;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tagihan Terkait'
                    '${plan.billPeriod == null ? '' : ' • ${plan.billPeriod}'}',
                    style: themeData.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (bill != null)
                  GestureDetector(
                    onTap: () => context.router.push(
                      BillDetailRoute(billId: bill.id),
                    ),
                    child: Row(
                      spacing: 2,
                      children: [
                        Text(
                          'Lihat',
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
            if (bill == null)
              Text(
                'Tagihan belum tergenerate.',
                style: themeData.textTheme.bodySmall,
              )
            else ...[
              Text(
                bill.amount.currency,
                style: themeData.textTheme.titleMedium?.copyWith(
                  color: themeData.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                bill.isPaid
                    ? 'Sudah lunas'
                    : bill.canPay
                    ? 'Jatuh tempo ${DateTime.fromMillisecondsSinceEpoch(bill.dueDate * 1000).format(includeDay: true)}'
                    : 'Terjadwal',
                style: themeData.textTheme.bodySmall,
              ),
              if (bill.canPay && onPay != null) ...[
                const SizedBox(height: 4),
                if (plan.balance < bill.amount)
                  Text(
                    'Saldo target ${plan.balance.currency} belum cukup.',
                    style: themeData.textTheme.bodySmall?.copyWith(
                      color: themeData.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                FilledButton.icon(
                  onPressed: plan.balance >= bill.amount ? onPay : null,
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: Text('Bayar Tagihan • ${bill.amount.currency}'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaFooter extends StatelessWidget {
  final SavingPlan plan;
  const _MetaFooter({required this.plan});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final muted = themeData.colorScheme.onSurface.withValues(alpha: 0.6);
    final parts = [
      'Dibuat ${plan.createdAt.dateTime.format()}',
      if (plan.targetDateTime != null)
        'Target ${plan.targetDateTime!.format()}',
    ];
    return Row(
      spacing: 6,
      children: [
        Icon(Icons.calendar_today_rounded, size: 12, color: muted),
        Expanded(
          child: Text(
            parts.join(' • '),
            style: themeData.textTheme.bodySmall?.copyWith(color: muted),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Insight Detail Target: satu hero Proyeksi.
///
/// Menjawab "seberapa dekat saya dengan tujuan, dan apakah saya
/// akan mencapainya?" — bukan statistik transaksi mentah.
class _InsightSection extends StatelessWidget {
  final SavingDetail detail;
  const _InsightSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Text(
          'Insight Target',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        _ProjectionHero(detail: detail),
      ],
    );
  }
}

/// Hero proyeksi: kartu utama yang menjawab "kapan kira-kira selesai?"
class _ProjectionHero extends StatelessWidget {
  final SavingDetail detail;
  const _ProjectionHero({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final insight = detail.insight;
    final plan = detail.plan;

    // Tanpa nominal tujuan: tidak ada yang diproyeksikan.
    if (insight.status == SavingInsightStatus.noTarget) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: colorScheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'Terus kumpulkan tanpa batas',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      plan.balance.currency,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.65),
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

    if (insight.status == SavingInsightStatus.reached) {
      return Card(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Icon(
                Icons.celebration_rounded,
                color: colorScheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'Target tercapai',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '${plan.balance.currency} dari ${plan.targetAmount!.currency}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.75,
                        ),
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

    // Tenggat lewat selalu menang atas proyeksi laju: tanggal yang
    // dijanjikan sudah berlalu, estimasi kecepatan tidak lagi relevan.
    if (insight.isOverdue) {
      return Card(
        color: colorScheme.errorContainer.withValues(alpha: 0.35),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.event_busy_rounded, color: colorScheme.error),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'Tenggat telah lewat',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.error,
                      ),
                    ),
                    Text(
                      '${insight.remaining.currency} belum terkumpul',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.65),
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

    // Tanpa deadline: hero menjawab "kapan kira-kira selesai?"
    // Seluruh angka laju dalam bulanan. Yang berdeadline selalu memakai
    // format kebutuhan di bawah, bukan proyeksi tanggal laju.
    if (!insight.hasDeadline &&
        insight.showProjection &&
        insight.projectedDate != null) {
      final dateLabel = insight.projectedDate!.format();
      final paceLabel =
          'Jika konsisten ${insight.avgPerMonth.currency}/bulan';
      final durationLabel = insight.etaDurationLabel;
      return Card(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Icon(
                Icons.event_available_rounded,
                color: colorScheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'Perkiraan tercapai $dateLabel',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      [paceLabel, durationLabel].nonNulls.join(
                        ' • ',
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.75,
                        ),
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

    // Ada deadline (belum lewat): satu-satunya format hero berbasis sisa.
    // Title "Perlu .../bulan" hanya bila tenggat >= sebulan; di bawah itu
    // rate bulanan melebihi sisa (annualisasi parsial), jadi hero hanya
    // menampilkan sisa + hitung mundur. Berlaku baik untuk histori cukup
    // maupun belum — deadline-nya tetap sama.
    if (insight.showNeededPerMonth) {
      final deadlineLabel = insight.deadlineDurationLabel;
      if (!insight.showNeedRate) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 12,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: colorScheme.primary,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        '${insight.remaining.currency} lagi',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (deadlineLabel != null)
                        Text(
                          deadlineLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
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
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Icon(
                Icons.schedule_rounded,
                color: colorScheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'Saran alokasi ${insight.neededPerMonth!.currency}/bulan',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      [
                        '${insight.remaining.currency} lagi',
                        deadlineLabel,
                      ].nonNulls.join(' • '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.65),
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

    // Fallback netral: tanpa deadline dan histori belum cukup.
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 12,
          children: [
            Icon(
              Icons.timeline_rounded,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    'Perkiraan belum tersedia',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Catat alokasi secara rutin untuk melihat estimasi.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.65),
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

/// Riwayat Target: full list aktivitas pocket (alokasi/tarik/belanja),
/// dikelompokkan per tanggal seperti Detail Anggaran.
class _HistorySection extends StatelessWidget {
  final SavingDetail detail;
  const _HistorySection({required this.detail});

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
    final now = DateTime.now();
    // Saldo berjalan setelah tiap aktivitas (tertua → terbaru), agar riwayat
    // terbaca sebagai timeline: alokasi menambah, tarik/belanja mengurangi.
    final balanceAfter = <int, int>{};
    {
      final chronological = [...activities]
        ..sort((a, b) => a.entryDate.compareTo(b.entryDate));
      var running = 0;
      for (final journal in chronological) {
        final line = journal.lines
            .where((l) => l.accountId == detail.plan.accountId)
            .firstOrNull;
        if (line != null) {
          running += line.debitAmount - line.creditAmount;
          balanceAfter[journal.id] = running;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Riwayat Target',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (activities.isNotEmpty)
              Text(
                '${activities.length} aktivitas',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
        if (activities.isEmpty) ...[
          const SizedBox(height: 8),
          EmptyActivities(
            emptyText:
                'Belum ada aktivitas untuk "${detail.plan.accountName}".',
          ),
        ] else
          ...activities.groupedItems.map((item) {
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
                accountId: detail.plan.accountId,
                // FIX-10 (ISSUE 13): Terkumpul di dalam card, di bawah
                // nominal, sejajar keterangan waktu.
                footerTrailing: balanceAfter[activity.id] != null
                    ? 'Terkumpul ${balanceAfter[activity.id]!.currency}'
                    : null,
              ),
              ActivitySpacing(:final height) => SizedBox(height: height),
            };
          }),
      ],
    );
  }
}
