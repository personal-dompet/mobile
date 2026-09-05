import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/reports/models/budget_spending.dart';
import 'package:dompet_app/features/reports/models/category_spending.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:dompet_app/features/reports/models/period_comparison.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';

enum ReportStatus {
  initial,
  loading,
  refreshing,
  loaded,
  error,
}

class ReportState {
  const ReportState({
    this.status = ReportStatus.initial,
    required this.period,
    this.summary,
    this.comparison,
    this.categorySpending = const [],
    this.budgetSpending = const [],
    this.trend = const [],
    this.errorMessage,
  });

  final ReportStatus status;
  final ReportPeriod period;
  final MonthlySummary? summary;
  final PeriodComparison? comparison;
  final List<CategorySpending> categorySpending;

  /// Anggaran vs aktual bulan laporan (lihat [BudgetSpending]).
  final List<BudgetSpending> budgetSpending;

  /// Tren bulanan tertua → terbaru (lihat [ReportRepository.getTrend]).
  final List<MonthlySummary> trend;
  final String? errorMessage;

  ReportState copyWith({
    ReportStatus? status,
    ReportPeriod? period,
    MonthlySummary? summary,
    PeriodComparison? comparison,
    List<CategorySpending>? categorySpending,
    List<BudgetSpending>? budgetSpending,
    List<MonthlySummary>? trend,
    String? errorMessage,
  }) {
    return ReportState(
      status: status ?? this.status,
      period: period ?? this.period,
      summary: summary ?? this.summary,
      comparison: comparison ?? this.comparison,
      categorySpending: categorySpending ?? this.categorySpending,
      budgetSpending: budgetSpending ?? this.budgetSpending,
      trend: trend ?? this.trend,
      errorMessage: errorMessage,
    );
  }
}

/// Cubit laporan bulanan.
///
/// Pola sama seperti [DashboardCubit]: repository untuk data,
/// cubit hanya orkestrasi loading/error.
///
/// Anti-kedip saat ganti bulan:
/// - Data lama tetap dipertahankan dan langsung ditampilkan dengan status
///   [ReportStatus.refreshing] (spinner penuh hanya saat buka pertama).
/// - Hasil per bulan di-cache; bulan sebelum & sesudahnya di-prefetch
///   sehingga pindah bulan yang sudah dikunjungi bersifat instan.
class ReportCubit extends Cubit<ReportState> {
  ReportCubit(this._repository, this._budgetRepository)
    : super(
        ReportState(period: ReportPeriod.currentMonth()),
      );

  final ReportRepository _repository;
  final BudgetRepository _budgetRepository;

  static const int _maxCacheSize = 5;

  final Map<ReportPeriod, _CachedMonth> _cache = {};
  final Set<ReportPeriod> _inFlight = {};

  Future<void> loadMonth(ReportPeriod period) async {
    final cached = _cache[period];
    if (cached != null) {
      // Cache hit: tampil instan, lalu revalidasi diam-diam.
      _touch(period);
      if (isClosed) return;
      emit(cached.applyTo(state.copyWith(period: period)));
      unawaited(_revalidate(period));
      _prefetchNeighbors(period);
      return;
    }

    final hasData = state.summary != null;
    emit(
      state.copyWith(
        status: hasData ? ReportStatus.refreshing : ReportStatus.loading,
        period: period,
      ),
    );
    try {
      final data = await _fetchMonth(period);
      if (isClosed) return;
      _store(period, data);
      emit(data.applyTo(state.copyWith(status: ReportStatus.loaded)));
      _prefetchNeighbors(period);
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ReportStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> loadCurrentMonth() =>
      loadMonth(ReportPeriod.currentMonth());

  Future<void> loadPreviousMonth() =>
      loadMonth(ReportPeriod.currentMonth().previous);

  /// Muat ulang periode aktif. Cache dibuang karena ada data baru
  /// yang bisa memengaruhi ringkasan, tren tetangga, maupun
  /// perbandingan — data lama tetap tampil selama reload.
  Future<void> refresh() {
    _cache.clear();
    return loadMonth(state.period);
  }

  /// Ambil ulang data [period] tanpa mengubah status tampil.
  /// Emit hanya bila periode tersebut masih yang sedang dibuka.
  Future<void> _revalidate(ReportPeriod period) async {
    try {
      final data = await _fetchMonth(period);
      if (isClosed) return;
      _store(period, data);
      if (state.period == period && state.status == ReportStatus.loaded) {
        emit(data.applyTo(state.copyWith()));
      }
    } catch (_) {
      // Abaikan: pengguna tetap melihat data cache yang valid.
    }
  }

  /// Prefetch bulan SEBELUM dan SESUDAH [period] (yang belum di-cache).
  /// Tidak pernah melompat ke masa depan.
  void _prefetchNeighbors(ReportPeriod period) {
    final current = ReportPeriod.currentMonth();
    final candidates = [period.previous, period.next];
    for (final candidate in candidates) {
      if (candidate.year > current.year ||
          (candidate.year == current.year &&
              candidate.month > current.month)) {
        continue;
      }
      unawaited(_prefetch(candidate));
    }
  }

  Future<void> _prefetch(ReportPeriod period) async {
    if (_cache.containsKey(period) || !_inFlight.add(period)) return;
    try {
      final data = await _fetchMonth(period);
      if (!isClosed) _store(period, data);
    } catch (_) {
      // Prefetch best-effort: kegagalan tidak mengganggu halaman.
    } finally {
      _inFlight.remove(period);
    }
  }

  Future<_MonthData> _fetchMonth(ReportPeriod period) async {
    final results = await Future.wait([
      _repository.getComparison(period),
      _repository.getExpenseByCategory(period),
      _repository.getTrend(period),
      _budgetRepository.getBudgetsForMonth(period),
      _repository.getExpenseByCategory(period.previous),
    ]);
    final comparison = results[0] as PeriodComparison;
    final categories = results[1] as List<CategorySpending>;
    final trend = results[2] as List<MonthlySummary>;
    final budgets = results[3] as List<Budget>;
    final previousCategories = results[4] as List<CategorySpending>;
    final previousByAccount = {
      for (final item in previousCategories) item.accountId: item.amount,
    };
    return _MonthData(
      summary: comparison.current,
      comparison: comparison,
      categorySpending: categories,
      trend: trend,
      budgetSpending: [
        for (final budget in budgets)
          BudgetSpending(
            budget: budget,
            previousSpent: previousByAccount[budget.accountId] ?? 0,
          ),
      ],
    );
  }

  void _store(ReportPeriod period, _MonthData data) {
    // LRU sederhana: Map Dart mempertahankan urutan insert.
    _cache.remove(period);
    while (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[period] = _CachedMonth(data: data);
  }

  void _touch(ReportPeriod period) {
    final cached = _cache.remove(period);
    if (cached != null) _cache[period] = cached;
  }
}

/// Hasil agregasi satu bulan, siap ditempel ke state / cache.
class _MonthData {
  const _MonthData({
    required this.summary,
    required this.comparison,
    required this.categorySpending,
    required this.trend,
    required this.budgetSpending,
  });

  final MonthlySummary summary;
  final PeriodComparison comparison;
  final List<CategorySpending> categorySpending;
  final List<MonthlySummary> trend;
  final List<BudgetSpending> budgetSpending;

  ReportState applyTo(ReportState state) {
    return state.copyWith(
      status: ReportStatus.loaded,
      summary: summary,
      comparison: comparison,
      categorySpending: categorySpending,
      trend: trend,
      budgetSpending: budgetSpending,
      errorMessage: null,
    );
  }
}

class _CachedMonth {
  const _CachedMonth({required this.data});

  final _MonthData data;

  ReportState applyTo(ReportState state) => data.applyTo(state);
}
