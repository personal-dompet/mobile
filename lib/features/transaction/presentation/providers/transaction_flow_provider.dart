import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/core/enum/transaction_static_subject.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/pages/select_pocket_page.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transaction/presentation/providers/transaction_logic_provider.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _TransactionFlowService {
  final Ref _ref;

  _TransactionFlowService(this._ref);

  Future beginTransaction(
    BuildContext context, {
    PocketModel? selectedPocket,
    AccountModel? selectedAccount,
    TransactionStaticSubject? subject,
  }) async {
    final account = selectedAccount ?? await _selectAccount(context);
    if (account == null || !context.mounted) return;

    final form = _ref.read(transactionFormProvider)..account.value = account;

    final pocket = selectedPocket ??
        await _selectPocket(context, title: SelectPocketTitle.general);
    if (pocket == null || !context.mounted) return;

    form.pocket.value = pocket;

    final transactionForm = await CreateTransactionRoute(subject: subject)
        .push<TransactionForm>(context);

    if (transactionForm == null) {
      _ref.invalidate(transactionFormProvider);
      return;
    }

    await _ref.read(transactionLogicProvider).create(
      transactionForm,
      onSuccess: () {
        context.showSuccessSnackbar('Record transaction successfully.');
      },
      onError: () {
        context.showSuccessSnackbar(
          'Error happen when try to record a transaction',
        );
      },
    );

    if (!context.mounted) return;
    _ref.invalidate(transactionFormProvider);
    _ref.invalidateSelf();
  }

  Future<PocketModel?> _selectPocket(BuildContext context,
      {required SelectPocketTitle title}) async {
    final pocket = await SelectPocketRoute(
      title: title,
    ).push<PocketModel>(context);
    return pocket;
  }

  Future<AccountModel?> _selectAccount(BuildContext context) async {
    final account = await SelectAccountRoute(createFrom: CreateFrom.transaction)
        .push<AccountModel>(context);
    return account;
  }
}

final transactionFlowProvider = Provider<_TransactionFlowService>(
  (ref) => _TransactionFlowService(ref),
);
