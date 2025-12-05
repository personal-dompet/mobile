import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/pages/select_account_page.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/pages/select_pocket_page.dart';
import 'package:dompet/features/transfer/domain/forms/account_transfer_form.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_account_transfer_provider.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_pocket_transfer_provider.dart';
import 'package:dompet/features/transfer/presentation/providers/transfer_logic_provider.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _TransferFlowService {
  final Ref _ref;

  _TransferFlowService(this._ref);

  Future beginPocketTransfer(
    BuildContext context, {
    PocketModel? sourcePocket,
    PocketModel? destinationPocket,
    TransferStaticSubject? subject,
  }) async {
    final destination = destinationPocket ??
        await _selectPocket(context, title: SelectPocketTitle.destination);
    if (destination == null || !context.mounted) return;

    final transferForm = _ref.read(pocketTransferFormProvider);
    transferForm.toPocket.value = destination;

    final source = sourcePocket ??
        await _selectPocket(context, title: SelectPocketTitle.source);
    if (source == null || !context.mounted) {
      _ref.invalidate(pocketTransferFormProvider);
      return;
    }

    transferForm.fromPocket.value = source;

    final form = await CreatePocketTransferRoute(
      subject: subject,
    ).push<PocketTransferForm>(context);

    if (form == null) {
      _ref.invalidate(pocketTransferFormProvider);
      return;
    }

    await _ref.read(transferLogicProvider).pocketTransfer(
      form,
      onSuccess: () {
        context.showSuccessSnackbar('Balance transfered successfully.');
      },
      onError: () {
        context.showSuccessSnackbar(
          'Error happen when trying to transfer balance.',
        );
      },
    );
    _ref.invalidate(pocketTransferFormProvider);
    _ref.invalidate(recentPocketTransfersProvider);
    _ref.invalidateSelf();
  }

  Future beginAccountTransfer(
    BuildContext context, {
    AccountModel? sourceAccount,
    AccountModel? destinationAccount,
    TransferStaticSubject? subject,
  }) async {
    final destination = destinationAccount ??
        await _selectAccount(
          context,
          title: SelectAccountTitle.destination,
        );
    if (destination == null || !context.mounted) return;

    final transferForm = _ref.read(accountTransferFormProvider);
    transferForm.toAccount.value = destination;

    final source = sourceAccount ??
        await _selectAccount(context, title: SelectAccountTitle.source);
    if (source == null || !context.mounted) {
      _ref.invalidate(accountTransferFormProvider);
      return;
    }

    transferForm.fromAccount.value = source;

    final form = await CreateAccountTransferRoute(
      subject: subject,
    ).push<AccountTransferForm>(context);

    if (form == null) {
      _ref.invalidate(accountTransferFormProvider);
      return;
    }

    await _ref.read(transferLogicProvider).accountTransfer(
      form,
      onSuccess: () {
        context.showSuccessSnackbar('Balance transfered successfully.');
      },
      onError: () {
        context.showErrorSnackbar(
          'Error happen when trying to transfer balance.',
        );
      },
    );
    _ref.invalidate(accountTransferFormProvider);
    _ref.invalidate(recentAccountTransfersProvider);
    _ref.invalidateSelf();
  }

  Future<PocketModel?> _selectPocket(BuildContext context,
      {required SelectPocketTitle title}) async {
    final pocket = await SelectPocketRoute(
      title: title,
    ).push<PocketModel>(context);
    return pocket;
  }

  Future<AccountModel?> _selectAccount(BuildContext context,
      {required SelectAccountTitle title}) async {
    final acccount = await SelectAccountRoute(
      title: title,
    ).push<AccountModel>(context);
    return acccount;
  }
}

final transferFlowProvider = Provider<_TransferFlowService>((ref) {
  return _TransferFlowService(ref);
});
