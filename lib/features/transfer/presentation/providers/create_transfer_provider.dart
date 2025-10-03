import 'package:dompet/features/transfer/data/transfer_repository.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/domain/models/pocket_transfer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTransferProvider {
  final TransferRepository _repository;

  CreateTransferProvider(this._repository);

  Future<List<PocketTransferModel>> executePocketTransfer(
    PocketTransferForm form,
    List<PocketTransferModel>? previousState,
  ) async {
    List<PocketTransferModel> newState = previousState ?? [];

    // Optimistically add the transfer to the state
    newState = [
      PocketTransferModel.placeholder(
        sourcePocket: form.fromPocket,
        destinationPocket: form.toPocket,
        amount: form.amount,
        description: form.description,
      ),
      ...previousState ?? [],
    ];

    try {
      final result = await _repository.pocketTransfer(form);

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
}

final createTransferProvider =
    Provider.autoDispose<CreateTransferProvider>((ref) {
  final repository = ref.read(transferRepositoryProvider);
  return CreateTransferProvider(repository);
});
