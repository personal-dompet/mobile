import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:flutter_riverpod/legacy.dart';

class AccountFilter {
  final String? keyword;
  final AccountType type;

  AccountFilter({
    this.keyword,
    this.type = AccountType.all,
  });

  AccountFilter copyWith({
    String? keyword,
    AccountType? type,
  }) {
    return AccountFilter(
      keyword: keyword ?? this.keyword,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccountFilter &&
        other.keyword == keyword &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(keyword, type);
}

class AccountFilterNotifier extends StateNotifier<AccountFilter> {
  AccountFilterNotifier() : super(AccountFilter());

  void setSearchKeyword(String? keyword) {
    state = state.copyWith(keyword: keyword);
  }

  void setSelectedType(AccountType? type) {
    state = state.copyWith(type: type);
  }

  void clearFilters() {
    state = AccountFilter();
  }
}

final accountFilterProvider =
    StateNotifierProvider<AccountFilterNotifier, AccountFilter>(
        (ref) => AccountFilterNotifier());
