import 'dart:convert';

class BackupMeta {
  final DateTime updatedAt;
  final int sizeBytes;
  final int dbVersion;
  final String fileName;

  const BackupMeta({
    required this.updatedAt,
    required this.sizeBytes,
    this.dbVersion = 1,
    this.fileName = 'dompet_backup.db',
  });

  Map<String, dynamic> toJson() => {
        'updatedAt': updatedAt.toIso8601String(),
        'sizeBytes': sizeBytes,
        'dbVersion': dbVersion,
        'fileName': fileName,
      };

  factory BackupMeta.fromJson(Map<String, dynamic> json) {
    return BackupMeta(
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sizeBytes: json['sizeBytes'] as int,
      dbVersion: (json['dbVersion'] as int?) ?? 1,
      fileName: (json['fileName'] as String?) ?? 'dompet_backup.db',
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory BackupMeta.fromJsonString(String source) =>
      BackupMeta.fromJson(jsonDecode(source) as Map<String, dynamic>);

  BackupMeta copyWith({
    DateTime? updatedAt,
    int? sizeBytes,
    int? dbVersion,
    String? fileName,
  }) {
    return BackupMeta(
      updatedAt: updatedAt ?? this.updatedAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      dbVersion: dbVersion ?? this.dbVersion,
      fileName: fileName ?? this.fileName,
    );
  }
}
