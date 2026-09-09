import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/transactions/exceptions/no_op_balance_adjustment_exception.dart';
import 'package:dompet_app/features/transactions/forms/balance_adjustment_form.dart';
import 'package:dompet_app/features/transactions/repositories/balance_adjustment_repository.dart';

class BalanceAdjustmentCubit extends Cubit<ActionState> {
  final BalanceAdjustmentRepository _repository;

  BalanceAdjustmentCubit(this._repository) : super(const ActionState.initial());

  Future<void> adjustBalance(BalanceAdjustmentForm form) async {
    emit(ActionState.loading());

    try {
      await _repository.adjustBalance(form: form);

      emit(ActionState.success(message: 'Saldo berhasil disesuaikan'));
    } on NoOpBalanceAdjustmentException catch (e) {
      // No journal was written; report as a calm success so the page pops
      // back instead of showing an error. FIX-15 restyles the snackbar.
      emit(ActionState.success(message: e.toString()));
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
    }
  }
}
