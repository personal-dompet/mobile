import 'package:freezed_annotation/freezed_annotation.dart';

/// Status pocket tabungan. `close` manual oleh user, tidak otomatis
/// saat target tercapai.
enum SavingStatus {
  @JsonValue('ACTIVE')
  active('ACTIVE'),
  @JsonValue('COMPLETED')
  completed('COMPLETED');

  final String value;

  const SavingStatus(this.value);

  static List<String> get allValues {
    return SavingStatus.values.map((e) => e.value).toList();
  }
}
