import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/reports/models/budget_spending.dart';
import 'package:flutter/material.dart';

/// Anggaran vs aktual: "apakah saya masih sesuai rencana?"
/// dilengkapi konteks historis "naik/turun X% dibanding bulan lalu".
///
/// Disembunyikan bila tidak ada anggaran pada bulan laporan —
/// reporting tidak menduplikasi halaman Anggaran, hanya memberi
/// konteks pola di atasnya.
class BudgetSectionCard extends StatelessWidget {
  const BudgetSectionCard({super.key, required this.items});

  final List<BudgetSpending> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Text(
              'Anggaran bulan ini',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            ...items.map((item) => _BudgetRow(item: item)),
          ],
        ),
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow({required this.item});

  final BudgetSpending item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final momLabel = item.momLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.categoryName,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Tooltip(
              message:
                  '${item.spent.currency} / ${item.budgetAmount.currency}',
              triggerMode: TooltipTriggerMode.tap,
              child: Text(
                '${item.spent.compactCurrency} / ${item.budgetAmount.compactCurrency}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: item.isOver ? theme.colorScheme.error : null,
                ),
              ),
            ),
            SizedBox(
              width: 48,
              child: Text(
                '${item.usagePercent.round()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: item.isOver
                      ? theme.colorScheme.error
                      : theme.colorScheme.outline,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (item.usagePercent / 100).clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              item.isOver
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
        ),
        if (momLabel != null)
          Text(
            momLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
      ],
    );
  }
}
