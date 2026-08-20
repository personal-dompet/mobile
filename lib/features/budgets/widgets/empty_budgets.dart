import 'package:dompet_app/core/widgets/empty_message.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/budgets/utils/start_add_budget.dart';
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
      onAction: () => startAddBudget(context),
      actionText: 'Anggarkan Sekarang',
      center: center,
    );
  }
}