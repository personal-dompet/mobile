import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/budgets/forms/budget_form.dart';
import 'package:dompet_app/features/budgets/models/budget_plan.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';

class BudgetActionCubit extends Cubit<ActionState> {
  BudgetActionCubit(this._planRepository) : super(const ActionState.initial());

  final BudgetPlanRepository _planRepository;

  Future<BudgetPlan?> savePlan({
    required BudgetForm form,
    String successMessage = 'Rencana berhasil disimpan',
  }) async {
    emit(ActionState.loading());

    try {
      final account = form.account;
      if (account == null) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }

      await _planRepository.upsert(
        accountId: account.id,
        amount: form.amount,
        note: form.note,
      );

      final plan = await _planRepository.getByAccountId(account.id);
      if (plan == null) {
        throw Exception('Gagal memuat rencana yang baru disimpan');
      }

      emit(ActionState.success(message: successMessage));
      return plan;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }
}