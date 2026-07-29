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
