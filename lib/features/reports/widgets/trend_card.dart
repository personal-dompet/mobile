import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Tren pemasukan vs pengeluaran beberapa bulan terakhir.
///
/// Dua garis (masuk/keluar) menjawab "pengeluaran saya naik atau turun?"
/// sekilas tanpa perlu membaca angka satu per satu.
class TrendCard extends StatelessWidget {
  const TrendCard({super.key, required this.trend});

  final List<MonthlySummary> trend;

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
              'Tren ${trend.length} bulan terakhir',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            _Legend(theme: theme),
            if (_isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Belum ada data tren.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              SizedBox(height: 200, child: _Chart(trend: trend, theme: theme)),
          ],
        ),
      ),
    );
  }

  bool get _isEmpty =>
      trend.every((e) => e.income == 0 && e.expense == 0);
}

class _Legend extends StatelessWidget {
  const _Legend({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        _LegendItem(
          color: theme.colorScheme.tertiary,
          label: 'Masuk',
        ),
        _LegendItem(color: theme.colorScheme.error, label: 'Keluar'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.trend, required this.theme});

  final List<MonthlySummary> trend;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final maxValue = trend
        .expand((e) => [e.income, e.expense])
        .fold<int>(1, (a, b) => a > b ? a : b);
    final maxY = maxValue.toDouble() * 1.2;

    FlSpot spot(int index, int value) => FlSpot(index.toDouble(), value.toDouble());

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (trend.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: maxY / 4,
              getTitlesWidget: (value, _) => Text(
                (value.toInt()).compactCurrency,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index < 0 || index >= trend.length) {
                  return const SizedBox.shrink();
                }
                final period = trend[index].period;
                final label = DateFormat(
                  'MMM',
                  'id',
                ).format(DateTime(period.year, period.month, 1));
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final summary = trend[spot.x.toInt()];
                final isIncome = spot.barIndex == 0;
                final amount = isIncome ? summary.income : summary.expense;
                return LineTooltipItem(
                  '${isIncome ? 'Masuk' : 'Keluar'}\n${amount.currency}',
                  const TextStyle(fontWeight: FontWeight.w600),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < trend.length; i++)
                spot(i, trend[i].income),
            ],
            color: theme.colorScheme.tertiary,
            barWidth: 2.5,
            isCurved: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: [
              for (var i = 0; i < trend.length; i++)
                spot(i, trend[i].expense),
            ],
            color: theme.colorScheme.error,
            barWidth: 2.5,
            isCurved: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
