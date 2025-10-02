import 'dart:async';

import 'package:dompet/features/pocket/presentation/provider/pocket_provider.dart';
import 'package:dompet/features/transfer/data/repositories/transfer_repository.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/domain/models/pocket_transfer_model.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Reusable function for creating pocket transfers
Future<List<PocketTransferModel>> _createPocketTransfer(
  Ref ref,
  PocketTransferForm form,
  List<PocketTransferModel>? previousState,
) async {
  // Check if mounted before processing
  if (!ref.mounted) return previousState ?? [];

  List<PocketTransferModel> newState = previousState ?? [];

  // Optimistically add the transfer to the state
  newState = [
    PocketTransferModel.empty().copyWith(
      sourcePocket: form.fromPocket,
      destinationPocket: form.toPocket,
      amount: form.amount,
      description: form.description,
    ),
    ...previousState ?? [],
  ];

  try {
    final result =
        await ref.read(transferRepositoryProvider).pocketTransfer(form);

    // Check if the provider is still mounted after the async operation
    if (!ref.mounted) return previousState ?? [];

    // Update with the actual result from the API
    newState = [
      result,
      ...(previousState
              ?.where((transfer) => transfer.id != result.id)
              .toList() ??
          []),
    ];
  } catch (e) {
    // Return previous state if there's an error
    return previousState ?? [];
  }

  return newState;
}

class TransferProvider extends AsyncNotifier<List<PocketTransferModel>> {
  @override
  Future<List<PocketTransferModel>> build() async {
    return ref.read(transferRepositoryProvider).pocketTransfers();
  }

  Future<void> pocketTransfer(PocketTransferForm request) async {
    final previousState = state.value;
    final newState = await _createPocketTransfer(ref, request, previousState);

    // Only update state if still mounted
    if (ref.mounted) {
      state = AsyncValue.data(newState);
      ref.invalidate(walletProvider);
      ref.invalidate(filteredPocketProvider);
      ref.invalidate(pocketListProvider);
    }
  }
}

final transferProvider =
    AsyncNotifierProvider<TransferProvider, List<PocketTransferModel>>(
        TransferProvider.new);
