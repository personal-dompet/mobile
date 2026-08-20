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
  startMonth,
  close;

  static BudgetPlanAction of(List<Budget> activeBudgets) {
    if (activeBudgets.isEmpty) return BudgetPlanAction.activate;
    final now = DateTime.now().secondsSinceEpoch;
    final coversToday = activeBudgets.any(
      (budget) => budget.periodStart <= now && now <= budget.periodEnd,
    );
    return coversToday ? BudgetPlanAction.close : BudgetPlanAction.startMonth;
  }
}

@freezed
sealed class BudgetPlanDetailState with _$BudgetPlanDetailState {
  const factory BudgetPlanDetailState.initial() = _BudgetPlanDetailInitial;
  const factory BudgetPlanDetailState.loading() = _BudgetPlanDetailLoading;
  const factory BudgetPlanDetailState.loaded({
    required BudgetPlan plan,
    required List<Budget> activeBudgets,
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
    emit(const BudgetPlanDetailState.loading());
    try {
      final plan = await _planRepository.getByAccountId(accountId);
      final activeBudgets = await _repository.getActiveBudgets(accountId);
      if (isClosed) return;
      if (plan == null) {
        emit(
          const BudgetPlanDetailState.error(
            message: 'Rencana tidak ditemukan',
          ),
        );
        return;
      }
      emit(
        BudgetPlanDetailState.loaded(
          plan: plan,
          activeBudgets: activeBudgets,
        ),
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

  Future<String?> closeBudgets() => _run(
    (accountId) => _repository.closeActiveBudgets(accountId),
  );

  Future<String?> closeAndStartMonth() => _run((accountId) async {
    await _repository.closeActiveBudgets(accountId);
    await _repository.createBudget(
      accountId: accountId,
      amount: _loadedAmount(),
      periode: DateTime.now(),
    );
  });

  Future<String?> deletePlan() => _run(
    (accountId) async {
      await _planRepository.delete(accountId);
    },
  );

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