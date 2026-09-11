import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';
import 'package:dompet_app/features/bills/models/bill_filter.dart';
import 'package:dompet_app/features/bills/models/bill_plan_detail.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_plan_detail_cubit.freezed.dart';

@freezed
sealed class BillPlanDetailState with _$BillPlanDetailState {
  const factory BillPlanDetailState.initial() = _BillPlanDetailInitial;
  const factory BillPlanDetailState.loading({BillPlanDetail? detail}) =
      _BillPlanDetailLoading;
  const factory BillPlanDetailState.loaded({required BillPlanDetail detail}) =
      _BillPlanDetailLoaded;
  const factory BillPlanDetailState.error({required String message}) =
      _BillPlanDetailError;
}

class BillPlanDetailCubit extends Cubit<BillPlanDetailState> {
  BillPlanDetailCubit(
    this._planRepository,
    this._accountRepository,
    this._billRepository,
    this._savingRepository,
  ) : super(const BillPlanDetailState.initial());

  final BillPlanRepository _planRepository;
  final AccountRepository _accountRepository;
  final BillRepository _billRepository;
  final SavingRepository _savingRepository;

  int? _planId;

  Future<void> fetch(int planId) async {
    _planId = planId;
    final current = state.maybeWhen(
      loaded: (detail) => detail,
      orElse: () => null,
    );
    emit(BillPlanDetailState.loading(detail: current));
    try {
      final plan = await _planRepository.getById(planId);
      if (isClosed) return;
      if (plan == null) {
        emit(
          const BillPlanDetailState.error(
            message: 'Tagihan rutin tidak ditemukan',
          ),
        );
        return;
      }
      final category = await _accountRepository.getAccount(plan.accountId);
      final recent = await _billRepository.getBills(
        pagination: Pagination(page: 1, limit: 5),
        filter: BillFilter(billPlanId: planId),
      );
      if (isClosed) return;
      if (category == null) {
        emit(
          const BillPlanDetailState.error(message: 'Kategori tidak ditemukan'),
        );
        return;
      }
      final detail = BillPlanDetail(
        plan: plan,
        category: category,
        recentBills: recent.items,
        totalCount: recent.meta.total,
      );
      // Target sisihan kemunculan terdekat (hanya relevan untuk yearly).
      final linkedTarget = plan.period == BillPlanPeriodEnum.yearly.name
          ? await _savingRepository.getLinkedTarget(
              planId,
              _upcomingPeriodLabel(detail),
            )
          : null;
      if (isClosed) return;
      emit(
        BillPlanDetailState.loaded(
          detail: BillPlanDetail(
            plan: plan,
            category: category,
            recentBills: recent.items,
            totalCount: recent.meta.total,
            linkedTarget: linkedTarget,
          ),
        ),
      );
    } catch (e) {
      if (!isClosed) emit(BillPlanDetailState.error(message: e.toString()));
    }
  }

  Future<void> refresh() async {
    final planId = _planId;
    if (planId != null) await fetch(planId);
  }

  /// Kemunculan terdekat untuk prefill target sisihan baru
  /// (label + jatuh tempo). Null bila bukan loaded/yearly.
  ({String label, DateTime dueDate})? upcomingOccurrence() {
    final detail = state.maybeWhen(
      loaded: (detail) => detail,
      orElse: () => null,
    );
    if (detail == null) return null;
    final plan = detail.plan;
    if (plan.period != BillPlanPeriodEnum.yearly.name) return null;
    final billed = _upcomingBilled(detail);
    return (
      label: BillSchedule.billPeriodFor(billed, plan.period),
      dueDate: BillSchedule.dueDateFor(billed, plan.period, plan.dueDateSchedule),
    );
  }

  /// Hapus lemas plan + draft. Kembalikan pesan error bila gagal.
  Future<String?> deletePlan() async {
    final plan = state.maybeWhen(
      loaded: (detail) => detail.plan,
      orElse: () => null,
    );
    if (plan == null) return 'Terjadi kesalahan data pada aplikasi';
    try {
      await _planRepository.deletePlan(plan.id);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Samakan nominal target sisihan dengan nominal tagihan terkini.
  /// Kembalikan pesan error bila gagal.
  Future<String?> syncTargetAmount() async {    final detail = state.maybeWhen(
      loaded: (detail) => detail,
      orElse: () => null,
    );
    final target = detail?.linkedTarget;
    if (detail == null || target == null) {
      return 'Terjadi kesalahan data pada aplikasi';
    }
    try {
      await _savingRepository.updateTargetAmount(
        accountId: target.accountId,
        targetAmount: detail.plan.amount,
      );
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

/// Label kemunculan terdekat yang sedang ditagih/disicil:
/// tagihan aktif terdekat bila ada, jika tidak jadwal billed berikutnya.
String _upcomingPeriodLabel(BillPlanDetail detail) =>
    BillSchedule.billPeriodFor(_upcomingBilled(detail), detail.plan.period);

/// Tanggal billed kemunculan terdekat.
DateTime _upcomingBilled(BillPlanDetail detail) {
  final next = detail.nextActive;
  if (next != null) {
    return DateTime.fromMillisecondsSinceEpoch(next.billedAt * 1000);
  }
  final plan = detail.plan;
  return BillSchedule.nextBilled(
    DateTime.now(),
    plan.period,
    plan.billedSchedule,
  );
}
