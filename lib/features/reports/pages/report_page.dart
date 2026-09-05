import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/reports/cubits/report_cubit.dart';
import 'package:dompet_app/features/reports/models/report_insight.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/widgets/budget_section_card.dart';
import 'package:dompet_app/features/reports/widgets/cashflow_bar.dart';
import 'package:dompet_app/features/reports/widgets/category_spending_card.dart';
import 'package:dompet_app/features/reports/widgets/comparison_banner.dart';
import 'package:dompet_app/features/reports/widgets/insight_card.dart';
import 'package:dompet_app/features/reports/widgets/monthly_summary_cards.dart';
import 'package:dompet_app/features/reports/widgets/saving_allocation_card.dart';
import 'package:dompet_app/features/reports/widgets/trend_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            MonthlySummaryCards(summary: summary),
            ComparisonBanner(comparison: comparison),
            InsightCard(
              insights: ReportInsight.generate(
                current: summary,
                comparison: comparison,
                trend: state.trend,
                categories: state.categorySpending,
              ),
            ),
            SavingAllocationCard(summary: summary),
            CashflowBar(summary: summary),
            CategorySpendingCard(items: state.categorySpending),
            BudgetSectionCard(items: state.budgetSpending),
            TrendCard(trend: state.trend),
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
