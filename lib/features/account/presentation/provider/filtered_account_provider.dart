import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_filter_provider.dart';
import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredAccountListProvider = Provider<List<AccountModel>>((ref) {
  final accountsAsync = ref.watch(accountListProvider);
  if (!accountsAsync.hasValue) return [];
  final filter = ref.watch(accountFilterProvider);
  final accounts = accountsAsync.value ?? [];
  return accounts.where((account) {
    final keyword = filter.keyword != null ? filter.keyword!.toLowerCase() : '';
    final isNameFound = account.name.toLowerCase().contains(keyword);
    if (filter.type == AccountType.all) {
      return isNameFound;
    }
    return isNameFound && account.type == filter.type;
  }).toList();
});
