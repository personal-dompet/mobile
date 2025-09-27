import 'package:dompet/features/account/data/repositories/account_repository.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountProvider extends AsyncNotifier<List<SimpleAccountModel>?> {
  @override
  Future<List<SimpleAccountModel>?> build() async {
    final form = ref.watch(accountFilterFormProvider);
    return await ref.read(accountRepositoryProvider).getAccounts(form);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(AccountCreateForm form) async {
    final previousState = state.value;
    final filter = ref.read(accountFilterFormProvider);
    final filterType = filter.type.value;

    if (previousState != null &&
        (filterType == form.type || filterType == AccountType.all)) {
      state = AsyncData([
        SimpleAccountModel(
          balance: 0,
          id: -1,
          name: form.name,
          type: form.type!,
          color: form.color!,
        ),
        ...previousState,
      ]);
    }

    try {
      final result = await ref.read(accountRepositoryProvider).create(form);
      if (filterType == result.type || filterType == AccountType.all) {
        state = AsyncData([result]);
      }
      state = AsyncData([
        ...state.value ?? [],
        ...previousState ?? [],
      ]);
    } catch (e) {
      state = AsyncData(previousState);
    }
  }
}

class AllAccountsProvider extends AsyncNotifier<List<SimpleAccountModel>?> {
  @override
  Future<List<SimpleAccountModel>?> build() async {
    // Create a filter form with "all" type to bypass filtering
    final filterForm = AccountFilterForm();
    filterForm.type.value = AccountType.all;
    filterForm.keyword.value = null;
    return await ref.read(accountRepositoryProvider).getAccounts(filterForm);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final accountProvider =
    AsyncNotifierProvider<AccountProvider, List<SimpleAccountModel>?>(AccountProvider.new);

final allAccountsProvider =
    AsyncNotifierProvider<AllAccountsProvider, List<SimpleAccountModel>?>(AllAccountsProvider.new);