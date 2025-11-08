import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/features/account/data/account_repository.dart';
import 'package:dompet/features/account/domain/forms/create_account_detail_form.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transfer/domain/forms/account_transfer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AccountLogicService {
  final Ref ref;

  _AccountLogicService(this.ref);

  Future create(CreationType creationType, CreateFrom? createFrom) async {
    final form = ref.read(createAccountFormProvider);
    final previousAccounts =
        await ref.read(accountListProvider.selectAsync((list) => list));

    final accountListNotifier = ref.read(accountListProvider.notifier);

    final newAccount = form.toAccountModel();

    accountListNotifier.optimisticCreate(newAccount);

    try {
      late AccountModel result;

      if (creationType == CreationType.basic) {
        result = await ref.read(accountRepositoryProvider).create();
      } else {
        result = await ref.read(accountRepositoryProvider).createDetail();
      }

      _updateFormAccountValue(result, createFrom);
      accountListNotifier.optimisticCreate(
        result,
        placeholderId: newAccount.id,
      );
    } catch (e) {
      accountListNotifier.revertOptimisticCreate(previousAccounts);
      rethrow;
    } finally {
      ref.invalidateSelf();
      ref.invalidate(createAccountFormProvider);
      ref.invalidate(createAccountDetailFormProvider);
    }
  }

  void _updateFormAccountValue(AccountModel account, CreateFrom? createFrom) {
    if (createFrom == CreateFrom.transaction) {
      final transactionForm = ref.read(transactionFormProvider);
      transactionForm.account.value = account;
      return;
    }

    final accountTransferForm = ref.read(accountTransferFormProvider);
    if (createFrom == CreateFrom.transferDestination) {
      accountTransferForm.toAccount.value = account;
      return;
    }
    if (createFrom == CreateFrom.transferSource) {
      accountTransferForm.fromAccount.value = account;
      return;
    }
  }
}

final accountLogicProvider = Provider<_AccountLogicService>(
  (ref) => _AccountLogicService(ref),
);
