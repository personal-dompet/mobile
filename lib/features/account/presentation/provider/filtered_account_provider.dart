import 'package:dompet/features/account/data/account_repository.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/all_account_provider.dart';
import 'package:dompet/features/account/presentation/provider/create_account_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilteredAccountProvider extends AsyncNotifier<List<AccountModel>?> {
  @override
  Future<List<AccountModel>?> build() async {
    final filter = ref.read(accountFilterFormProvider);
    return await ref.read(accountRepositoryProvider).getAccounts(filter);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(AccountCreateForm form) async {
    final previousState = state.value;
    final filter = ref.read(accountFilterFormProvider);
    final newState = await ref
        .read(createAccountProvider)
        .execute(form, previousState, filter);

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncData(newState);
      ref.invalidate(allAccountProvider);
    }
  }
}

final filteredAccountProvider = AsyncNotifierProvider.autoDispose<
    FilteredAccountProvider, List<AccountModel>?>(
  FilteredAccountProvider.new,
);
