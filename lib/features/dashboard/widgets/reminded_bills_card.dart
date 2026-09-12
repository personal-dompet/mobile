import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/dashboard/cubits/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Ringkasan tagihan yang sudah masuk waktu pengingat (count saja).
/// Dua baris: hampir jatuh tempo vs lewat jatuh tempo.
/// Sembunyi total bila keduanya 0/null — parent juga mengecualikannya
/// dari children agar tak kena spacing Column.
class RemindedBillsCard extends StatelessWidget {
  const RemindedBillsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final due = state.remindedDueCount ?? 0;
        final overdue = state.remindedOverdueCount ?? 0;
        if (due <= 0 && overdue <= 0) return const SizedBox.shrink();
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.router.push(const BillRoute()),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                spacing: 12,
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          'Tagihan diingatkan',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (due > 0)
                          Text(
                            '$due hampir jatuh tempo',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        if (overdue > 0)
                          Text(
                            '$overdue lewat jatuh tempo',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
