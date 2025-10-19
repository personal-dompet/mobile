import 'package:dompet/features/account/data/account_repository.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/create_account_provider.dart';
import 'package:dompet/features/account/presentation/provider/filtered_account_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllAccountProvider extends AsyncNotifier<List<AccountModel>> {
  @override
  Future<List<AccountModel>> build() async {
    return await ref
        .read(accountRepositoryProvider)
        .getAccounts(AccountFilterForm());
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(AccountCreateForm form) async {
    final previousState = state.value;
    final newState =
        await ref.read(createAccountProvider).execute(form, previousState);

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncData(newState);
      ref.invalidate(filteredAccountProvider);
    }
  }
}

final allAccountProvider =
    AsyncNotifierProvider.autoDispose<AllAccountProvider, List<AccountModel>>(
  AllAccountProvider.new,
);
