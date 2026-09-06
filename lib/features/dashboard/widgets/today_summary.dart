import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/dashboard/cubits/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodaySummary extends StatelessWidget {
  const TodaySummary({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) {
        return previous.summaryStatus != current.summaryStatus;
      },
      builder: (context, state) {
        final isEmpty =
            state.summary.expense == 0 && state.summary.income == 0;
        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          spacing: 8,
          children: [
            Text(
              'Ringkasan Hari Ini',
              style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: .w700),
            ),
            if (isEmpty)
              Text(
                'Belum ada transaksi hari ini.',
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Tooltip(
                    message: state.summary.expense.currency,
                    textStyle: TextStyle(color: themeData.colorScheme.error),
                    triggerMode: .tap,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Pengeluaran',
                              style: themeData.textTheme.bodySmall,
                            ),
                            Text(
                              state.summary.expense.compactCurrency,
                              style: themeData.textTheme.titleLarge?.copyWith(
                                color: themeData.colorScheme.error,
                                fontWeight: .w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Tooltip(
                    message: state.summary.income.currency,
                    textStyle: TextStyle(color: themeData.colorScheme.tertiary),
                    triggerMode: .tap,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Pemasukan',
                              style: themeData.textTheme.bodySmall,
                            ),
                            Text(
                              state.summary.income.compactCurrency,
                              style: themeData.textTheme.titleLarge?.copyWith(
                                color: themeData.colorScheme.tertiary,
                                fontWeight: .w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
