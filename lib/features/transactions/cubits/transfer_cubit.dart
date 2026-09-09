import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:dompet_app/features/transactions/repositories/transfer_repository.dart';

class TransferCubit extends Cubit<ActionState> {
  final TransferRepository _repository;

  TransferCubit(this._repository) : super(const ActionState.initial());

  Future<void> transferBalance({required TransferForm form}) async {
    emit(ActionState.loading());

    try {
      await _repository.transferBalance(form: form);

      emit(ActionState.success(message: 'Danamu berhasil dipindah'));
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
    }
  }

  /// FIX-07 (IMP-1): selalu lewat jalur auto-adjustment sumber.
  /// Tanpa overspend perilakunya identik dengan [transferBalance].
  Future<void> transferBalanceAuto({
    required TransferForm form,
    int? previousAmount,
    int? previousSourceId,
  }) async {
    emit(ActionState.loading());

    try {
      await _repository.transferBalanceAuto(
        form: form,
        previousAmount: previousAmount,
        previousSourceId: previousSourceId,
      );

      emit(ActionState.success(message: 'Danamu berhasil dipindah'));
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
    }
  }

  /// FIX-07 edit flow via auto-adjustment (void + 2 jurnal atomik).
  Future<int?> updateTransferAuto({
    required TransferForm form,
    required int id,
    int? previousAmount,
    int? previousSourceId,
  }) async {
    emit(ActionState.loading());

    try {
      final transferId = await _repository.updateTransferAuto(
        form: form,
        id: id,
        previousAmount: previousAmount,
        previousSourceId: previousSourceId,
      );

      emit(ActionState.success(message: 'Pindah dana berhasil diperbarui'));
      return transferId;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }

  Future<int?> updateTransfer({
    required TransferForm form,
    required int id,
  }) async {
    emit(ActionState.loading());

    try {
      final transferId = await _repository.updateTransfer(form: form, id: id);

      emit(ActionState.success(message: 'Pindah dana berhasil diperbarui'));
      return transferId;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }
}
