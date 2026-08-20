import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/budgets/models/account_budget_status.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_budget_status_cubit.freezed.dart';

@freezed
sealed class AccountBudgetStatusState with _$AccountBudgetStatusState {
  const factory AccountBudgetStatusState.initial() = _AccountBudgetStatusInitial;
  const factory AccountBudgetStatusState.loading() = _AccountBudgetStatusLoading;
  const factory AccountBudgetStatusState.loaded({
    required AccountBudgetStatus status,
  }) = _AccountBudgetStatusLoaded;
  const factory AccountBudgetStatusState.error({required String message}) =
      _AccountBudgetStatusError;
}

class AccountBudgetStatusCubit extends Cubit<AccountBudgetStatusState> {
  AccountBudgetStatusCubit(this._repository)
    : super(const AccountBudgetStatusState.initial());

  final BudgetRepository _repository;

  Future<AccountBudgetStatus?> fetch() async {
    emit(const AccountBudgetStatusState.loading());
    try {
      final status = await _repository.getAccountStatuses();
      if (isClosed) return status;
      emit(AccountBudgetStatusState.loaded(status: status));
      return status;
    } catch (e) {
      if (isClosed) return null;
      emit(AccountBudgetStatusState.error(message: e.toString()));
      return null;
    }
  }
}