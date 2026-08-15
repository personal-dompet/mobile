import 'package:dompet_app/core/enums/balance_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum AccountType {
  @JsonValue('ASSET')
  asset('ASSET', '101', .debit),
  @JsonValue('LIABILITY')
  liability('LIABILITY', '201', .credit),
  @JsonValue('EQUITY')
  equity('EQUITY', '301', .credit),
  @JsonValue('INCOME')
  income('INCOME', '401', .credit),
  @JsonValue('EXPENSE')
  expense('EXPENSE', '501', .debit);

  final String value;
  final String code;
  final BalanceType balanceType;

  const AccountType(this.value, this.code, this.balanceType);

  static List<String> get allValues {
    return AccountType.values.map((policy) => policy.value).toList();
  }
}
