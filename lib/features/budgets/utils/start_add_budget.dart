import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/budgets/cubits/budget_action_cubit.dart';
import 'package:dompet_app/features/categories/cubits/category_cubit.dart';
import 'package:dompet_app/features/categories/utils/open_expense_account_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

Future<void> startAddBudget(BuildContext context) async {
  final categoryIdControl = FormControl<int>();
  final categoryNameControl = FormControl<String>();

  await openCategorySelector(
    context,
    type: .expense,
    idControl: categoryIdControl,
    nameControl: categoryNameControl,
  );

  if (!context.mounted ||
      categoryIdControl.value == null ||
      categoryNameControl.value == null) {
    return;
  }

  final plan = await getIt<BudgetActionCubit>().startAddBudget(
    categoryIdControl.value!,
  );
  final category = await getIt<CategoryCubit>().getCategoryById(
    categoryIdControl.value!,
  );
  if (!context.mounted || category == null) return;

  debugPrint('Category: $category, Plan: $plan');

  if (plan == null) {
    await context.router.push(BudgetPlanFormRoute(category: category));
  } else {
    await context.router.push(BudgetPlanRoute(category: category, plan: plan));
  }
}
