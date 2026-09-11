import 'package:freezed_annotation/freezed_annotation.dart';

/// Status pocket tabungan. `close` manual oleh user, tidak otomatis
/// saat target tercapai.
enum SavingStatus {
  @JsonValue('active')
  active('active'),
  @JsonValue('completed')
  completed('completed');

  final String value;

  const SavingStatus(this.value);

  static List<String> get allValues {
    return SavingStatus.values.map((e) => e.value).toList();
  }
}
