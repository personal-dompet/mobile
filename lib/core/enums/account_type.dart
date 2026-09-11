import 'package:dompet_app/core/enums/balance_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum AccountType {
  @JsonValue('asset')
  asset('asset', '101', .debit),
  @JsonValue('liability')
  liability('liability', '201', .credit),
  @JsonValue('equity')
  equity('equity', '301', .credit),
  @JsonValue('income')
  income('income', '401', .credit),
  @JsonValue('expense')
  expense('expense', '501', .debit);

  final String value;
  final String code;
  final BalanceType balanceType;

  const AccountType(this.value, this.code, this.balanceType);

  static List<String> get allValues {
    return AccountType.values.map((policy) => policy.value).toList();
  }
}
