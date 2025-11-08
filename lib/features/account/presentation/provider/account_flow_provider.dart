import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/create_account_form.dart';
import 'package:dompet/features/account/presentation/provider/account_filter_provider.dart';
import 'package:dompet/features/account/presentation/provider/account_logic_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector_bottom_sheet.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transfer/domain/forms/account_transfer_form.dart';
import 'package:dompet/routes/create_account_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AccountFlowService {
  final Ref ref;
  final ListType listType;

  _AccountFlowService({required this.listType, required this.ref});

  Future<void> beginCreate(
    BuildContext context, {
    ValueChanged<CreateAccountForm>? onFormCreated,
    CreateFrom? createFrom,
  }) async {
    try {
      final type = await _selectAccountType(context);
      if (type == null || !context.mounted) return;

      final creationType = await _navigateToCreateAccount(context, type);
      if (creationType == null || !context.mounted) return;
      await _saveCreatedAccount(
        context,
        creationType,
        onFormCreated,
        createFrom,
      );
    } finally {
      ref.invalidateSelf();
    }
  }

  Future<AccountType?> _selectAccountType(BuildContext context) async {
    final filter = ref.read(accountFilterProvider);

    if (listType == ListType.option || filter.type == AccountType.all) {
      return await showModalBottomSheet<AccountType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const AccountTypeSelectorBottomSheet(),
      );
    }

    return filter.type;
  }

  Future<CreationType?> _navigateToCreateAccount(
    BuildContext context,
    AccountType type,
  ) async {
    final form = ref.read(createAccountFormProvider);
    form.type.value = type;

    return await CreateAccountRoute().push<CreationType>(context);
  }

  Future<void> _saveCreatedAccount(
    BuildContext context,
    CreationType creationType, [
    ValueChanged<CreateAccountForm>? onFormCreated,
    CreateFrom? createFrom,
  ]) async {
    final accountForm = ref.read(createAccountFormProvider);
    onFormCreated?.call(accountForm);
    try {
      await ref.read(accountLogicProvider).create(creationType, createFrom);
    } catch (e) {
      if (!ref.mounted) return;
      final message =
          'Failed to create new account. Please select existing account or create new one.';
      if (createFrom == CreateFrom.transaction) {
        final transactionForm = ref.read(transactionFormProvider);
        transactionForm.account.reset();
        transactionForm.account.setErrors({'failed': message});
        transactionForm.account.markAsTouched();
        return;
      }
      if (createFrom == CreateFrom.transferSource) {
        final accountTransferForm = ref.read(accountTransferFormProvider);
        accountTransferForm.fromAccount.reset();
        accountTransferForm.fromAccount.setErrors({'failed': message});
        accountTransferForm.fromAccount.markAsTouched();
        return;
      }
      if (createFrom == CreateFrom.transferDestination) {
        final accountTransferForm = ref.read(accountTransferFormProvider);
        accountTransferForm.toAccount.reset();
        accountTransferForm.toAccount.setErrors({'failed': message});
        accountTransferForm.toAccount.markAsTouched();
        return;
      }
    }
  }
}

final accountFlowProvider = Provider.family<_AccountFlowService, ListType>(
    (Ref ref, ListType listType) {
  return _AccountFlowService(listType: listType, ref: ref);
});
