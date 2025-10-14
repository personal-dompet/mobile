import 'dart:async';

import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/transfer/data/transfer_repository.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_filter_form.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/domain/models/pocket_transfer_model.dart';
// import 'package:dompet/features/transfer/domain/models/account_transfer_model.dart';
import 'package:dompet/features/transfer/presentation/providers/create_transfer_provider.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferProvider extends AsyncNotifier<List<PocketTransferModel>> {
  @override
  Future<List<PocketTransferModel>> build() async {
    final filter = ref.read(pocketTransferFilterFormProvider);
    return ref.read(transferRepositoryProvider).pocketTransfers(filter);
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
      ref.invalidate(pocketListProvider);
    }
  }
}

final transferProvider =
    AsyncNotifierProvider<TransferProvider, List<PocketTransferModel>>(
        TransferProvider.new);

// Placeholder provider for account transfers until we have the repository method
// In the future, this would call repository.getAccountTransfers()
// final recentAccountTransfersProvider = FutureProvider<List<AccountTransferModel>>((ref) async {
//   // For now, returning an empty list since the repository method doesn't exist yet
//   return [];
// });
