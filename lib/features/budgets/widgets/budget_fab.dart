import 'package:dompet_app/features/budgets/utils/start_add_budget.dart';
import 'package:flutter/material.dart';

class BudgetFab extends StatelessWidget {
  const BudgetFab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return FloatingActionButton(
      onPressed: () => startAddBudget(context),
      backgroundColor: themeData.colorScheme.primary,
      foregroundColor: themeData.scaffoldBackgroundColor,
      elevation: 0,
      shape: const CircleBorder(),
      child: const Icon(Icons.add_rounded),
    );
  }
}