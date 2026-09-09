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

  /// FIX-07 (IMP-1): selalu lewat jalur auto-adjustment. Tanpa overspend
  /// perilakunya identik dengan [recordTransaction] (1 jurnal biasa).
  Future<void> recordTransactionAuto({
    required TransactionForm form,
    required TransactionType type,
    int? previousAmount,
    int? previousAssetId,
  }) async {
    emit(ActionState.loading());

    try {
      await _repository.recordTransactionAuto(
        form: form,
        type: type,
        previousAmount: previousAmount,
        previousAssetId: previousAssetId,
      );

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

  /// FIX-07 edit flow via auto-adjustment (void + 2 jurnal atomik).
  Future<int?> updateTransactionAuto({
    required int id,
    required TransactionForm form,
    required TransactionType type,
    int? previousAmount,
    int? previousAssetId,
  }) async {
    emit(ActionState.loading());

    try {
      final journalId = await _repository.updateTransactionAuto(
        id: id,
        form: form,
        type: type,
        previousAmount: previousAmount,
        previousAssetId: previousAssetId,
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
