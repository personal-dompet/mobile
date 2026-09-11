import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/bills/forms/bill_plan_form.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';

class BillPlanActionCubit extends Cubit<ActionState> {
  BillPlanActionCubit(this._repository) : super(const ActionState.initial());

  final BillPlanRepository _repository;

  Future<BillPlan?> savePlan({
    required BillPlanForm form,
    int? planId,
    String successMessage = 'Tagihan rutin berhasil disimpan',
  }) async {
    emit(ActionState.loading());

    try {
      final accountId = form.accountId;
      if (accountId == null) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }

      final plan = await _repository.savePlan(
        id: planId,
        accountId: accountId,
        name: form.name,
        amount: form.amount,
        period: form.period,
        billedSchedule: form.billedScheduleControl.value ?? '',
        dueDateSchedule: form.dueDateScheduleControl.value ?? '',
        reminderDays: form.reminderDays,
        endedAt: form.endedAtControl.value,
        reference: form.referenceControl.value,
        note: form.noteControl.value,
        bulkCreate: form.bulkCreate,
      );

      emit(ActionState.success(message: successMessage));
      return plan;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }
}
