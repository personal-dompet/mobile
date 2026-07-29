import 'package:dompet_app/features/journals/models/journal_entry.dart';

sealed class ActivityListItem {}

class ActivityDateHeader extends ActivityListItem {
  final DateTime date;
  ActivityDateHeader(this.date);
}

class ActivityItem extends ActivityListItem {
  final JournalEntry activity;
  ActivityItem(this.activity);
}

class ActivitySpacing extends ActivityListItem {
  final double height;
  ActivitySpacing(this.height);
}
