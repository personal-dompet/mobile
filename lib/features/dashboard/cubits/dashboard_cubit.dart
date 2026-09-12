import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/bills/repositories/bill_repository.dart';
import 'package:dompet_app/features/dashboard/models/transaction_summary.dart';
import 'package:dompet_app/features/dashboard/repositories/dashboard_repository.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
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

    /// Total tagihan tertunda (banner). Null = belum dimuat/gagal → sembunyi.
    int? pendingBillsTotal,

    /// Tagihan unpaid yang sudah diingatkan (reminded_at <= now).
    /// Null = belum dimuat/gagal → sembunyi.
    int? remindedDueCount,
    int? remindedOverdueCount,

    /// Jumlah dompet cair (subtitle). Null = belum dimuat/gagal → sembunyi.
    int? liquidAssetCount,

    /// Ringkasan bulan ini (subtitle + kartu laporan). Null = memuat.
    int? monthAllocated,
    int? monthlyIncome,
    int? monthlyExpense,
  }) = _DashboardState;
}

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;
  final AccountRepository _accountRepository;
  final JournalRepository _journalRepository;

  /// Opsional (aturan 7): agar widget dashboard tetap via 1 cubit data.
  final ReportRepository? _reportRepository;
  final BillRepository? _billRepository;

  DashboardCubit(
    this._repository,
    this._accountRepository,
    this._journalRepository, [
    this._reportRepository,
    this._billRepository,
  ]) : super(DashboardState());

  Future<void> init() async {
    await Future.wait([
      _getBalance(),
      _getRecentActivities(),
      _getSummary(),
      _getPresetAssetAccounts(),
      _getPendingBills(),
      _getRemindedBills(),
      _getLiquidAssetCount(),
      _getMonthlyFigures(),
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
      final presetAssetAccounts = await _accountRepository.getAccounts(
        filter: filter,
      );
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

  /// Total tagihan tertunda untuk banner (aturan 5: masuk state flow).
  Future<void> _getPendingBills() async {
    try {
      final total = await _billRepository?.getPendingTotal() ?? 0;
      if (!isClosed) emit(state.copyWith(pendingBillsTotal: total));
    } catch (_) {
      if (!isClosed) emit(state.copyWith(pendingBillsTotal: null));
    }
  }

  /// Jumlah tagihan yang sudah diingatkan untuk kartu dashboard.
  Future<void> _getRemindedBills() async {
    try {
      final counts = await _billRepository?.getRemindedCounts() ??
          (dueSoon: 0, overdue: 0);
      if (!isClosed) {
        emit(
          state.copyWith(
            remindedDueCount: counts.dueSoon,
            remindedOverdueCount: counts.overdue,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(remindedDueCount: null, remindedOverdueCount: null),
        );
      }
    }
  }

  /// Jumlah dompet cair untuk subtitle (aturan 5: masuk state flow).
  Future<void> _getLiquidAssetCount() async {
    try {
      final accounts = await _accountRepository.getAccounts(
        filter: const AccountFilter(
          isSystem: false,
          isLiqid: true,
          type: AccountType.asset,
        ),
      );
      if (!isClosed) emit(state.copyWith(liquidAssetCount: accounts.length));
    } catch (_) {
      if (!isClosed) emit(state.copyWith(liquidAssetCount: null));
    }
  }

  /// Angka bulan ini untuk subtitle + kartu laporan (aturan 5: satu flow).
  Future<void> _getMonthlyFigures() async {
    try {
      final reportRepository = _reportRepository;
      if (reportRepository == null) return;
      final summary = await reportRepository.getMonthlySummary(
        ReportPeriod.currentMonth(),
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            monthAllocated: summary.netSaving,
            monthlyIncome: summary.income,
            monthlyExpense: summary.expense,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            monthAllocated: null,
            monthlyIncome: null,
            monthlyExpense: null,
          ),
        );
      }
    }
  }

  Future<void> _getRecentActivities() async {    emit(state.copyWith(recentActivitiesStatus: .loading));

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
