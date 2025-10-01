import 'package:dompet/features/account/data/repositories/account_repository.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Reusable function for creating accounts
Future<List<SimpleAccountModel>> _createAccount(
  Ref ref,
  AccountCreateForm form,
  List<SimpleAccountModel>? previousState, [
  AccountFilterForm? filter,
]) async {
  final filterType = filter?.type.value ?? AccountType.all;

  // Check if mounted before processing
  if (!ref.mounted) return previousState ?? [];

  List<SimpleAccountModel> newState = previousState ?? [];

  if (previousState != null &&
      (filterType == form.type || filterType == AccountType.all)) {
    newState = [
      SimpleAccountModel(
        balance: 0,
        id: -1,
        name: form.name,
        type: form.type!,
        color: form.color!,
      ),
      ...previousState,
    ];
  }

  try {
    final result = await ref.read(accountRepositoryProvider).create(form);

    // Check if the provider is still mounted after the async operation
    if (!ref.mounted) return previousState ?? [];

    List<SimpleAccountModel> updatedState = [];
    if (filterType == result.type || filterType == AccountType.all) {
      updatedState = [result];
    }

    // Check again if still mounted before final state update
    if (!ref.mounted) return previousState ?? [];

    newState = [
      ...updatedState,
      ...(previousState?.where((account) => account.id != result.id).toList() ??
          []),
    ];
  } catch (e) {
    // Return previous state if there's an error
    return previousState ?? [];
  }

  return newState;
}

class FilteredAccountProvider extends AsyncNotifier<List<SimpleAccountModel>?> {
  @override
  Future<List<SimpleAccountModel>?> build() async {
    final filter = ref.read(accountFilterFormProvider);
    return await ref.read(accountRepositoryProvider).getAccounts(filter);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(AccountCreateForm form) async {
    final previousState = state.value;
    final filter = ref.read(accountFilterFormProvider);
    final newState = await _createAccount(ref, form, previousState, filter);

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncData(newState);
      ref.invalidate(accountListProvider);
    }
  }
}

class AccountListProvider extends AsyncNotifier<List<SimpleAccountModel>?> {
  @override
  Future<List<SimpleAccountModel>?> build() async {
    return await ref
        .read(accountRepositoryProvider)
        .getAccounts(AccountFilterForm());
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> create(AccountCreateForm form) async {
    final previousState = state.value;
    final filter = ref.read(accountFilterFormProvider);
    final newState = await _createAccount(ref, form, previousState, filter);

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncData(newState);
      ref.invalidate(filteredAccountProvider);
    }
  }
}

final accountListProvider =
    AsyncNotifierProvider<AccountListProvider, List<SimpleAccountModel>?>(
        AccountListProvider.new);

final filteredAccountProvider =
    AsyncNotifierProvider<FilteredAccountProvider, List<SimpleAccountModel>?>(
        FilteredAccountProvider.new);
