import 'package:intl/intl.dart';

class TimestampModel {
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TimestampModel({
    required this.createdAt,
    this.updatedAt,
  });

  factory TimestampModel.fromJson(Map<String, dynamic> json) {
    return TimestampModel(
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] * 1000),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] * 1000)
          : null,
    );
  }

  String get formattedCreatedAt => DateFormat('dd MMMM yyyy').format(createdAt);
  String? get formattedUpdatedAt =>
      updatedAt != null ? DateFormat('dd MMMM yyyy').format(updatedAt!) : null;
  String get formattedCreatedAtTime => DateFormat('HH:mm').format(createdAt);
  String? get formattedUpdatedAtTime =>
      updatedAt != null ? DateFormat('HH:mm').format(updatedAt!) : null;

  String get relativeFormattedCreatedAt {
    final now = DateTime.now();

    final difference = now.difference(createdAt).inDays;
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');

    if (difference == 0) {
      // Today
      return 'Today at $hour:$minute';
    } else if (difference == 1) {
      // Yesterday
      return 'Yesterday at $hour:$minute';
    } else if (difference < 7) {
      // Within a week
      return '$difference days ago at $hour:$minute';
    } else {
      // More than a week
      final formatter = DateFormat('dd MMMM yyyy HH:mm');
      return formatter.format(createdAt);
    }
  }
}
