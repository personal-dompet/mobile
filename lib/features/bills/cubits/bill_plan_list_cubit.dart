import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/bills/repositories/bill_plan_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_plan_list_cubit.freezed.dart';

@freezed
sealed class BillPlanListState with _$BillPlanListState {
  const factory BillPlanListState.initial() = _BillPlanListInitial;
  const factory BillPlanListState.loading() = _BillPlanListLoading;
  const factory BillPlanListState.loaded({
    @Default([]) List<({BillPlan plan, Account category})> items,
  }) = _BillPlanListLoaded;
  const factory BillPlanListState.error({required String message}) =
      _BillPlanListError;
}

class BillPlanListCubit extends Cubit<BillPlanListState> {
  BillPlanListCubit(this._repository)
    : super(const BillPlanListState.initial());

  final BillPlanRepository _repository;

  String? _lastKeyword;

  Future<void> fetch({String? keyword}) async {
    _lastKeyword = keyword;
    emit(const BillPlanListState.loading());
    try {
      final items = await _repository.getPlansWithCategories(
        nameKeyword: keyword,
      );
      if (isClosed) return;
      emit(BillPlanListState.loaded(items: items));
    } catch (e) {
      if (!isClosed) emit(BillPlanListState.error(message: e.toString()));
    }
  }

  Future<void> refresh() => fetch(keyword: _lastKeyword);
}
