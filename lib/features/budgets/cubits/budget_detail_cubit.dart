import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/budgets/models/budget_detail.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/journals/models/journal_filter.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_detail_cubit.freezed.dart';

@freezed
sealed class BudgetDetailState with _$BudgetDetailState {
  const factory BudgetDetailState.initial() = _BudgetDetailInitial;
  const factory BudgetDetailState.loading() = _BudgetDetailLoading;
  const factory BudgetDetailState.loaded({required BudgetDetail detail}) =
      _BudgetDetailLoaded;
  const factory BudgetDetailState.error({required String message}) =
      _BudgetDetailError;
}

class BudgetDetailCubit extends Cubit<BudgetDetailState> {
  BudgetDetailCubit(
    this._budgetRepository,
    this._accountRepository,
    this._journalRepository,
  ) : super(const BudgetDetailState.initial());

  final BudgetRepository _budgetRepository;
  final AccountRepository _accountRepository;
  final JournalRepository _journalRepository;

  int? _budgetId;

  Future<void> fetch(int budgetId) async {
    _budgetId = budgetId;
    emit(const BudgetDetailState.loading());
    try {
      final budget = await _budgetRepository.getBudgetById(budgetId);
      if (budget == null) {
        emit(
          const BudgetDetailState.error(message: 'Anggaran tidak ditemukan'),
        );
        return;
      }
      final category = await _accountRepository.getAccount(budget.accountId);
      if (category == null) {
        emit(
          const BudgetDetailState.error(message: 'Kategori tidak ditemukan'),
        );
        return;
      }
      final filter = JournalFilter(
        accountId: budget.accountId,
        dates: (budget.periodStartDate, budget.periodEndDate),
      );
      final activities = await _journalRepository.getJournalsByFilter(filter);
      if (isClosed) return;
      final detail = BudgetDetail(
        budget: budget,
        category: category,
        activities: activities,
        totalCount: activities.length,
      );
      emit(BudgetDetailState.loaded(detail: detail));
    } catch (e) {
      if (!isClosed) emit(BudgetDetailState.error(message: e.toString()));
    }
  }

  Future<void> refresh() async {
    final id = _budgetId;
    if (id != null) await fetch(id);
  }

  Future<String?> closeBudget() async {
    final current = state.maybeWhen(
      orElse: () => null,
      loaded: (detail) => detail,
    );
    if (current == null) return 'Data anggaran belum dimuat';
    if (!current.canClose) return 'Anggaran belum melewati periode';
    try {
      await _budgetRepository.closeActiveBudgets(current.budget.accountId);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> closeAndCreate({int carryAmount = 0}) async {
    final current = state.maybeWhen(
      orElse: () => null,
      loaded: (detail) => detail,
    );
    if (current == null) return 'Data anggaran belum dimuat';
    if (!current.canClose) return 'Anggaran belum melewati periode';
    try {
      final accountId = current.budget.accountId;
      final amount = current.budget.budgetAmount;
      await _budgetRepository.closeActiveBudgets(accountId);
      await _budgetRepository.createBudget(
        accountId: accountId,
        amount: amount,
        periode: DateTime.now(),
        carryAmount: carryAmount,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
