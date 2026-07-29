import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/activities/extensions/activity.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:flutter/material.dart';

class ActivityItemTile extends StatelessWidget {
  final JournalEntry activity;
  final bool hideDate;
  final int? accountId;
  const ActivityItemTile({
    super.key,
    required this.activity,
    this.accountId,
    this.hideDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    Color color = themeData.colorScheme.onSurface;

    if (activity.displayAmount(accountId: accountId).startsWith('+')) {
      color = themeData.colorScheme.tertiary;
    }

    if (activity.displayAmount(accountId: accountId).startsWith('-')) {
      color = themeData.colorScheme.error;
    }

    return Card(
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: () {
          ActivityDetailRoute(id: activity.id).push(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Row(
                spacing: 4,
                children: [
                  Expanded(
                    child: Text(
                      activity.title(accountId: accountId),
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        fontWeight: .w600,
                      ),
                      overflow: .ellipsis,
                    ),
                  ),
                  Text(
                    activity.displayAmount(accountId: accountId),
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
              Text(
                activity.activityData(hideDate: hideDate, accountId: accountId),
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                overflow: .ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
