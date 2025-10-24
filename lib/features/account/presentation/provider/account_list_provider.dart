import 'dart:async';

import 'package:dompet/features/account/data/account_repository.dart';
import 'package:dompet/features/account/domain/forms/create_account_detail_form.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/transfer/domain/forms/account_transfer_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AccountListNotifier extends AsyncNotifier<List<AccountModel>> {
  @override
  FutureOr<List<AccountModel>> build() async {
    return await ref.read(accountRepositoryProvider).getAccounts();
  }

  Future create(
    CreateAccountForm form, {
    CreateAccountDetailForm? detailForm,
  }) async {
    final previousState = state.value ?? [];

    state = AsyncData([
      AccountModel.placeholder(
        color: form.colorValue,
        name: form.nameValue,
        type: form.typeValue,
      ),
      ...previousState,
    ]);

    try {
      late AccountModel result;

      if (detailForm != null) {
        result = await ref
            .read(accountRepositoryProvider)
            .createDetail(form, detailForm);
      } else {
        result = await ref.read(accountRepositoryProvider).create(form);
      }

      _updateFormAccountValue(result);

      state = AsyncData([
        result,
        ...previousState.where((account) => account.id != result.id),
      ]);
    } catch (e) {
      if (!ref.mounted) return;
      state = AsyncData(previousState);
      final accountTransferForm = ref.read(accountTransferFormProvider);
      accountTransferForm.toAccount.reset();
      accountTransferForm.toAccount.setErrors({
        'failed':
            'Failed to create new account. Please select existing account or create new one.'
      });
      accountTransferForm.toAccount.markAsTouched();
    }
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

  void _updateFormAccountValue(AccountModel account) {
    //
  }
}

final accountListProvider =
    AsyncNotifierProvider<_AccountListNotifier, List<AccountModel>>(
        _AccountListNotifier.new);
