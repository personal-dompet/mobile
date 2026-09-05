import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/reports/cubits/report_cubit.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'report_test_helpers.dart';

const _sep = ReportPeriod(year: 2026, month: 9);
const _aug = ReportPeriod(year: 2026, month: 8);

Future<ReportCubit> _createCubit(ReportTestDeps deps) async {
  final cubit = ReportCubit(
    ReportRepository(deps.db),
    BudgetRepository(deps.db),
  );
  addTearDown(() => cubit.close());
  return cubit;
}

/// Beri kesempatan event stream cubit terkirim ke listener sebelum assert.
Future<void> _flushEvents() =>
    Future<void>.delayed(const Duration(milliseconds: 50));

Future<void> _seedSeptember(ReportTestDeps deps) async {
  await insertTransaction(
    db: deps.db,
    date: DateTime(2026, 9, 3),
    assetId: deps.cashId,
    categoryId: deps.salaryId,
    amount: 8000000,
    isExpense: false,
  );
  await insertTransaction(
    db: deps.db,
    date: DateTime(2026, 9, 10),
    assetId: deps.cashId,
    categoryId: deps.foodId,
    amount: 5700000,
    isExpense: true,
  );
}

void main() {
  group('ReportCubit anti-kedip', () {
    test('load pertama: loading lalu loaded', () async {
      final deps = await createReportTestDeps();
      addTearDown(() => deps.dispose());
      final cubit = await _createCubit(deps);
      await _seedSeptember(deps);

      final statuses = <ReportStatus>[];
      final sub = cubit.stream.listen((s) => statuses.add(s.status));

      await cubit.loadMonth(_sep);
      await _flushEvents();

      expect(cubit.state.status, ReportStatus.loaded);
      expect(cubit.state.summary?.income, 8000000);
      expect(statuses, [ReportStatus.loading, ReportStatus.loaded]);
      await sub.cancel();
    });

    test('ganti bulan saat ada data: refreshing, data lama utuh', () async {
      final deps = await createReportTestDeps();
      addTearDown(() => deps.dispose());
      final cubit = await _createCubit(deps);
      await _seedSeptember(deps);

      await cubit.loadMonth(_sep);
      // Tunggu prefetch tetangga selesai agar tidak mengotori status.
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final statuses = <ReportStatus>[];
      final sub = cubit.stream.listen((s) => statuses.add(s.status));

      // Agustus belum di-cache? Sudah di-prefetch sebagai tetangga —
      // paksa miss dengan mengosongkan via refresh() dulu? Tidak:
      // justru uji cache hit di test berikutnya. Di sini pakai bulan
      // yang pasti miss: 2026-01 (di luar jangkauan prefetch).
      const january = ReportPeriod(year: 2026, month: 1);
      await cubit.loadMonth(january);
      await _flushEvents();

      expect(statuses.first, ReportStatus.refreshing);
      expect(statuses.last, ReportStatus.loaded);
      // Selama refreshing, periode langsung pindah dan data lama tampil.
      expect(cubit.state.period, january);
      expect(cubit.state.summary?.income, 0);
      await sub.cancel();
    });

    test('bulan ter-cache: loaded instan tanpa loading/refreshing', () async {
      final deps = await createReportTestDeps();
      addTearDown(() => deps.dispose());
      final cubit = await _createCubit(deps);
      await _seedSeptember(deps);

      await cubit.loadMonth(_sep);
      await cubit.loadMonth(_aug);
      // Beri waktu revalidasi/prefetch background selesai.
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final statuses = <ReportStatus>[];
      final sub = cubit.stream.listen((s) => statuses.add(s.status));

      await cubit.loadMonth(_sep);
      // Revalidasi diam-diam mungkin menyusul emit loaded; yang penting
      // tidak ada loading/refreshing (tidak ada kedip).
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(
        statuses.any(
          (s) => s == ReportStatus.loading || s == ReportStatus.refreshing,
        ),
        isFalse,
      );
      expect(statuses, contains(ReportStatus.loaded));
      expect(cubit.state.summary?.income, 8000000);
      await sub.cancel();
    });

    test('refresh() memantulkan transaksi baru', () async {
      final deps = await createReportTestDeps();
      addTearDown(() => deps.dispose());
      final cubit = await _createCubit(deps);
      await _seedSeptember(deps);

      await cubit.loadMonth(_sep);
      expect(cubit.state.summary?.expense, 5700000);

      await insertTransaction(
        db: deps.db,
        date: DateTime(2026, 9, 20),
        assetId: deps.cashId,
        categoryId: deps.foodId,
        amount: 300000,
        isExpense: true,
      );
      await cubit.refresh();

      expect(cubit.state.status, ReportStatus.loaded);
      expect(cubit.state.summary?.expense, 6000000);
    });
  });
}
