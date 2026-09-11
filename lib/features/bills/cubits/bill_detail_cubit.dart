import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/bills/models/bill_detail.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_detail_cubit.freezed.dart';

@freezed
sealed class BillDetailState with _$BillDetailState {
  const factory BillDetailState.initial() = _BillDetailInitial;
  const factory BillDetailState.loading({BillDetail? detail}) =
      _BillDetailLoading;
  const factory BillDetailState.loaded({required BillDetail detail}) =
      _BillDetailLoaded;
  const factory BillDetailState.error({required String message}) =
      _BillDetailError;
}

class BillDetailCubit extends Cubit<BillDetailState> {
  BillDetailCubit(
    this._billRepository,
    this._planRepository,
    this._accountRepository,
  ) : super(const BillDetailState.initial());

  final BillRepository _billRepository;
  final BillPlanRepository _planRepository;
  final AccountRepository _accountRepository;

  int? _billId;

  Future<void> fetch(int billId) async {
    _billId = billId;
    final current = state.maybeWhen(
      loaded: (detail) => detail,
      orElse: () => null,
    );
    emit(BillDetailState.loading(detail: current));
    try {
      final bill = await _billRepository.getBillById(billId);
      if (isClosed) return;
      if (bill == null) {
        emit(const BillDetailState.error(message: 'Tagihan tidak ditemukan'));
        return;
      }
      final plan = await _planRepository.getById(bill.billPlanId);
      final category = plan == null
          ? null
          : await _accountRepository.getAccount(plan.accountId);
      final journals = await _billRepository.getBillJournals(billId);
      if (isClosed) return;
      if (plan == null || category == null) {
        emit(
          const BillDetailState.error(
            message: 'Data tagihan tidak lengkap',
          ),
        );
        return;
      }
      emit(
        BillDetailState.loaded(
          detail: BillDetail(
            bill: bill,
            plan: plan,
            category: category,
            journals: journals,
          ),
        ),
      );
    } catch (e) {
      if (!isClosed) emit(BillDetailState.error(message: e.toString()));
    }
  }

  Future<void> refresh() async {
    final billId = _billId;
    if (billId != null) await fetch(billId);
  }

  /// Bayar lunas dari dompet. Kembalikan pesan error bila gagal.
  Future<String?> payBill(int assetId) async {
    final billId = _billId;
    if (billId == null) return 'Terjadi kesalahan data pada aplikasi';
    try {
      await _billRepository.payBill(billId: billId, assetId: assetId);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
