import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/bills/models/bill_filter.dart';
import 'package:dompet_app/features/bills/models/bill_plan_detail.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
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
  ) : super(const BillPlanDetailState.initial());

  final BillPlanRepository _planRepository;
  final AccountRepository _accountRepository;
  final BillRepository _billRepository;

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
      emit(
        BillPlanDetailState.loaded(
          detail: BillPlanDetail(
            plan: plan,
            category: category,
            recentBills: recent.items,
            totalCount: recent.meta.total,
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
}
