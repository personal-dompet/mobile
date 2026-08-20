import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:flutter/widgets.dart';

Future<void> startAddBudget(BuildContext context) async {
  final category = await context.router.push<Account>(
    CategorySelectorRoute(type: .expense, showBudgetStatus: true),
  );
  if (category == null || !context.mounted) return;

  final plan = await getIt<BudgetPlanRepository>().getByAccountId(category.id);
  if (!context.mounted) return;

  if (plan != null) {
    await context.router.push(BudgetPlanRoute(category: category, plan: plan));
  } else {
    await context.router.push(BudgetFormRoute(category: category));
  }
}