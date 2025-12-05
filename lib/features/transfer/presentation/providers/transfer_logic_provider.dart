import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/transfer/data/transfer_repository.dart';
import 'package:dompet/features/transfer/domain/forms/account_transfer_form.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/domain/models/transfer_model.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_account_transfer_provider.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_pocket_transfer_provider.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _TransferLogicService {
  final Ref _ref;

  _TransferLogicService(this._ref);

  Future<void> pocketTransfer(
    PocketTransferForm request, {
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    final recentPocketTransfers = await _ref
        .read(recentPocketTransfersProvider.selectAsync((list) => list));

    final newSourcePocket = request.fromPocketValue.copyWith(
      balance: request.fromPocketValue.balance - request.amountValue,
    );
    final newDestinationPocket = request.toPocketValue.copyWith(
      balance: request.toPocketValue.balance + request.amountValue,
    );

    final recentPocketTransferNotifier =
        _ref.read(recentPocketTransfersProvider.notifier);
    final pocketListNotifier = _ref.read(pocketListProvider.notifier);
    final walletNotifier = _ref.read(walletProvider.notifier);

    pocketListNotifier.optimisticUpdate(newSourcePocket);
    pocketListNotifier.optimisticUpdate(newDestinationPocket);
    recentPocketTransferNotifier.optimisticCreate(
      TransferModel<PocketModel>.placeholder(
        amount: request.amountValue,
        description: request.descriptionValue,
        destination: newDestinationPocket,
        source: newSourcePocket,
      ),
    );
    if (newSourcePocket.type == PocketType.wallet) {
      walletNotifier.optimisticUpdateBalance(newSourcePocket, true);
    }
    if (newDestinationPocket.type == PocketType.wallet) {
      walletNotifier.optimisticUpdateBalance(newDestinationPocket, true);
    }

    try {
      final newState =
          await _ref.read(transferRepositoryProvider).pocketTransfer(request);

      pocketListNotifier.optimisticUpdate(newState.source);
      pocketListNotifier.optimisticUpdate(newState.destination);
      recentPocketTransferNotifier.optimisticCreate(newState);
      if (newState.source.type == PocketType.wallet) {
        walletNotifier.optimisticUpdateBalance(newState.source);
      }
      if (newState.destination.type == PocketType.wallet) {
        walletNotifier.optimisticUpdateBalance(newState.destination);
      }
      onSuccess();
    } catch (e) {
      onError();
      pocketListNotifier.optimisticUpdate(request.fromPocketValue);
      pocketListNotifier.optimisticUpdate(request.toPocketValue);
      recentPocketTransferNotifier.revertCreate(recentPocketTransfers);
      if (request.fromPocketValue.type == PocketType.wallet) {
        walletNotifier.optimisticUpdateBalance(request.fromPocketValue);
      }
      if (request.toPocketValue.type == PocketType.wallet) {
        walletNotifier.optimisticUpdateBalance(request.toPocketValue);
      }
    } finally {
      _ref.invalidateSelf();
    }
  }

  Future<void> accountTransfer(
    AccountTransferForm request, {
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    final recentAccountTransfers = await _ref
        .read(recentAccountTransfersProvider.selectAsync((list) => list));

    final newSourceAccount = request.fromAccountValue.copyWith(
      balance: request.fromAccountValue.balance - request.amountValue,
    );
    final newDestinationAccount = request.toAccountValue.copyWith(
      balance: request.toAccountValue.balance + request.amountValue,
    );

    final recentAccountTransferNotifier =
        _ref.read(recentAccountTransfersProvider.notifier);
    final accountListNotifier = _ref.read(accountListProvider.notifier);

    accountListNotifier.optimisticUpdate(newSourceAccount);
    accountListNotifier.optimisticUpdate(newDestinationAccount);
    recentAccountTransferNotifier.optimisticCreate(
      TransferModel<AccountModel>.placeholder(
        amount: request.amountValue,
        description: request.descriptionValue,
        destination: newDestinationAccount,
        source: newSourceAccount,
      ),
    );

    try {
      final newState =
          await _ref.read(transferRepositoryProvider).accountTransfer(request);

      accountListNotifier.optimisticUpdate(newState.source);
      accountListNotifier.optimisticUpdate(newState.destination);
      recentAccountTransferNotifier.optimisticCreate(newState);

      onSuccess();
    } catch (e) {
      debugPrint(e.toString());
      onError();
      accountListNotifier.optimisticUpdate(request.fromAccountValue);
      accountListNotifier.optimisticUpdate(request.toAccountValue);
      recentAccountTransferNotifier.revertCreate(recentAccountTransfers);
    } finally {
      _ref.invalidateSelf();
    }
  }
}

final transferLogicProvider = Provider<_TransferLogicService>(
  (ref) => _TransferLogicService(ref),
);
