import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/budgets/forms/budget_plan_form.dart';
import 'package:dompet_app/features/budgets/models/budget_plan.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';

class BudgetActionCubit extends Cubit<ActionState> {
  BudgetActionCubit(this._planRepository) : super(const ActionState.initial());

  final BudgetPlanRepository _planRepository;

  Future<BudgetPlan?> startAddBudget(int categoryId) async {
    return await _planRepository.getByAccountId(categoryId);
  }

  Future<BudgetPlan?> savePlan({
    required BudgetPlanForm form,
    String successMessage = 'Rencana berhasil disimpan',
  }) async {
    emit(ActionState.loading());

    try {
      final categoryId = form.categoryId;
      if (categoryId == null) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }

      await _planRepository.upsert(
        accountId: categoryId,
        amount: form.amount,
        note: form.note,
      );

      final plan = await _planRepository.getByAccountId(categoryId);
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
