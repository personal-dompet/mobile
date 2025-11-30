import 'dart:async';

import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/transfer/data/transfer_repository.dart';
import 'package:dompet/features/transfer/domain/forms/transfer_filter_form.dart';
import 'package:dompet/features/transfer/domain/models/transfer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _RecentAccountTransferNotifier
    extends AsyncNotifier<List<TransferModel>> {
  @override
  FutureOr<List<TransferModel>> build() async {
    final repository = ref.read(transferRepositoryProvider);
    final form = TransferFilterForm<AccountModel>()
      ..page.value = 1
      ..limit.value = 5;

    final result = await repository.pocketTransfers(form);
    return result;
  }

  void optimisticCreate(TransferModel newAccountTransfer,
      [int? placeholderId]) {
    if (!state.hasValue) return;

    final currentStates = [...state.value!];
    if (newAccountTransfer.id > 0) {
      state = AsyncData(currentStates.map((transfer) {
        return transfer.id == placeholderId ? newAccountTransfer : transfer;
      }).toList());
      return;
    }

    if (currentStates.length >= 5 && newAccountTransfer.id < 0) {
      currentStates.removeLast();
    }
    state = AsyncData([newAccountTransfer, ...currentStates]);
  }

  void revertCreate(List<TransferModel> previousAccountTransfers) {
    state = AsyncData(previousAccountTransfers);
  }
}

final recentAccountTransfersProvider =
    AsyncNotifierProvider<_RecentAccountTransferNotifier, List<TransferModel>>(
        _RecentAccountTransferNotifier.new);
