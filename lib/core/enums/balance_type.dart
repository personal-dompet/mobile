import 'package:freezed_annotation/freezed_annotation.dart';

enum BalanceType {
  @JsonValue('DEBIT')
  debit('DEBIT'),
  @JsonValue('CREDIT')
  credit('CREDIT');

  final String value;

  const BalanceType(this.value);

  static List<String> get allValues {
    return BalanceType.values.map((policy) => policy.value).toList();
  }
}
