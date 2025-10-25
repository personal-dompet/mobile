import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/features/pocket/data/pocket_repository.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_recurring_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_saving_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_spending_pocket_form.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PocketLogicService {
  final Ref ref;

  _PocketLogicService(this.ref);

  Future create(CreationType creationType) async {
    final form = ref.read(createPocketFormProvider);
    final previousPockets =
        await ref.read(pocketListProvider.selectAsync((list) => list));

    final pocketListNotifier = ref.read(pocketListProvider.notifier);

    final newPocket = form.toPocketModel();

    pocketListNotifier.optimisticCreate(newPocket);

    try {
      late PocketModel result;

      if (creationType == CreationType.basic) {
        result = await ref.read(pocketRepositoryProvider).create();
      } else if (newPocket.type == PocketType.spending) {
        result = await ref.read(pocketRepositoryProvider).createSpending();
      } else if (newPocket.type == PocketType.saving) {
        result = await ref.read(pocketRepositoryProvider).createSaving();
      } else if (newPocket.type == PocketType.recurring) {
        result = await ref.read(pocketRepositoryProvider).createRecurring();
      }

      _updateFormPocketValue(result);
      pocketListNotifier.optimisticCreate(result, placeholderId: newPocket.id);
    } catch (e) {
      pocketListNotifier.revertOptimisticCreate(previousPockets);
      rethrow;
    } finally {
      ref.invalidateSelf();
      ref.invalidate(createPocketFormProvider);
      ref.invalidate(createSpendingPocketFormProvider);
      ref.invalidate(createSavingPocketFormProvider);
      ref.invalidate(createRecurringPocketFormProvider);
    }
  }

  void _updateFormPocketValue(PocketModel pocket) {
    // TODO: Add another form provider that use pocket data and add flagging from where the creation come from (source or destination)
    final pocketTransferForm = ref.read(pocketTransferFormProvider);
    final transactionForm = ref.read(transactionFormProvider);

    pocketTransferForm.toPocket.value = pocket;
    transactionForm.pocket.value = pocket;
  }
}

final pocketLogicProvider = Provider<_PocketLogicService>(
  (ref) => _PocketLogicService(ref),
);
