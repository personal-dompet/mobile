import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/transfer/data/transfer_repository.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/domain/models/pocket_transfer_model.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_pocket_transfer_provider.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _TransferService {
  final Ref _ref;

  _TransferService(this._ref);

  Future<void> pocketTransfer(PocketTransferForm request) async {
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
    recentPocketTransferNotifier.optimisticUpdate(
        PocketTransferModel.placeholder(
            amount: request.amountValue,
            description: request.descriptionValue,
            destinationPocket: newDestinationPocket,
            sourcePocket: newSourcePocket));
    if (newSourcePocket.type == PocketType.wallet) {
      walletNotifier.optimisticUpdateBalance(newSourcePocket);
    }
    if (newDestinationPocket.type == PocketType.wallet) {
      walletNotifier.optimisticUpdateBalance(newDestinationPocket);
    }

    try {
      final newState =
          await _ref.read(transferRepositoryProvider).pocketTransfer(request);

      if (_ref.mounted) {
        pocketListNotifier.optimisticUpdate(newState.sourcePocket);
        pocketListNotifier.optimisticUpdate(newState.destinationPocket);
        recentPocketTransferNotifier.optimisticUpdate(newState);
        if (newState.sourcePocket.type == PocketType.wallet) {
          walletNotifier.optimisticUpdateBalance(newState.sourcePocket);
        }
        if (newState.destinationPocket.type == PocketType.wallet) {
          walletNotifier.optimisticUpdateBalance(newState.destinationPocket);
        }
      }
    } catch (e) {
      if (_ref.mounted) {
        pocketListNotifier.optimisticUpdate(request.fromPocketValue);
        pocketListNotifier.optimisticUpdate(request.toPocketValue);
        recentPocketTransferNotifier.revertUpdate(recentPocketTransfers);
        if (request.fromPocketValue.type == PocketType.wallet) {
          walletNotifier.optimisticUpdateBalance(request.fromPocketValue);
        }
        if (request.toPocketValue.type == PocketType.wallet) {
          walletNotifier.optimisticUpdateBalance(request.toPocketValue);
        }
      }
    }
  }
}

final transferProvider = Provider.autoDispose<_TransferService>(
  (ref) => _TransferService(ref),
);
