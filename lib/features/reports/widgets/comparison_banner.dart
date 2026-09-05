import 'package:dompet_app/features/reports/models/period_comparison.dart';
import 'package:flutter/material.dart';

/// Banner perbandingan vs bulan lalu, mis. "Pengeluaran turun 8% dibanding bulan lalu".
///
/// Netral (abu-abu) bila tidak ada baseline bulan lalu ATAU angkanya sama
/// persis — "sama" bukan kabar buruk sehingga tidak memakai warna error.
class ComparisonBanner extends StatelessWidget {
  const ComparisonBanner({super.key, required this.comparison});

  final PeriodComparison comparison;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final change = comparison.expenseChangePercent;
    final label = comparison.expenseLabel;
    final isNeutral = label == null || change == 0;
    final isDown = (change ?? 0) < 0;

    final text = label == null
        ? 'Belum ada data bulan lalu untuk perbandingan.'
        : (change == 0
              ? 'Pengeluaran sama seperti bulan lalu.'
              : 'Pengeluaran $label dibanding bulan lalu.');

    return Card(
      color: isNeutral
          ? theme.colorScheme.surfaceContainerHighest
          : (isDown
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.errorContainer),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          spacing: 12,
          children: [
            Icon(
              label == null
                  ? Icons.info_outline_rounded
                  : (change == 0
                        ? Icons.trending_flat_rounded
                        : (isDown
                              ? Icons.trending_down_rounded
                              : Icons.trending_up_rounded)),
            ),
            Expanded(
              child: Text(text, style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
