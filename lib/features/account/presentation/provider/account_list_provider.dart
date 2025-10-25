import 'dart:async';

import 'package:dompet/features/account/data/account_repository.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AccountListNotifier extends AsyncNotifier<List<AccountModel>> {
  @override
  FutureOr<List<AccountModel>> build() async {
    return await ref.read(accountRepositoryProvider).getAccounts();
  }

  void optimisticCreate(AccountModel newAccount, {int? placeholderId}) {
    if (!state.hasValue) return;

    final currentState = [...state.value!];
    if (newAccount.id > 0) {
      state = AsyncData(currentState.map((account) {
        if (account.id == placeholderId) {
          return newAccount;
        }
        return account;
      }).toList());
      return;
    }

    state = AsyncData([newAccount, ...currentState]);
  }

  void revertOptimisticCreate(List<AccountModel> previousAccounts) {
    state = AsyncData(previousAccounts);
  }

  void optimisticUpdate(AccountModel newAccount) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.map((account) {
      if (account.id == newAccount.id) {
        return newAccount;
      }
      return account;
    }).toList());
  }
}

final accountListProvider =
    AsyncNotifierProvider<_AccountListNotifier, List<AccountModel>>(
        _AccountListNotifier.new);
