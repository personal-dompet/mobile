import 'dart:async';

import 'package:dompet/features/transfer/data/transfer_repository.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_filter_form.dart';
import 'package:dompet/features/transfer/domain/models/pocket_transfer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _RecentPocketTransferNotifier
    extends AsyncNotifier<List<PocketTransferModel>> {
  @override
  FutureOr<List<PocketTransferModel>> build() async {
    final repository = ref.read(transferRepositoryProvider);
    final form = PocketTransferFilterForm()
      ..page.value = 1
      ..limit.value = 5;

    final result = await repository.pocketTransfers(form);
    return result;
  }

  void optimisticCreate(PocketTransferModel newPocketTransfer,
      [int? placeholderId]) {
    if (!state.hasValue) return;

    final currentStates = [...state.value!];
    if (newPocketTransfer.id > 0) {
      state = AsyncData(currentStates.map((transfer) {
        return transfer.id == placeholderId ? newPocketTransfer : transfer;
      }).toList());
      return;
    }

    if (currentStates.length >= 5 && newPocketTransfer.id < 0) {
      currentStates.removeLast();
    }
    state = AsyncData([newPocketTransfer, ...currentStates]);
  }

  void revertCreate(List<PocketTransferModel> previousPocketTransfers) {
    state = AsyncData(previousPocketTransfers);
  }
}

final recentPocketTransfersProvider = AsyncNotifierProvider<
    _RecentPocketTransferNotifier,
    List<PocketTransferModel>>(_RecentPocketTransferNotifier.new);
