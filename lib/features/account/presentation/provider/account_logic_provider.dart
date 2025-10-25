import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/features/account/data/account_repository.dart';
import 'package:dompet/features/account/domain/forms/create_account_detail_form.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/transfer/domain/forms/account_transfer_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AccountLogicService {
  final Ref ref;

  _AccountLogicService(this.ref);

  Future create(CreationType creationType) async {
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

      _updateFormAccountValue(result);
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

  void _updateFormAccountValue(AccountModel account) {
    // TODO: Add another form provider that use account data and add flagging from where the creation come from (source or destination)
    final accountTransferForm = ref.read(accountTransferFormProvider);

    accountTransferForm.toAccount.value = account;
  }
}

final accountLogicProvider = Provider<_AccountLogicService>(
  (ref) => _AccountLogicService(ref),
);
