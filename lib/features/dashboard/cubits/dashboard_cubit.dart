import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/accounts/model/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/dashboard/models/transaction_summary.dart';
import 'package:dompet_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_cubit.freezed.dart';

enum DashboardSectionStatus { initial, loading, loaded, error }

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(DashboardSectionStatus.initial)
    DashboardSectionStatus balanceStatus,
    @Default(0) int balance,
    String? balanceError,

    @Default(DashboardSectionStatus.initial)
    DashboardSectionStatus summaryStatus,
    @Default(TransactionSummary()) TransactionSummary summary,
    String? summarayError,

    @Default(DashboardSectionStatus.initial)
    DashboardSectionStatus recentActivitiesStatus,
    @Default([]) List<JournalEntry> recentActivities,
    String? recentActivitiesError,

    @Default(DashboardSectionStatus.initial)
    DashboardSectionStatus presetAssetAccountsStatus,
    @Default([]) List<Account> presetAssetAccounts,
    String? presetAssetAccountsError,
  }) = _DashboardState;
}

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;
  final AccountRepository _accountRepository;
  final JournalRepository _journalRepository;

  DashboardCubit(
    this._repository,
    this._accountRepository,
    this._journalRepository,
  ) : super(DashboardState());

  Future<void> init() async {
    await Future.wait([
      _getBalance(),
      _getRecentActivities(),
      _getSummary(),
      _getPresetAssetAccounts(),
    ]);
  }

  Future<void> _getBalance() async {
    emit(state.copyWith(balanceStatus: .loading));

    try {
      final balance = await _repository.getTotalLiquidBalance();
      emit(
        state.copyWith(
          balance: balance,
          balanceError: null,
          balanceStatus: .loaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(balanceStatus: .error, balanceError: e.toString()));
    }
  }

  Future<void> _getPresetAssetAccounts() async {
    emit(state.copyWith(presetAssetAccountsStatus: .loading));

    try {
      final filter = AccountFilter(isLiqid: true, isSystem: true, type: .asset);
      final presetAssetAccounts = await _accountRepository.getAccounts(filter);
      emit(
        state.copyWith(
          presetAssetAccounts: presetAssetAccounts,
          presetAssetAccountsError: null,
          presetAssetAccountsStatus: .loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          presetAssetAccountsStatus: .error,
          presetAssetAccountsError: e.toString(),
        ),
      );
    }
  }

  Future<void> _getSummary() async {
    emit(state.copyWith(summaryStatus: .loading));

    try {
      final summary = await _repository.getTransactionSummary();
      emit(
        state.copyWith(
          summary: summary,
          summarayError: null,
          summaryStatus: .loaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(summaryStatus: .error, summarayError: e.toString()));
    }
  }

  Future<void> _getRecentActivities() async {
    emit(state.copyWith(recentActivitiesStatus: .loading));

    try {
      final paginatedActivities = await _journalRepository.getJournals(
        pagination: Pagination(page: 1, limit: 5),
      );
      emit(
        state.copyWith(
          recentActivities: paginatedActivities.items,
          recentActivitiesError: null,
          recentActivitiesStatus: .loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          recentActivitiesStatus: .error,
          recentActivitiesError: e.toString(),
        ),
      );
    }
  }
}
