import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/reports/cubits/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Kartu ringkasan bulan ini di Beranda.
///
/// Entry point laporan tanpa menambah bottom navigation:
/// ketuk kartu / tombol untuk membuka [ReportRoute] penuh.
class MonthlyReportCard extends StatelessWidget {
  const MonthlyReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => getIt<ReportCubit>()..loadCurrentMonth(),
      child: Builder(
        builder: (providedContext) {
          return BlocListener<ActivitySignalCubit, int>(
            listener: (_, _) {
              providedContext.read<ReportCubit>().refresh();
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.router.push(const ReportRoute()),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BlocBuilder<ReportCubit, ReportState>(
                    builder: (context, state) {
                      final summary = state.summary;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.assessment_rounded),
                              const SizedBox(width: 8),
                              Text(
                                'Ringkasan bulan ini',
                                style: theme.textTheme.titleMedium,
                              ),
                              const Spacer(),
                              Text(
                                'Lihat laporan',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          if (summary == null)
                            Text(
                              'Memuat...',
                              style: theme.textTheme.bodyMedium,
                            )
                          else
                            Row(
                              spacing: 8,
                              children: [
                                _IconAmount(
                                  icon: Icons.trending_up_rounded,
                                  iconColor: theme.colorScheme.tertiary,
                                  amount: summary.income,
                                ),
                                Text(
                                  '•',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                _IconAmount(
                                  icon: Icons.trending_down_rounded,
                                  iconColor: theme.colorScheme.error,
                                  amount: summary.expense,
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _IconAmount extends StatelessWidget {
  const _IconAmount({
    required this.icon,
    required this.iconColor,
    required this.amount,
  });

  final IconData icon;
  final Color iconColor;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: amount.currency,
      triggerMode: TooltipTriggerMode.tap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, color: iconColor, size: 20),
          Text(amount.compactCurrency, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
