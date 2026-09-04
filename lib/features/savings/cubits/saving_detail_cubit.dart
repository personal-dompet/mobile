import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/savings/models/saving_detail.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saving_detail_cubit.freezed.dart';

@freezed
sealed class SavingDetailState with _$SavingDetailState {
  const factory SavingDetailState.initial() = _SavingDetailInitial;
  const factory SavingDetailState.loading({SavingPlan? plan}) =
      _SavingDetailLoading;
  const factory SavingDetailState.loaded({required SavingDetail detail}) =
      _SavingDetailLoaded;
  const factory SavingDetailState.error({required String message}) =
      _SavingDetailError;
}

class SavingDetailCubit extends Cubit<SavingDetailState> {
  SavingDetailCubit(this._repository)
    : super(const SavingDetailState.initial());

  final SavingRepository _repository;

  int? _accountId;

  Future<void> fetch(int accountId) async {
    _accountId = accountId;
    final currentPlan = state.maybeWhen(
      loaded: (detail) => detail.plan,
      orElse: () => null,
    );
    emit(SavingDetailState.loading(plan: currentPlan));
    try {
      final plan = await _repository.getByAccountId(accountId);
      if (isClosed) return;
      if (plan == null) {
        emit(
          const SavingDetailState.error(message: 'Target tidak ditemukan'),
        );
        return;
      }
      final activities = await _repository.getPocketJournals(accountId);
      if (isClosed) return;
      emit(
        SavingDetailState.loaded(
          detail: SavingDetail.compute(
            plan: plan,
            activities: activities,
            now: DateTime.now(),
          ),
        ),
      );
    } catch (e) {
      if (!isClosed) emit(SavingDetailState.error(message: e.toString()));
    }
  }

  Future<void> refresh() async {
    final id = _accountId;
    if (id != null) await fetch(id);
  }

  Future<String?> deleteWithWithdraw({required int assetId}) => _run(
    (accountId) => _repository.deleteWithWithdraw(
      accountId: accountId,
      assetId: assetId,
    ),
  );

  Future<String?> deletePocket() => _run(
    (accountId) => _repository.delete(accountId),
  );

  Future<String?> _run(Future<void> Function(int accountId) action) async {
    final accountId = _accountId;
    if (accountId == null) return 'Terjadi kesalahan data pada aplikasi';
    try {
      await action(accountId);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
