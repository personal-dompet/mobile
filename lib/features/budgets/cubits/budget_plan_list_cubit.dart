import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/models/budget_plan.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_plan_list_cubit.freezed.dart';

@freezed
sealed class BudgetPlanListState with _$BudgetPlanListState {
  const factory BudgetPlanListState.initial() = _BudgetPlanListInitial;
  const factory BudgetPlanListState.loading() = _BudgetPlanListLoading;
  const factory BudgetPlanListState.loaded({
    @Default([]) List<({BudgetPlan plan, Account category})> items,
  }) = _BudgetPlanListLoaded;
  const factory BudgetPlanListState.error({required String message}) =
      _BudgetPlanListError;
}

class BudgetPlanListCubit extends Cubit<BudgetPlanListState> {
  BudgetPlanListCubit(this._repository)
    : super(const BudgetPlanListState.initial());

  final BudgetPlanRepository _repository;

  Future<void> fetch() async {
    emit(const BudgetPlanListState.loading());
    try {
      final items = await _repository.getPlansWithCategories();
      if (isClosed) return;
      emit(BudgetPlanListState.loaded(items: items));
    } catch (e) {
      if (!isClosed) emit(BudgetPlanListState.error(message: e.toString()));
    }
  }

  Future<void> refresh() => fetch();
}
