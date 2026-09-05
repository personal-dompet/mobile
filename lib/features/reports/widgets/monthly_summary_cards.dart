import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:flutter/material.dart';

/// Tiga angka besar: pemasukan, pengeluaran, selisih.
class MonthlySummaryCards extends StatelessWidget {
  const MonthlySummaryCards({super.key, required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: _AmountCard(
                label: 'Pemasukan',
                amount: summary.income,
                color: theme.colorScheme.tertiary,
              ),
            ),
            Expanded(
              child: _AmountCard(
                label: 'Pengeluaran',
                amount: summary.expense,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        _AmountCard(
          label: 'Selisih',
          amount: summary.net,
          color: summary.net >= 0
              ? theme.colorScheme.primary
              : theme.colorScheme.error,
          prefix: summary.net > 0 ? '+' : '',
        ),
      ],
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.label,
    required this.amount,
    required this.color,
    this.prefix = '',
  });

  final String label;
  final int amount;
  final Color color;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: '$prefix${amount.currency}',
      triggerMode: TooltipTriggerMode.tap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(
                '$prefix${amount.compactCurrency}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
