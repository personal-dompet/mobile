import 'dart:async';

import 'package:dompet/features/pocket/data/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_recurring_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_saving_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_spending_pocket_form.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PocketListNotifier extends AsyncNotifier<List<PocketModel>> {
  @override
  FutureOr<List<PocketModel>> build() async {
    return await ref.read(pocketRepositoryProvider).getPockets();
  }

  Future<void> create(
    CreatePocketForm form, {
    CreateSpendingPocketForm? spendingForm,
    CreateSavingPocketForm? savingForm,
    CreateRecurringPocketForm? recurringForm,
  }) async {
    final previousState = state.value ?? [];

    state = AsyncData([
      PocketModel.placeholder(
        name: form.nameValue,
        type: form.typeValue!,
        color: form.colorValue!,
        icon: form.iconValue,
      ),
      ...previousState,
    ]);

    try {
      late PocketModel result;

      if (spendingForm != null) {
        result = await ref
            .read(pocketRepositoryProvider)
            .createSpending(form, spendingForm);
      } else if (savingForm != null) {
        result = await ref
            .read(pocketRepositoryProvider)
            .createSaving(form, savingForm);
      } else if (recurringForm != null) {
        result = await ref
            .read(pocketRepositoryProvider)
            .createRecurring(form, recurringForm);
      } else {
        result = await ref.read(pocketRepositoryProvider).create(form);
      }

      final pocketTransferForm = ref.read(pocketTransferFormProvider);
      pocketTransferForm.toPocket.value = result;

      final List<PocketModel> newState = [result];

      state = AsyncData([
        ...newState,
        ...previousState.where((pocket) => pocket.id != result.id),
      ]);
    } catch (e) {
      if (ref.mounted) {
        state = AsyncData(previousState);
      }
    }
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
