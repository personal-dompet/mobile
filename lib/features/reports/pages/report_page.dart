import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/reports/cubits/report_cubit.dart';
import 'package:dompet_app/features/reports/models/budget_spending.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:dompet_app/features/reports/models/period_comparison.dart';
import 'package:dompet_app/features/reports/models/report_insight.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/widgets/category_spending_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportCubit>()..loadCurrentMonth(),
      child: Builder(
        builder: (providedContext) {
          return BlocListener<ActivitySignalCubit, int>(
            listener: (_, _) {
              providedContext.read<ReportCubit>().refresh();
            },
            child: Scaffold(
              appBar: AppBar(title: const Text('Laporan')),
              body: SafeArea(
                child: BlocBuilder<ReportCubit, ReportState>(
                  builder: (context, state) {
                    // Spinner penuh hanya saat buka pertama (belum ada data).
                    // Ganti bulan memakai data lama + progres tipis (refreshing),
                    // sehingga tidak ada kedip satu layar.
                    return switch (state.status) {
                      ReportStatus.loading || ReportStatus.initial
                          when state.summary == null =>
                        const Padding(
                          padding: EdgeInsets.only(top: 64),
                          child: SpinnerLoading(),
                        ),
                      ReportStatus.error when state.summary == null => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 12,
                            children: [
                              Text(
                                state.errorMessage ?? 'Gagal memuat laporan',
                                textAlign: TextAlign.center,
                              ),
                              FilledButton(
                                onPressed: () =>
                                    context.read<ReportCubit>().refresh(),
                                child: const Text('Coba lagi'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _ => _LoadedBody(
                        state: state,
                        isRefreshing: state.status == ReportStatus.refreshing,
                      ),
                    };
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state, this.isRefreshing = false});

  final ReportState state;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final summary = state.summary;
    final comparison = state.comparison;
    if (summary == null || comparison == null) {
      return const Center(child: Text('Belum ada data bulan ini'));
    }
    return RefreshIndicator(
      onRefresh: () => context.read<ReportCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ).copyWith(bottom: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            if (isRefreshing)
              const LinearProgressIndicator(minHeight: 2)
            else
              const SizedBox(height: 2),
            _PeriodSelector(period: state.period),
            _MonthlySummaryCards(summary: summary),
            _ComparisonBanner(comparison: comparison),
            _InsightCard(
              insights: ReportInsight.generate(
                current: summary,
                comparison: comparison,
                trend: state.trend,
                categories: state.categorySpending,
              ),
            ),
            _SavingAllocationCard(summary: summary),
            _CashflowBar(summary: summary),
            CategorySpendingCard(items: state.categorySpending),
            // FIX-06: card pemasukan per kategori, gaya sama dengan expense.
            CategorySpendingCard(
              items: state.categoryIncome,
              title: 'Pemasukan per kategori',
              emptyText: 'Belum ada pemasukan bulan ini.',
            ),
            _BudgetSectionCard(items: state.budgetSpending),
            _TrendCard(trend: state.trend),
          ],
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.period});

  final ReportPeriod period;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          tooltip: 'Bulan sebelumnya',
          onPressed: () => context.read<ReportCubit>().loadMonth(
            ReportPeriod(year: period.year, month: period.month).previous,
          ),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            period.label(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          tooltip: 'Bulan berikutnya',
          onPressed: () {
            final current = ReportPeriod.currentMonth();
            if (period == current) return;
            final next = period.month == 12
                ? ReportPeriod(year: period.year + 1, month: 1)
                : ReportPeriod(year: period.year, month: period.month + 1);
            // Jangan melompat ke masa depan.
            if (next.year > current.year ||
                (next.year == current.year && next.month > current.month)) {
              return;
            }
            context.read<ReportCubit>().loadMonth(next);
          },
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
// --- from monthly_summary_cards.dart ---
/// Tiga angka besar: pemasukan, pengeluaran, selisih.
class _MonthlySummaryCards extends StatelessWidget {
  const _MonthlySummaryCards({ required this.summary});

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
// --- from comparison_banner.dart ---
/// Banner perbandingan vs bulan lalu, mis. "Pengeluaran turun 8% dibanding bulan lalu".
///
/// Netral (abu-abu) bila tidak ada baseline bulan lalu ATAU angkanya sama
/// persis — "sama" bukan kabar buruk sehingga tidak memakai warna error.
class _ComparisonBanner extends StatelessWidget {
  const _ComparisonBanner({ required this.comparison});

  final PeriodComparison comparison;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final change = comparison.expenseChangePercent;
    final label = comparison.expenseLabel;
    final isNeutral = label == null || change == 0;
    final isDown = (change ?? 0) < 0;

    final text = label == null
        ? 'Belum ada data bulan lalu untuk dibandingkan.'
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
// --- from insight_card.dart ---
/// Daftar insight otomatis: ringkasan "pintar" di atas angka laporan.
///
/// Murni presentasi — logika aturan ada di [ReportInsight.generate].
class _InsightCard extends StatelessWidget {
  const _InsightCard({ required this.insights});

  final List<ReportInsight> insights;

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
              'Insight',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            ...insights.map((insight) => _InsightRow(insight: insight)),
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.insight});

  final ReportInsight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color) = switch (insight.kind) {
      InsightKind.positive => (
        Icons.check_circle_rounded,
        theme.colorScheme.tertiary,
      ),
      InsightKind.negative => (
        Icons.warning_rounded,
        theme.colorScheme.error,
      ),
      InsightKind.info => (Icons.info_rounded, theme.colorScheme.primary),
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Icon(icon, color: color, size: 20),
        Expanded(
          child: Text(insight.message, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
// --- from saving_allocation_card.dart ---
/// Baris "Dialokasikan ke target": alokasi ke target − penarikan kembali.
///
/// BUKAN pengeluaran — uangnya masih milik pengguna, hanya dipindahkan ke
/// target non-cair (keluar dari Total Uang Beranda). Kartu ini menjelaskan
/// selisih antara selisih pemasukan-pengeluaran laporan dan perubahan
/// uang yang tersedia.
///
/// Disembunyikan (SizedBox.shrink) bila tidak ada aktivitas alokasi
/// pada periode ini agar UI tetap minimal.
class _SavingAllocationCard extends StatelessWidget {
  const _SavingAllocationCard({ required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    if (!summary.hasSavingActivity) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final parts = [
      'Alokasi ${summary.savingTopup.compactCurrency}',
      'Ditarik kembali ${summary.savingWithdraw.compactCurrency}',
      if (summary.savingSpend > 0)
        'Belanja dari target ${summary.savingSpend.compactCurrency}',
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Row(
              spacing: 8,
              children: [
                Icon(
                  Icons.savings_rounded,
                  color: theme.colorScheme.primary,
                ),
                Text(
                  'Dialokasikan ke target',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Tooltip(
                  message: summary.netSaving.currency,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Text(
                    summary.netSaving.compactCurrency,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              parts.join(' • '),
              style: theme.textTheme.bodySmall,
            ),
            Text(
              'Uang yang tersedia berubah ${summary.liquidChange.compactCurrency}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// --- from cashflow_bar.dart ---
/// Bar perbandingan pemasukan vs pengeluaran bulan berjalan.
///
/// Sengaja minimal: dua bar vertikal, tanpa pie chart.
class _CashflowBar extends StatelessWidget {
  const _CashflowBar({ required this.summary});

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
// --- from budget_section_card.dart ---
/// Anggaran vs aktual: "apakah saya masih sesuai rencana?"
/// dilengkapi konteks historis "naik/turun X% dibanding bulan lalu".
///
/// Disembunyikan bila tidak ada anggaran pada bulan laporan —
/// reporting tidak menduplikasi halaman Anggaran, hanya memberi
/// konteks pola di atasnya.
class _BudgetSectionCard extends StatelessWidget {
  const _BudgetSectionCard({ required this.items});

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
// --- from trend_card.dart ---
/// Tren pemasukan vs pengeluaran beberapa bulan terakhir.
///
/// Dua garis (masuk/keluar) menjawab "pengeluaran saya naik atau turun?"
/// sekilas tanpa perlu membaca angka satu per satu.
class _TrendCard extends StatelessWidget {
  const _TrendCard({ required this.trend});

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