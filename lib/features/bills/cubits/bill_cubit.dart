import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/models/bill_filter.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_cubit.freezed.dart';

@freezed
sealed class BillState with _$BillState {
  const factory BillState.initial() = _BillInitial;
  const factory BillState.loading() = _BillLoading;
  const factory BillState.loaded({
    @Default([]) List<Bill> attention,
    @Default([]) List<Bill> upcoming,
    @Default([]) List<Bill> recentPaid,
  }) = _BillLoaded;
  const factory BillState.error({required String message}) = _BillError;
}

/// Daftar bayar: sinkronisasi malas dulu, lalu kelompokkan.
/// Perlu Dibayar = pengingat tiba / terlambat; Mendatang = sisanya.
class BillCubit extends Cubit<BillState> {
  BillCubit(this._repository) : super(const BillState.initial());

  final BillRepository _repository;

  String? _lastKeyword;

  /// Kembalikan jumlah tagihan tersentuh sinkronisasi (untuk sinyal refresh).
  Future<int> fetch({String? keyword}) async {
    _lastKeyword = keyword;
    emit(const BillState.loading());
    try {
      final touched = await _repository.synchronizeBills();
      final actives = await _repository.getActiveBills(planKeyword: keyword);
      final now = DateTime.now();
      final attention = actives
          .where((b) => b.isDueReminderAt(now) || b.isOverdueAt(now))
          .toList();
      final upcoming = actives
          .where((b) => !b.isDueReminderAt(now) && !b.isOverdueAt(now))
          .toList();
      final paid = await _repository.getBills(
        pagination: const Pagination(page: 1, limit: 10),
        filter: BillFilter(
          statuses: [BillStatus.paid.value],
          planName: keyword,
        ),
      );
      if (isClosed) return touched;
      emit(
        BillState.loaded(
          attention: attention,
          upcoming: upcoming,
          recentPaid: paid.items,
        ),
      );
      return touched;
    } catch (e) {
      if (!isClosed) emit(BillState.error(message: e.toString()));
      return 0;
    }
  }

  Future<int> refresh() => fetch(keyword: _lastKeyword);
}
