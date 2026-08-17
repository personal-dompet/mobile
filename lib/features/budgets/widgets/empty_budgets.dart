import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/empty_message.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:flutter/material.dart';

class EmptyBudgets extends StatelessWidget {
  final bool center;
  final String emptyText;
  final Account? selectedAccount;
  const EmptyBudgets({
    super.key,
    this.selectedAccount,
    this.center = false,
    this.emptyText = 'Mulai dengan membuat anggaran pertamamu.',
  });

  @override
  Widget build(BuildContext context) {
    return EmptyMessage(
      text: emptyText,
      title: 'Belum ada anggaran.',
      onAction: () async {
        final category = await context.router.push<Account>(
          CategorySelectorRoute(type: .expense),
        );
        if (category == null || !context.mounted) return;
        // TODO: redirect to form page
        context.router.push(BudgetPlanFormRoute(category: category));
      },
      actionText: 'Anggarkan Sekarang',
      center: center,
    );
  }
}
