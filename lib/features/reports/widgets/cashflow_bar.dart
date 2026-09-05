import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Bar perbandingan pemasukan vs pengeluaran bulan berjalan.
///
/// Sengaja minimal: dua bar vertikal, tanpa pie chart.
class CashflowBar extends StatelessWidget {
  const CashflowBar({super.key, required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxValue = [summary.income, summary.expense, 1].reduce(
      (a, b) => a > b ? a : b,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Text(
              'Arus kas bulan ini',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: maxValue.toDouble() * 1.2,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          return switch (value.toInt()) {
                            0 => const Text('Masuk'),
                            1 => const Text('Keluar'),
                            _ => const SizedBox.shrink(),
                          };
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, _, rod, _) {
                        final label = group.x == 0 ? 'Pemasukan' : 'Pengeluaran';
                        // Tooltip menampilkan nominal asli (tanpa faktor 1.2).
                        final raw = group.x == 0
                            ? summary.income
                            : summary.expense;
                        return BarTooltipItem(
                          '$label\n${raw.currency}',
                          const TextStyle(fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: summary.income.toDouble(),
                          color: theme.colorScheme.tertiary,
                          width: 48,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: summary.expense.toDouble(),
                          color: theme.colorScheme.error,
                          width: 48,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '${summary.transactionCount} transaksi bulan ini',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
