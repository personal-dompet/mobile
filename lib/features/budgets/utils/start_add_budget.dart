import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/categories/utils/open_expense_account_selector.dart';
import 'package:flutter/widgets.dart';

Future<void> startAddBudget(BuildContext context, {int? selectedId}) async {
  final result = await openCategorySelector(
    context,
    type: .expense,
    selectedId: selectedId,
    withBudget: true,
  );

  if (!context.mounted || result == null) {
    return;
  }

  if (result.hasPlan) {
    await context.router.push(BudgetPlanRoute(category: result.account));
  } else {
    await context.router.push(BudgetPlanFormRoute(category: result.account));
  }
}
