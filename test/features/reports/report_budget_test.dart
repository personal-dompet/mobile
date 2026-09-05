import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/reports/cubits/report_cubit.dart';
import 'package:dompet_app/features/reports/models/budget_spending.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';
import 'package:dompet_app/features/reports/repositories/report_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'report_test_helpers.dart';

void main() {
  group('BudgetRepository.getBudgetsForMonth', () {
    test('anggaran September kembali dengan actualSpend view', () async {
      final deps = await createReportTestDeps();
      addTearDown(() => deps.dispose());
      final budgets = BudgetRepository(deps.db);

      await budgets.createBudget(
        accountId: deps.foodId,
        amount: 2000000,
        periode: DateTime(2026, 9, 15),
      );
      await insertTransaction(
        db: deps.db,
        date: DateTime(2026, 9, 10),
        assetId: deps.cashId,
        categoryId: deps.foodId,
        amount: 1800000,
        isExpense: true,
      );

      final result = await budgets.getBudgetsForMonth(
        const ReportPeriod(year: 2026, month: 9),
      );

      expect(result.length, 1);
      expect(result.single.accountId, deps.foodId);
      expect(result.single.budgetAmount, 2000000);
      expect(result.single.actualSpend, 1800000);
    });

    test('anggaran bulan lain dikecualikan, yang ditutup tetap kembali',
        () async {
      final deps = await createReportTestDeps();
      addTearDown(() => deps.dispose());
      final budgets = BudgetRepository(deps.db);

      await budgets.createBudget(
        accountId: deps.foodId,
        amount: 2000000,
        periode: DateTime(2026, 8, 15),
      );
      await budgets.createBudget(
        accountId: deps.foodId,
        amount: 2500000,
        periode: DateTime(2026, 9, 15),
      );
      await budgets.closeActiveBudgets(deps.foodId);

      final september = await budgets.getBudgetsForMonth(
        const ReportPeriod(year: 2026, month: 9),
      );
      expect(september.length, 1);
      expect(september.single.budgetAmount, 2500000);

      final august = await budgets.getBudgetsForMonth(
        const ReportPeriod(year: 2026, month: 8),
      );
      expect(august.length, 1);
    });
  });

  group('BudgetSpending', () {
    Budget budget({int spent = 0, int amount = 2000000}) => Budget(
          id: 1,
          accountId: 10,
          accountName: 'Makanan',
          budgetAmount: amount,
          periodStart: 0,
          periodEnd: 0,
          actualSpend: spent,
        );

    test('usage 90%, belum over', () {
      final item = BudgetSpending(
        budget: budget(spent: 1800000),
        previousSpent: 1500000,
      );
      expect(item.usagePercent, 90);
      expect(item.isOver, isFalse);
      expect(item.momLabel, contains('naik 20%'));
    });

    test('over budget -> flag + persen > 100', () {
      final item = BudgetSpending(budget: budget(spent: 2200000));
      expect(item.isOver, isTrue);
      expect(item.usagePercent, closeTo(110, 0.001));
    });

    test('tanpa bulan lalu -> netral, bukan persen menyesatkan', () {
      final item = BudgetSpending(budget: budget(spent: 500000));
      expect(item.momChangePercent, isNull);
      expect(item.momLabel, 'baru dianggarkan bulan ini');
    });

    test('nol vs nol -> sama, tanpa pesan baru', () {
      final item = BudgetSpending(budget: budget(spent: 0));
      expect(item.momLabel, 'sama seperti bulan lalu');
    });
  });

  group('ReportCubit budgetSpending', () {
    test('join anggaran + previousSpent agregasi laporan', () async {
      final deps = await createReportTestDeps();
      addTearDown(() => deps.dispose());
      final budgets = BudgetRepository(deps.db);
      final cubit = ReportCubit(ReportRepository(deps.db), budgets);
      addTearDown(() => cubit.close());

      await budgets.createBudget(
        accountId: deps.foodId,
        amount: 2000000,
        periode: DateTime(2026, 9, 15),
      );
      await insertTransaction(
        db: deps.db,
        date: DateTime(2026, 8, 10),
        assetId: deps.cashId,
        categoryId: deps.foodId,
        amount: 1000000,
        isExpense: true,
      );
      await insertTransaction(
        db: deps.db,
        date: DateTime(2026, 9, 10),
        assetId: deps.cashId,
        categoryId: deps.foodId,
        amount: 1800000,
        isExpense: true,
      );

      await cubit.loadMonth(const ReportPeriod(year: 2026, month: 9));

      expect(cubit.state.status, ReportStatus.loaded);
      expect(cubit.state.budgetSpending.length, 1);
      final item = cubit.state.budgetSpending.single;
      expect(item.spent, 1800000);
      expect(item.previousSpent, 1000000);
      expect(item.momLabel, contains('naik 80%'));
    });
  });
}
