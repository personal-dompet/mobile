import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
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
  SavingDetailCubit(this._repository, [this._billRepository])
    : super(const SavingDetailState.initial());

  final SavingRepository _repository;

  /// Opsional agar konstruksi lama (termasuk test) tetap jalan;
  /// tanpa ini section tagihan ter-link disembunyikan.
  final BillRepository? _billRepository;

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
      final linkedBill = await _loadLinkedBill(plan);
      if (isClosed) return;
      emit(
        SavingDetailState.loaded(
          detail: SavingDetail.compute(
            plan: plan,
            activities: activities,
            now: DateTime.now(),
            linkedBill: linkedBill,
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

  /// Tagihan kemunculan ter-link target sisihan. Null bila target biasa,
  /// repo tagihan tak tersedia, atau tagihan belum tergenerate.
  Future<Bill?> _loadLinkedBill(SavingPlan plan) async {
    final billRepository = _billRepository;
    final planId = plan.billPlanId;
    final period = plan.billPeriod;
    if (billRepository == null || planId == null || period == null) {
      return null;
    }
    return billRepository.getBillByPlanAndPeriod(planId, period);
  }

  /// Bayar tagihan ter-link dari pocket ini via dompet perantara [assetId].
  /// Kembalikan pesan error bila gagal (termasuk bila tak ada tagihan).
  Future<String?> payLinkedBill({required int assetId}) async {
    final billRepository = _billRepository;
    final accountId = _accountId;
    if (billRepository == null || accountId == null) {
      return 'Terjadi kesalahan data pada aplikasi';
    }
    final bill = state.maybeWhen(
      loaded: (detail) => detail.linkedBill,
      orElse: () => null,
    );
    if (bill == null) return 'Tagihan terkait belum tersedia';
    try {
      await billRepository.payBillFromPocket(
        billId: bill.id,
        pocketId: accountId,
        assetId: assetId,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

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
