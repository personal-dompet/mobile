import 'dart:async';

import 'package:dompet/features/pocket/data/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PocketListNotifier extends AsyncNotifier<List<PocketModel>> {
  @override
  FutureOr<List<PocketModel>> build() async {
    return await ref.read(pocketRepositoryProvider).getPockets();
  }

  void optimisticCreate(PocketModel newPocket, {int? placeholderId}) {
    if (!state.hasValue) return;

    final currentState = [...state.value!];
    if (newPocket.id > 0) {
      state = AsyncData(currentState.map((pocket) {
        if (pocket.id == placeholderId) {
          return newPocket;
        }
        return pocket;
      }).toList());
      return;
    }

    state = AsyncData([newPocket, ...currentState]);
  }

  void revertOptimisticCreate(List<PocketModel> previousPockets) {
    state = AsyncData(previousPockets);
  }

  void optimisticUpdate(PocketModel newPocket) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.map((pocket) {
      if (pocket.id == newPocket.id) {
        return newPocket;
      }
      return pocket;
    }).toList());
  }
}

final pocketListProvider =
    AsyncNotifierProvider<_PocketListNotifier, List<PocketModel>>(
        _PocketListNotifier.new);
