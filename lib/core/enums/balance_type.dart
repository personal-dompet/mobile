import 'package:freezed_annotation/freezed_annotation.dart';

enum BalanceType {
  @JsonValue('debit')
  debit('debit'),
  @JsonValue('credit')
  credit('credit');

  final String value;

  const BalanceType(this.value);

  static List<String> get allValues {
    return BalanceType.values.map((policy) => policy.value).toList();
  }
}
