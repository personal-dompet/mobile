import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/states/action_state.dart';
import 'package:dompet_app/features/savings/forms/saving_allocation_form.dart';
import 'package:dompet_app/features/savings/forms/saving_plan_form.dart';
import 'package:dompet_app/features/savings/forms/saving_spend_form.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';

class SavingActionCubit extends Cubit<ActionState> {
  SavingActionCubit(this._repository) : super(const ActionState.initial());

  final SavingRepository _repository;

  Future<SavingPlan?> createPocket({
    required SavingPlanForm form,
    int? initialAssetId,
    int? initialAmount,
    String successMessage = 'Target berhasil dibuat',
  }) async {
    emit(const ActionState.loading());

    try {
      final name = form.name;
      if (name == null || name.trim().isEmpty) {
        throw Exception('Nama target belum diisi');
      }

      final plan = await _repository.createPocket(
        name: name,
        iconCode: form.iconCode,
        targetAmount: form.targetAmount,
        targetDate: form.targetDate?.endOfDay.secondsSinceEpoch,
        note: form.note,
        initialAssetId: initialAssetId,
        initialAmount: initialAmount,
      );

      emit(ActionState.success(message: successMessage));
      return plan;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }

  Future<SavingPlan?> updatePlan({
    required int accountId,
    required SavingPlanForm form,
    String successMessage = 'Target berhasil diubah',
  }) async {
    emit(const ActionState.loading());

    try {
      final name = form.name;
      if (name == null || name.trim().isEmpty) {
        throw Exception('Nama target belum diisi');
      }

      final plan = await _repository.updatePlan(
        accountId: accountId,
        name: name,
        iconCode: form.iconCode,
        targetAmount: form.targetAmount,
        targetDate: form.targetDate?.endOfDay.secondsSinceEpoch,
        note: form.note,
      );

      if (plan == null) {
        throw Exception('Gagal memuat target yang baru diubah');
      }

      emit(ActionState.success(message: successMessage));
      return plan;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }

  Future<int?> topup({
    required SavingAllocationForm form,
    String successMessage = 'Alokasi berhasil dicatat',
  }) async {
    emit(const ActionState.loading());

    try {
      final pocketId = form.pocketId;
      final assetId = form.assetId;
      final amount = form.amount;
      if (pocketId == null || assetId == null || amount == null) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }

      final journalId = await _repository.topup(
        pocketId: pocketId,
        assetId: assetId,
        amount: amount,
        note: form.note,
        date: form.date,
      );

      emit(ActionState.success(message: successMessage));
      return journalId;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }

  Future<int?> withdraw({
    required SavingAllocationForm form,
    String successMessage = 'Penarikan berhasil dicatat',
  }) async {
    emit(const ActionState.loading());

    try {
      final pocketId = form.pocketId;
      final assetId = form.assetId;
      final amount = form.amount;
      if (pocketId == null || assetId == null || amount == null) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }

      final journalId = await _repository.withdraw(
        pocketId: pocketId,
        assetId: assetId,
        amount: amount,
        note: form.note,
        date: form.date,
      );

      emit(ActionState.success(message: successMessage));
      return journalId;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }

  Future<int?> spend({
    required SavingSpendForm form,
    String successMessage = 'Pengeluaran berhasil dicatat',
  }) async {
    emit(const ActionState.loading());

    try {
      final pocketId = form.pocketId;
      final categoryId = form.categoryId;
      final amount = form.amount;
      if (pocketId == null || categoryId == null || amount == null) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }

      final journalId = await _repository.spend(
        pocketId: pocketId,
        categoryId: categoryId,
        amount: amount,
        note: form.note,
        date: form.date,
      );

      emit(ActionState.success(message: successMessage));
      return journalId;
    } catch (e) {
      emit(ActionState.error(message: e.toString()));
      return null;
    }
  }
}
