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
}
