import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/budgets/models/budget_plan.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_plan_detail_cubit.freezed.dart';

enum BudgetPlanAction {
  activate,
  close;

  static BudgetPlanAction? of(Budget? activeBudget) {
    if (activeBudget == null) return BudgetPlanAction.activate;
    final now = DateTime.now().secondsSinceEpoch;
    final budgetExpired = now > activeBudget.periodEnd;
    return budgetExpired ? BudgetPlanAction.close : null;
  }
}

@freezed
sealed class BudgetPlanDetailState with _$BudgetPlanDetailState {
  const factory BudgetPlanDetailState.initial() = _BudgetPlanDetailInitial;
  const factory BudgetPlanDetailState.loading({
    BudgetPlan? plan,
    Budget? activeBudget,
  }) = _BudgetPlanDetailLoading;
  const factory BudgetPlanDetailState.loaded({
    required BudgetPlan plan,
    Budget? activeBudget,
  }) = _BudgetPlanDetailLoaded;
  const factory BudgetPlanDetailState.error({required String message}) =
      _BudgetPlanDetailError;
}

class BudgetPlanDetailCubit extends Cubit<BudgetPlanDetailState> {
  BudgetPlanDetailCubit(this._repository, this._planRepository)
    : super(const BudgetPlanDetailState.initial());

  final BudgetRepository _repository;
  final BudgetPlanRepository _planRepository;

  int? _accountId;

  Future<void> fetch(int accountId) async {
    _accountId = accountId;
    final currentPlan = state.maybeWhen(
      loaded: (plan, _) => plan,
      orElse: () => null,
    );
    final currentActiveBudget = state.maybeWhen(
      loaded: (_, activeBudget) => activeBudget,
      orElse: () => null,
    );
    emit(
      BudgetPlanDetailState.loading(
        activeBudget: currentActiveBudget,
        plan: currentPlan,
      ),
    );
    try {
      final plan = await _planRepository.getByAccountId(accountId);
      final activeBudgets = await _repository.getActiveBudget(accountId);
      if (isClosed) return;
      if (plan == null) {
        emit(
          const BudgetPlanDetailState.error(message: 'Rencana tidak ditemukan'),
        );
        return;
      }
      emit(
        BudgetPlanDetailState.loaded(plan: plan, activeBudget: activeBudgets),
      );
    } catch (e) {
      if (!isClosed) emit(BudgetPlanDetailState.error(message: e.toString()));
    }
  }

  Future<String?> activate() => _run(
    (accountId) => _repository.createBudget(
      accountId: accountId,
      amount: _loadedAmount(),
      periode: DateTime.now(),
    ),
  );

  Future<String?> closeBudgets() =>
      _run((accountId) => _repository.closeActiveBudgets(accountId));

  Future<String?> closeAndStartMonth({int carryAmount = 0}) => _run((accountId) async {
    final activeBudget = await _repository.getActiveBudget(_accountId!);
    if (activeBudget == null) return;
    await _repository.closeActiveBudgets(accountId);
    await _repository.createBudget(
      accountId: accountId,
      amount: _loadedAmount(),
      periode: DateTime.now(),
      carryAmount: carryAmount,
    );
  });

  Future<String?> deletePlan() => _run((accountId) async {
    await _planRepository.delete(accountId);
  });

  int _loadedAmount() {
    final amount = state.maybeWhen(
      loaded: (plan, _) => plan.amount,
      orElse: () => null,
    );
    if (amount == null) {
      throw Exception('Rencana belum dimuat');
    }
    return amount;
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
