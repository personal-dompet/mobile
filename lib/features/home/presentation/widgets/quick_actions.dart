import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/features/account/presentation/provider/account_flow_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_flow_provider.dart';
import 'package:dompet/features/transaction/domain/enums/transaction_type.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transaction/presentation/providers/transaction_flow_provider.dart';
import 'package:dompet/features/transfer/presentation/providers/transfer_flow_provider.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';

class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<_QuickActionItem> actions = [
      _QuickActionItem(
        icon: Icons.add_circle_outline_rounded,
        label: 'Add Money',
        color: AppTheme.successColor,
        onTap: () async {
          ref.read(transactionFormProvider).type.value = TransactionType.income;
          await ref.read(transactionFlowProvider).beginTransaction(context);
        },
      ),
      _QuickActionItem(
        icon: Icons.remove_circle_outline_rounded,
        label: 'Spend Money',
        color: AppTheme.errorColor,
        onTap: () async {
          ref.read(transactionFormProvider).type.value =
              TransactionType.expense;
          await ref.read(transactionFlowProvider).beginTransaction(context);
        },
      ),
      _QuickActionItem(
        icon: Icons.swap_horiz_rounded,
        label: 'Pocket Transfer',
        color: AppTheme.primaryColor,
        onTap: () async {
          await ref.read(transferFlowProvider).beginPocketTransfer(context);
        },
      ),
      _QuickActionItem(
        icon: Icons.swap_horiz_rounded,
        label: 'Account Transfer',
        color: AppTheme.primaryColor,
        onTap: () async {
          await ref.read(transferFlowProvider).beginAccountTransfer(context);
        },
      ),
      _QuickActionItem(
        icon: Icons.wallet_rounded,
        label: 'Add Pocket',
        color: AppTheme.infoColor,
        onTap: () async {
          await ref
              .read(pocketFlowProvider(ListType.option))
              .beginCreate(context);
        },
      ),
      _QuickActionItem(
        icon: Icons.account_balance_wallet_rounded,
        label: 'Add Account',
        color: AppTheme.infoColor,
        onTap: () async {
          await ref
              .read(accountFlowProvider(ListType.option))
              .beginCreate(context);
        },
      ),
      _QuickActionItem(
        icon: Icons.auto_graph_rounded,
        label: 'Auto Budgeting',
        color: AppTheme.warningColor,
        // onTap: () {
        //   context.showErrorSnackbar('Work In Progress');
        //   // TODO: Implement auto budgeting action
        // },
      ),
      _QuickActionItem(
        icon: Icons.bar_chart_rounded,
        label: 'Analytics',
        color: AppTheme.warningColor,
        // onTap: () {
        //   context.showErrorSnackbar('Work In Progress');
        //   // TODO: Implement analytics action
        // },
      ),
      _QuickActionItem(
        icon: Icons.account_balance_rounded,
        label: 'Bill Payment',
        color: AppTheme.errorColor,
        // onTap: () {
        //   context.showErrorSnackbar('Work In Progress');
        //   // TODO: Implement bill payment action
        //   // This should navigate to a page where user can view upcoming bills,
        //   // make payments, set up auto-payments, or mark bills as paid
        // },
      ),
      _QuickActionItem(
        icon: Icons.flag_rounded,
        label: 'Goal Tracker',
        color: AppTheme.successColor,
        // onTap: () {
        //   context.showErrorSnackbar('Work In Progress');
        //   // TODO: Implement goal tracker action
        //   // This should navigate to a page where user can set, view, and track
        //   // their financial goals (e.g., saving for vacation, emergency fund, etc.)
        // },
      ),
      _QuickActionItem(
        icon: Icons.insert_chart_rounded,
        label: 'Budget',
        color: AppTheme.warningColor,
        // onTap: () {
        //   context.showErrorSnackbar('Work In Progress');
        //   // TODO: Implement view budget action
        //   // This should navigate to a page showing budget overview,
        //   // spending vs budgeted amounts, and ability to create/edit budgets
        // },
      ),
      _QuickActionItem(
        icon: Icons.health_and_safety_rounded,
        label: 'Health Check',
        color: AppTheme.successColor,
        // onTap: () {
        //   context.showErrorSnackbar('Work In Progress');
        //   // TODO: Implement financial health check action
        //   // This should navigate to a page showing overall financial health metrics
        //   // like expense to income ratio, savings rate, debt to asset ratio, etc.
        // },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            physics:
                const NeverScrollableScrollPhysics(), // Disable scrolling within the grid
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              return actions[index];
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            context.showErrorSnackbar('Work In Progress');
          },
      child: Badge(
        label: onTap == null
            ? Icon(
                Icons.timelapse,
                size: 8,
              )
            : null,
        backgroundColor: onTap == null
            ? AppTheme.errorColor.withValues(alpha: 0.5)
            : Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: label.length >= 16
                      ? Marquee(
                          text: label,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textColorPrimary,
                                  ),
                          blankSpace: 8,
                          startPadding: 0,
                          pauseAfterRound: Duration(seconds: 1),
                        )
                      : Text(
                          label,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textColorPrimary,
                                  ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
