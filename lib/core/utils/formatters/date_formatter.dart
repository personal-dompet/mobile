import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatRelative(DateTime date, {DateTime? fromDate}) {
    final pivot = fromDate ?? DateTime.now();

    final difference = pivot.difference(date).inDays;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    if (difference == 0) {
      // Today
      return 'Today at $hour:$minute';
    } else if (difference == 1) {
      // Yesterday
      return 'Yesterday at $hour:$minute';
    } else if (difference == -1) {
      // Yesterday
      return 'Tomorrow at $hour:$minute';
    } else if (difference > 0 && difference < 7) {
      // Within a week
      return '$difference days ago at $hour:$minute';
    } else if (difference < 0 && difference > -7) {
      // Within a week in the future
      return 'In ${difference.abs()} days at $hour:$minute';
    }
    final formatter = DateFormat('dd MMMM yyyy HH:mm');
    return formatter.format(date);
  }
}
