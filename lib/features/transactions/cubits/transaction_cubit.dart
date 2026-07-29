import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/repositories/transaction_repository.dart';

class TransactionCubit extends Cubit<ActionState> {
  final TransactionRepository _repository;

  TransactionCubit(this._repository) : super(const ActionState.initial());

  Future<void> recordTransaction({
    required TransactionForm form,
    required TransactionType type,
  }) async {
    emit(ActionState.loading());

    try {
      await _repository.recordTransaction(form: form, type: type);

      emit(
        ActionState.success(
          message:
              '${type == .expense ? 'Pengeluaranmu' : 'Pemasukanmu'} berhasil dicatat',
        ),
      );
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
    }
  }

  Future<int?> updateTransaction({
    required int id,
    required TransactionForm form,
    required TransactionType type,
  }) async {
    emit(ActionState.loading());

    try {
      final journalId = await _repository.updateTransaction(
        id: id,
        form: form,
        type: type,
      );

      emit(
        ActionState.success(
          message:
              '${type == .expense ? 'Pengeluaranmu' : 'Pemasukanmu'} berhasil diperbarui',
        ),
      );

      return journalId;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }
}
