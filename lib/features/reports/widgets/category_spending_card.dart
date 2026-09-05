import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/reports/models/category_spending.dart';
import 'package:flutter/material.dart';

/// Breakdown pengeluaran per kategori: bar horizontal + persen.
///
/// Sengaja bukan pie chart: lebih nyaman dibaca saat kategorinya banyak.
/// Menampilkan 6 teratas + agregat "Lainnya".
class CategorySpendingCard extends StatelessWidget {
  const CategorySpendingCard({super.key, required this.items});

  final List<CategorySpending> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Text(
              'Pengeluaran per kategori',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (items.isEmpty)
              Text(
                'Belum ada pengeluaran bulan ini.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              )
            else
              ...CategorySpending.topWithOthers(items).map(
                (item) => _CategoryRow(item: item),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.item});

  final CategorySpending item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: '${item.name}: ${item.amount.currency}',
      triggerMode: TooltipTriggerMode.tap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                item.amount.compactCurrency,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 48,
                child: Text(
                  '${item.percentage.round()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (item.percentage / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor:
                  theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
