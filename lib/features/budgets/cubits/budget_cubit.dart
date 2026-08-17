import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/budgets/models/budget_filter.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_cubit.freezed.dart';

@freezed
sealed class BudgetState with _$BudgetState {
  const factory BudgetState.initial() = _BudgetInitial;
  const factory BudgetState.loading() = _BudgetLoading;
  const factory BudgetState.refreshing({@Default([]) List<Budget> budgets}) =
      _BudgetRefreshing;
  const factory BudgetState.loaded({@Default([]) List<Budget> budgets}) =
      _BudgetLoaded;
  const factory BudgetState.error({required String message}) = _BudgetError;
}

class BudgetCubit extends Cubit<BudgetState> {
  final BudgetRepository _repository;
  BudgetCubit(this._repository) : super(const BudgetState.initial());

  String? _lastKeyword;

  Future<void> fetch({String? keyword}) async {
    _lastKeyword = keyword;

    emit(BudgetState.loading());
    await _loadAccounts(keyword: keyword);
  }

  Future<void> refresh() async {
    final currentCategories = state.maybeWhen(
      loaded: (categories) => categories,
      orElse: () => <Budget>[],
    );

    emit(BudgetState.refreshing(budgets: currentCategories));
    await _loadAccounts(keyword: _lastKeyword);
  }

  Future<void> _loadAccounts({String? keyword}) async {
    final filter = BudgetFilter(accountName: keyword);

    try {
      final budgets = await _repository.getBudgets(filter);
      emit(BudgetState.loaded(budgets: budgets));
    } catch (e) {
      emit(BudgetState.error(message: e.toString()));
    }
  }
}
