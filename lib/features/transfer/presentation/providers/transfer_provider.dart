import 'dart:async';

import 'package:dompet/features/pocket/presentation/provider/all_pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/filtered_pocket_provider.dart';
import 'package:dompet/features/transfer/data/transfer_repository.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/domain/models/pocket_transfer_model.dart';
import 'package:dompet/features/transfer/presentation/providers/create_transfer_provider.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferProvider extends AsyncNotifier<List<PocketTransferModel>> {
  @override
  Future<List<PocketTransferModel>> build() async {
    return ref.read(transferRepositoryProvider).pocketTransfers();
  }

  Future<void> pocketTransfer(PocketTransferForm request) async {
    final previousState = state.value;
    final newState =
        await ref.read(createTransferProvider).executePocketTransfer(
              request,
              previousState,
            );

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncValue.data(newState);
      ref.invalidate(walletProvider);
      ref.invalidate(filteredPocketProvider);
      ref.invalidate(allPocketProvider);
    }
  }
}

final transferProvider =
    AsyncNotifierProvider<TransferProvider, List<PocketTransferModel>>(
        TransferProvider.new);
