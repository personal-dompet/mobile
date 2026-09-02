import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/budgets/models/budget.dart';
import 'package:dompet_app/features/budgets/widgets/empty_budgets.dart';
import 'package:flutter/material.dart';

class BudgetList extends StatelessWidget {
  final List<Budget> budgets;
  const BudgetList({super.key, required this.budgets});

  @override
  Widget build(BuildContext context) {
    if (budgets.isEmpty) {
      return Center(child: EmptyBudgets(center: true));
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        return _BudgetCard(budget: budgets[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 16);
      },
      itemCount: budgets.length,
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final Budget budget;
  const _BudgetCard({required this.budget});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isOverBudget = budget.remaining < 0;
    final percent = (budget.useageRatio * 100).round();

    return Card(
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: () => BudgetDetailRoute(budgetId: budget.id).push(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 8,
            children: [
              Row(
                spacing: 4,
                children: [
                  Expanded(
                    child: Text(
                      budget.accountName,
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        fontWeight: .w600,
                      ),
                      overflow: .ellipsis,
                    ),
                  ),
                  Text(
                    budget.remaining.currency,
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      color: isOverBudget
                          ? themeData.colorScheme.error
                          : themeData.colorScheme.primary,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
              Text(
                budget.periode,
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              _UsageBar(ratio: budget.useageRatio, isOverBudget: isOverBudget),
              Row(
                spacing: 4,
                children: [
                  Expanded(
                    child: Text(
                      'Terpakai: ${budget.actualSpend.currency} ($percent%)',
                      style: themeData.textTheme.bodySmall,
                      overflow: .ellipsis,
                    ),
                  ),
                  Text(
                    budget.actualBudgetAmount.currency,
                    style: themeData.textTheme.bodySmall?.copyWith(
                      color: themeData.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsageBar extends StatelessWidget {
  final double ratio;
  final bool isOverBudget;
  const _UsageBar({required this.ratio, required this.isOverBudget});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final clamped = ratio.clamp(0.0, 1.0);
    final fillColor = isOverBudget ? colorScheme.error : colorScheme.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          Container(
            height: 6,
            color: colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          FractionallySizedBox(
            alignment: .centerLeft,
            widthFactor: clamped,
            child: Container(height: 6, color: fillColor),
          ),
        ],
      ),
    );
  }
}
