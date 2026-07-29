import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/activities/models/activity_list_item.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';

extension ListActivity on List<JournalEntry> {
  List<ActivityListItem> get groupedItems {
    final result = <ActivityListItem>[];
    DateTime? currentDate;

    for (final activity in this) {
      final dateTime = activity.entryDate.dateTime;
      final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (currentDate != date) {
        if (currentDate != null) result.add(ActivitySpacing(16));
        currentDate = date;
        result.add(ActivityDateHeader(date));
        result.add(ActivitySpacing(8));
      } else {
        result.add(ActivitySpacing(8));
      }

      result.add(ActivityItem(activity));
    }

    return result;
  }
}
