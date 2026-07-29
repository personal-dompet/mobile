import 'package:dompet_app/features/activities/widgets/activity_item_tile.dart';
import 'package:dompet_app/features/activities/widgets/empty_activities.dart';
import 'package:dompet_app/features/dashboard/cubits/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: .stretch,
      spacing: 8,
      children: [
        Text(
          'Aktivitas Terbaru',
          style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: .w700),
        ),
        BlocBuilder<DashboardCubit, DashboardState>(
          buildWhen: (previous, current) {
            return previous.recentActivitiesStatus !=
                current.recentActivitiesStatus;
          },
          builder: (context, state) {
            if (state.recentActivitiesStatus == .loaded &&
                state.recentActivities.isEmpty) {
              return EmptyActivities();
            }

            if (state.recentActivitiesStatus == .loaded ||
                (state.recentActivitiesStatus == .loading &&
                    state.recentActivities.isNotEmpty)) {
              return Column(
                mainAxisSize: .min,
                spacing: 12,
                children: List.generate(state.recentActivities.length, (index) {
                  final activity = state.recentActivities[index];
                  return ActivityItemTile(activity: activity);
                }),
              );
            }

            if (state.recentActivitiesStatus == .loading) {
              return CircularProgressIndicator();
            }

            if (state.recentActivitiesStatus == .error) {
              return Text(
                state.recentActivitiesError ?? 'Terjadi kesalahan',
                style: TextStyle(color: themeData.colorScheme.error),
                textAlign: .center,
              );
            }

            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
