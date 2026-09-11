import 'package:freezed_annotation/freezed_annotation.dart';

enum BillStatus {
  @JsonValue('drafted')
  drafted('drafted'),
  @JsonValue('unpaid')
  unpaid('unpaid'),
  @JsonValue('paid')
  paid('paid'),
  @JsonValue('overdue')
  overdue('overdue');

  final String value;

  const BillStatus(this.value);

  static List<String> get allValues {
    return BillStatus.values.map((policy) => policy.value).toList();
  }
}
