import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/activities/cubits/activity_detail_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/activities/extensions/activity_detail.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/models/journal_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ActivityDetailPage extends StatelessWidget {
  final int id;
  const ActivityDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ActivityDetailCubit>()..init(id),
      child: BlocBuilder<ActivityDetailCubit, ActivityDetailState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => SizedBox.shrink(),
            loading: () => Scaffold(
              appBar: AppBar(title: Text('Detail Aktivitas')),
              body: SafeArea(child: Center(child: SpinnerLoading())),
            ),
            loaded: (activity) {
              return _DetailContent(activity: activity);
            },
            error: (message) => Scaffold(body: Center(child: Text(message))),
            actionLoading: (activity) {
              if (activity == null) return SizedBox.shrink();
              return _DetailContent(activity: activity);
            },
            actionSuccess: (activity) {
              if (activity == null) return SizedBox.shrink();
              return _DetailContent(activity: activity);
            },
            actionError: (activity, message) {
              if (activity == null) return SizedBox.shrink();
              return _DetailContent(activity: activity);
            },
          );
        },
      ),
    );
  }
}

class _DetailContent extends StatefulWidget {
  final JournalEntry activity;
  const _DetailContent({required this.activity});

  @override
  State<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<_DetailContent> {
  final _loading = LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    String displayAmount = widget.activity.amount.currency;

    if (widget.activity.type == .income ||
        (widget.activity.type == .adjustment &&
            widget.activity.assetLines.first.debitAmount > 0)) {
      displayAmount = '+$displayAmount';
    }

    if (widget.activity.type == .expense ||
        (widget.activity.type == .adjustment &&
            widget.activity.assetLines.first.creditAmount > 0)) {
      displayAmount = '-$displayAmount';
    }
    return BlocListener<ActivityDetailCubit, ActivityDetailState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {
            _loading.hide();
          },
          actionLoading: (activity) {
            _loading.show(context, text: 'Menghapus aktivitas...');
          },
          actionError: (activity, message) {
            _loading.hide();
            ScaffoldMessenger.of(context).showSnackBar(
              DompetSnackbar(context, message: message, snackBarType: .error),
            );
          },
          actionSuccess: (activity) {
            _loading.hide();
            context.router.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              DompetSnackbar(
                context,
                message: 'Berhasil menghapus aktivitas.',
                snackBarType: .success,
              ),
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.activity.title)),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 24),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            spacing: 8,
            children: [
              if (widget.activity.type != .adjustment)
                FilledButton(
                  onPressed: () async {
                    final batch =
                        widget.activity.lines.length > 2 ||
                        widget.activity.lines.any((line) => line.note != null);
                    switch (widget.activity.type) {
                      case .adjustment:
                      case .all:
                      case .billPayment:
                      case .expense:
                        final result = await TransactionRoute(
                          type: .expense,
                          id: widget.activity.id,
                          form: widget.activity.toTransactionForm(),
                          batch: batch,
                        ).push<int>(context);
                        if (result != null && context.mounted) {
                          context.router.replace(
                            ActivityDetailRoute(id: result),
                          );
                        }
                      case .income:
                        final result = await TransactionRoute(
                          type: .income,
                          id: widget.activity.id,
                          form: widget.activity.toTransactionForm(),
                          batch: batch,
                        ).push<int>(context);
                        if (result != null && context.mounted) {
                          context.router.replace(
                            ActivityDetailRoute(id: result),
                          );
                        }
                      case .transfer:
                        final result = await TransferRoute(
                          id: widget.activity.id,
                          form: widget.activity.toTransferForm(),
                        ).push<int>(context);
                        if (result != null && context.mounted) {
                          context.router.replace(
                            ActivityDetailRoute(id: result),
                          );
                        }
                    }
                  },
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        color: themeData.colorScheme.onPrimary,
                      ),
                      Text('Perbaiki'),
                    ],
                  ),
                ),
              OutlinedButton(
                onPressed: () async {
                  final isConfirmed = await showDialog<bool>(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) {
                      return DompetDialog(
                        title:
                            'Hapus ${widget.activity.type.label.toLowerCase()} ini?',
                        subtitle:
                            'Saldo dan riwayat terkait akan diperbarui sesuai perubahan ini.',
                        onCancel: () {
                          Navigator.pop(context, false);
                        },
                        onConfirm: () {
                          Navigator.pop(context, true);
                        },
                        confirmationText: 'Hapus',
                      );
                    },
                  );

                  if (isConfirmed != true || !context.mounted) return;

                  await context.read<ActivityDetailCubit>().deleteActivity(
                    widget.activity.id,
                  );
                  if (!context.mounted) return;
                  context.read<ActivitySignalCubit>().created();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: themeData.colorScheme.error,
                ),
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      Icons.delete_forever_rounded,
                      color: themeData.colorScheme.error,
                    ),
                    Text('Hapus'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(top: 0, bottom: 24),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(
                          widget.activity.type.label,
                          style: themeData.textTheme.labelMedium?.copyWith(
                            color: switch (widget.activity.type) {
                              .billPayment => themeData.colorScheme.error,
                              .expense => themeData.colorScheme.error,
                              .income => themeData.colorScheme.tertiary,
                              _ => themeData.colorScheme.primary,
                            },
                          ),
                        ),
                        avatar: Icon(
                          widget.activity.type.icon,
                          size: 16,
                          color: switch (widget.activity.type) {
                            .billPayment => themeData.colorScheme.error,
                            .expense => themeData.colorScheme.error,
                            .income => themeData.colorScheme.tertiary,
                            _ => themeData.colorScheme.primary,
                          },
                        ),
                        backgroundColor: switch (widget.activity.type) {
                          .billPayment =>
                            themeData.colorScheme.error.withValues(alpha: 0.15),
                          .expense => themeData.colorScheme.error.withValues(
                            alpha: 0.15,
                          ),
                          .income => themeData.colorScheme.tertiary.withValues(
                            alpha: 0.15,
                          ),
                          _ => themeData.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                        },
                      ),
                      Text(
                        displayAmount,
                        style: themeData.textTheme.displaySmall?.copyWith(
                          fontWeight: .w700,
                          color: switch (widget.activity.type) {
                            .billPayment => themeData.colorScheme.error,
                            .expense => themeData.colorScheme.error,
                            .income => themeData.colorScheme.tertiary,
                            .adjustment =>
                              widget.activity.assetLines.first.debitAmount > 0
                                  ? themeData.colorScheme.tertiary
                                  : themeData.colorScheme.error,
                            _ => themeData.colorScheme.onSurface,
                          },
                        ),
                      ),
                      Text(
                        widget.activity.entryDate.dateTime.format(
                          includeDay: true,
                          includeTime: true,
                        ),
                        style: themeData.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                switch (widget.activity.type) {
                  .income ||
                  .expense => _TransactionLine(activity: widget.activity),
                  .transfer => _TransferLine(activity: widget.activity),
                  .adjustment => _BalanceAdjustmentLine(
                    activity: widget.activity,
                  ),
                  _ => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .stretch,
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: Text(
                                  'Kategori',
                                  style: themeData.textTheme.labelMedium,
                                ),
                              ),
                              Text(widget.activity.lines.first.accountName),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .stretch,
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: Text(
                                  'Dompet',
                                  style: themeData.textTheme.labelMedium,
                                ),
                              ),
                              Text(widget.activity.lines[1].accountName),
                            ],
                          ),
                          if (widget.activity.description != null) ...[
                            SizedBox(height: 16),
                            Column(
                              mainAxisSize: .min,
                              crossAxisAlignment: .stretch,
                              children: [
                                Opacity(
                                  opacity: 0.5,
                                  child: Text(
                                    'Keterangan',
                                    style: themeData.textTheme.labelMedium,
                                  ),
                                ),
                                Text(widget.activity.description!),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionLine extends StatelessWidget {
  final JournalEntry activity;
  const _TransactionLine({required this.activity});

  JournalLine get _assetLine => activity.assetLines.first;

  List<JournalLine> get _categoryLines => activity.otherLines;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            if (_categoryLines.isNotEmpty)
              Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: 4,
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      'Kategori',
                      style: themeData.textTheme.labelMedium,
                    ),
                  ),
                  Column(
                    mainAxisSize: .min,
                    children: List.generate(_categoryLines.length, (index) {
                      final category = _categoryLines[index];
                      return Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .stretch,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              Expanded(child: Text(category.accountName)),
                              if (_categoryLines.length > 1)
                                Expanded(
                                  child: Text(
                                    category.amount.currency,
                                    textAlign: .end,
                                  ),
                                ),
                            ],
                          ),
                          if (category.note != null)
                            Text(
                              'Catatan: "${category.note}"',
                              style: themeData.textTheme.bodySmall?.copyWith(
                                color: themeData.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                fontStyle: .italic,
                              ),
                            ),
                          if (index < _categoryLines.length - 1) Divider(),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              spacing: 4,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Text('Dompet', style: themeData.textTheme.labelMedium),
                ),
                Text(_assetLine.accountName),
              ],
            ),
            if (activity.description != null) ...[
              Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: 4,
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      'Keterangan',
                      style: themeData.textTheme.labelMedium,
                    ),
                  ),
                  Text(activity.description!),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TransferLine extends StatelessWidget {
  final JournalEntry activity;
  const _TransferLine({required this.activity});

  JournalLine get _sourceLine => activity.assetLines
      .where((line) => line.creditAmount > 0 && line.debitAmount == 0)
      .first;

  JournalLine get _destinationLine => activity.assetLines
      .where((line) => line.creditAmount == 0 && line.debitAmount > 0)
      .first;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              spacing: 4,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Text('Dari', style: themeData.textTheme.labelMedium),
                ),
                Text(_sourceLine.accountName),
              ],
            ),
            Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              spacing: 4,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Text('Ke', style: themeData.textTheme.labelMedium),
                ),
                Text(_destinationLine.accountName),
              ],
            ),
            if (activity.description != null) ...[
              Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: 4,
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      'Keterangan',
                      style: themeData.textTheme.labelMedium,
                    ),
                  ),
                  Text(activity.description!),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BalanceAdjustmentLine extends StatelessWidget {
  final JournalEntry activity;
  const _BalanceAdjustmentLine({required this.activity});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    if (activity.balanceMeta == null) {
      return Center(
        child: Text(
          'Terjadi kesalahan data',
          style: TextStyle(color: themeData.colorScheme.error),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              spacing: 4,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    'Saldo Sebelumnya',
                    style: themeData.textTheme.labelMedium,
                  ),
                ),
                Text(activity.balanceMeta!.previousBalance.currency),
              ],
            ),
            Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              spacing: 4,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    'Saldo Sebenarnya',
                    style: themeData.textTheme.labelMedium,
                  ),
                ),
                Text(activity.balanceMeta!.currentBalance.currency),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
