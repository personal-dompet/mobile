import 'package:dompet/core/models/financial_entity_filter.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:flutter_riverpod/legacy.dart';

class AccountFilterNotifier
    extends StateNotifier<FinancialEntityFilter<AccountType>> {
  AccountFilterNotifier()
      : super(FinancialEntityFilter<AccountType>(type: AccountType.all));

  void setSearchKeyword(String? keyword) {
    state = state.copyWith(keyword: keyword);
  }

  void setSelectedType(AccountType? type) {
    state = state.copyWith(type: type);
  }

  void clearFilters() {
    state = FinancialEntityFilter<AccountType>(type: AccountType.all);
  }
}

final accountFilterProvider = StateNotifierProvider<AccountFilterNotifier,
    FinancialEntityFilter<AccountType>>(
  (ref) => AccountFilterNotifier(),
);
