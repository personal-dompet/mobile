import 'dart:math';

import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';

class AssetDetail {
  final Account account;
  final List<JournalEntry> recentActivities;

  AssetDetail({required this.account, required this.recentActivities});

  DateTime? get latestActivityDate {
    if (recentActivities.isEmpty) return null;
    return recentActivities
        .fold(
          0,
          (previousValue, activity) => max(previousValue, activity.entryDate),
        )
        .dateTime;
  }
}
