import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/assets/forms/asset_selector_form.dart';
import 'package:dompet_app/features/bills/cubits/bill_detail_cubit.dart';
import 'package:dompet_app/features/bills/cubits/bill_signal_cubit.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/models/bill_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Detail satu tagihan + catat pembayaran lunas.
@RoutePage()
class BillDetailPage extends StatefulWidget {
  final int billId;
  const BillDetailPage({super.key, required this.billId});

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  late final BillDetailCubit _cubit;
  final _loading = LoadingOverlay();

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BillDetailCubit>()..fetch(widget.billId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _pay(BillDetail detail) async {
    final assetId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _PaySheet(amount: detail.bill.amount),
    );
    if (assetId == null || !mounted) return;

    _loading.show(context, text: 'Mencatat pembayaran...');
    final error = await _cubit.payBill(assetId);
    _loading.hide();
    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        DompetSnackbar(context, message: error, snackBarType: .error),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      DompetSnackbar(
        context,
        message: 'Pembayaran berhasil dicatat',
        snackBarType: .success,
      ),
    );
    context.read<BillSignalCubit>().created();
    context.read<AccountSignalCubit>().created();
    context.read<ActivitySignalCubit>().created();
    await _cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BillSignalCubit, int>(
      listener: (context, state) => _cubit.refresh(),
      child: BlocProvider.value(
        value: _cubit,
        child: BlocBuilder<BillDetailCubit, BillDetailState>(
          bloc: _cubit,
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => Scaffold(
                appBar: AppBar(title: const Text('Detail Tagihan')),
                body: const SizedBox.shrink(),
              ),
              error: (message) => Scaffold(
                appBar: AppBar(title: const Text('Detail Tagihan')),
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
                    appBar: AppBar(title: const Text('Detail Tagihan')),
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
                  onPay: () => _pay(detail),
                );
              },
              loaded: (detail) => _DetailScaffold(
                detail: detail,
                onPay: () => _pay(detail),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  final BillDetail detail;
  final VoidCallback onPay;
  const _DetailScaffold({required this.detail, required this.onPay});

  @override
  Widget build(BuildContext context) {
    final bill = detail.bill;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tagihan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16).copyWith(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              _BillCard(detail: detail),
              _HistorySection(detail: detail),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 24),
          child: bill.canPay
              ? FilledButton.icon(
                  onPressed: onPay,
                  icon: const Icon(Icons.check_rounded),
                  label: Text('Catat Pembayaran • ${bill.amount.currency}'),
                )
              : _StatusBanner(detail: detail),
        ),
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final BillDetail detail;
  const _BillCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final bill = detail.bill;
    final billed = DateTime.fromMillisecondsSinceEpoch(bill.billedAt * 1000);
    final due = DateTime.fromMillisecondsSinceEpoch(bill.dueDate * 1000);
    final reminded = DateTime.fromMillisecondsSinceEpoch(
      bill.remindedAt * 1000,
    );
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
                    detail.plan.name,
                    style: themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _StatusChip(bill: bill),
              ],
            ),
            Text(
              bill.amount.currency,
              style: themeData.textTheme.headlineMedium?.copyWith(
                color: themeData.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Divider(),
            _MetaRow(label: 'Periode', value: bill.billPeriod),
            _MetaRow(label: 'Ditagih', value: billed.format(includeDay: true)),
            _MetaRow(label: 'Jatuh tempo', value: due.format(includeDay: true)),
            _MetaRow(
              label: 'Pengingat',
              value: reminded.format(includeDay: true),
            ),
            if (detail.paidAt != null)
              _MetaRow(
                label: 'Dibayar pada',
                value: detail.paidAt!.format(includeDay: true),
              ),
            if (detail.plan.reference != null) ...[
              const Divider(),
              Text(
                detail.plan.reference!,
                style: themeData.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Banner status pengganti tombol bayar: konten kartu tetap tampil.
class _StatusBanner extends StatelessWidget {
  final BillDetail detail;
  const _StatusBanner({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bill = detail.bill;
    final paid = bill.isPaid;
    final color = paid
        ? theme.colorScheme.tertiary
        : theme.colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 8,
        children: [
          Icon(
            paid ? Icons.check_circle_rounded : Icons.schedule_rounded,
            size: 20,
            color: color,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: .min,
              children: [
                Text(
                  paid ? 'Lunas' : 'Terjadwal',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  paid
                      ? detail.paidAt == null
                            ? 'Pembayaran tercatat'
                            : 'Dibayar pada ${detail.paidAt!.format(includeDay: true)}'
                      : 'Akan ditagih pada ${DateTime.fromMillisecondsSinceEpoch(bill.billedAt * 1000).format(includeDay: true)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Penanda status di kartu (label + warna sama dengan BillTile).
class _StatusChip extends StatelessWidget {
  final Bill bill;
  const _StatusChip({required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = switch (bill.statusValue) {
      BillStatus.drafted => ('Terjadwal', theme.colorScheme.onSurface),
      BillStatus.unpaid => bill.isDueReminderAt(DateTime.now())
          ? ('Segera dibayar', theme.colorScheme.primary)
          : ('Belum dibayar', theme.colorScheme.primary),
      BillStatus.paid => ('Lunas', theme.colorScheme.tertiary),
      BillStatus.overdue => ('Terlambat', theme.colorScheme.error),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {  final String label;
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
  final BillDetail detail;
  const _HistorySection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    if (detail.journals.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          'Riwayat',
          style: themeData.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Column(
          spacing: 12,
          children: [
            for (final journal in detail.journals)
              _JournalTile(
                title: journal.source == .billPayment
                    ? 'Pembayaran'
                    : 'Tagihan dibuat',
                date: DateTime.fromMillisecondsSinceEpoch(
                  journal.entryDate * 1000,
                ),
                amount: detail.bill.amount,
                isPayment: journal.source == .billPayment,
              ),
          ],
        ),
      ],
    );
  }
}

class _JournalTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final int amount;
  final bool isPayment;
  const _JournalTile({
    required this.title,
    required this.date,
    required this.amount,
    required this.isPayment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 12,
          children: [
            CircleAvatar(
              backgroundColor: isPayment
                  ? theme.colorScheme.tertiaryContainer
                  : theme.colorScheme.primaryContainer,
              foregroundColor: isPayment
                  ? theme.colorScheme.onTertiaryContainer
                  : theme.colorScheme.onPrimaryContainer,
              child: Icon(
                isPayment
                    ? Icons.check_rounded
                    : Icons.receipt_long_rounded,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    date.format(includeDay: true),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount.currency,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sheet pilih dompet sumber pembayaran (lunas penuh, nominal tetap).
class _PaySheet extends StatefulWidget {
  final int amount;
  const _PaySheet({required this.amount});

  @override
  State<_PaySheet> createState() => _PaySheetState();
}

class _PaySheetState extends State<_PaySheet> {
  final _form = AssetSelectorForm();

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: _form,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 24),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              Text(
                'Bayar dari',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              AssetSelector(
                accountSelectorForm: _form,
                label: 'Dompet',
              ),
              FilledButton(
                onPressed: () {
                  _form.markAllAsTouched();
                  if (!_form.valid) return;
                  Navigator.pop(context, _form.id);
                },
                child: Text('Bayar ${widget.amount.currency}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
