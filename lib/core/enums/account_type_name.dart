import 'package:dompet_app/core/enums/balance_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum AccountTypeName {
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

  const AccountTypeName(this.value, this.code, this.balanceType);
}
