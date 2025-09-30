import 'package:dompet/features/account/data/repositories/account_repository.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountProvider
    extends FamilyAsyncNotifier<List<SimpleAccountModel>?, AccountFilterForm> {
  @override
  Future<List<SimpleAccountModel>?> build(AccountFilterForm filter) async {
    return await ref.read(accountRepositoryProvider).getAccounts(filter);
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
      
      // Check if the provider is still mounted after the async operation
      if (!ref.mounted) return;
      
      List<SimpleAccountModel> newState = [];
      if (filterType == result.type || filterType == AccountType.all) {
        newState = [result];
      }
      
      // Check again if still mounted before final state update
      if (!ref.mounted) return;
      
      state = AsyncData([
        ...newState,
        ...(previousState?.where((account) => account.id != result.id).toList() ?? []),
      ]);
    } catch (e) {
      // Check if still mounted before reverting to previous state
      if (ref.mounted) {
        state = AsyncData(previousState);
      }
    }
  }
}

final accountProvider = AsyncNotifierProvider.autoDispose
    .family<AccountProvider, List<SimpleAccountModel>?, AccountFilterForm>(
        AccountProvider.new);
