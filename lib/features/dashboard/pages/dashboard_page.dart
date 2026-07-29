import 'package:auto_route/annotations.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/dashboard/cubits/dashboard_cubit.dart';
import 'package:dompet_app/features/dashboard/widgets/balance_card.dart';
import 'package:dompet_app/features/dashboard/widgets/quick_action_section.dart';
import 'package:dompet_app/features/dashboard/widgets/recent_activity_section.dart';
import 'package:dompet_app/features/dashboard/widgets/today_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardCubit>()..init(),
      child: Builder(
        builder: (providedContext) {
          return MultiBlocListener(
            listeners: [
              BlocListener<ActivitySignalCubit, int>(
                listener: (_, _) {
                  providedContext.read<DashboardCubit>().init();
                },
              ),
              BlocListener<AccountSignalCubit, int>(
                listener: (context, state) {
                  providedContext.read<DashboardCubit>().init();
                },
              ),
            ],
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).copyWith(bottom: 36),
                child: Column(
                  crossAxisAlignment: .stretch,
                  spacing: 24,
                  children: [
                    BalanceCard(),

                    QuickActionSection(),

                    Column(
                      mainAxisSize: .min,
                      spacing: 16,
                      crossAxisAlignment: .stretch,
                      children: [TodaySummary(), RecentActivitySection()],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
