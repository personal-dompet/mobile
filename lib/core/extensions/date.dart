import 'package:intl/intl.dart';

extension EpochSecond on DateTime {
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999, 999);

  DateTime get startOfMonth => DateTime(year, month, 1);

  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  String get dayName => DateFormat('EEEE', 'id').format(this);

  String format({
    bool includeDay = false,
    bool hideDate = false,
    bool includeTime = false,
  }) {
    final List<String> patterns = ['d', 'MMMM yyyy'];
    if (hideDate) {
      patterns.removeAt(0);
    }
    if (includeDay) {
      patterns.insert(0, 'EEEE,');
    }
    if (includeTime) {
      patterns.add('• HH:mm');
    }
    return DateFormat(patterns.join(' '), 'id').format(this);
  }

  String formatTime({
    bool includeSeconds = false,
    bool includeMinutes = false,
  }) {
    final List<String> patterns = ['HH'];
    if (includeMinutes) {
      patterns.add('mm');
    }
    if (includeSeconds) {
      patterns.add('ss');
    }
    return DateFormat(patterns.join(':'), 'id').format(this);
  }
}
