import 'package:dompet/core/widgets/recent_list_container.dart';
import 'package:dompet/features/transaction/domain/models/transaction_detail_model.dart';
import 'package:dompet/features/transaction/presentation/providers/recent_transaction_providers.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentTransactionsList extends ConsumerWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentTransactionsAsync = ref.watch(recentTransactionProvider);

    return recentTransactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(
            child: Text('No recent transactions'),
          );
        }

        return RecentListContainer(
          title: 'Recent Transactions',
          length: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _RecentTransactionItem(transaction: transaction);
          },
          onSeeAllPressed: () {
            //
          },
        );
      },
      loading: () => const Center(
          child: CircularProgressIndicator(
        strokeWidth: 1,
      )),
      error: (error, stack) => Center(
        child: Text('Error loading transactions: $error'),
      ),
    );
  }
}

class _RecentTransactionItem extends StatelessWidget {
  final TransactionDetailModel transaction;

  const _RecentTransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppTheme.cardColor,
        child: Icon(
          transaction.category.icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        transaction.description == null || transaction.description!.isEmpty
            ? transaction.category.displayName
            : transaction.description!,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(
            transaction.account.name,
            style: TextStyle(fontSize: 12, color: transaction.account.color),
          ),
          Text(
            '|',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.withValues(alpha: 0.7),
            ),
          ),
          Text(
            transaction.pocket.name,
            style: TextStyle(
              fontSize: 12,
              color: transaction.pocket.color ?? AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            transaction.formattedAmount,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: transaction.isIncome
                  ? AppTheme.successColor
                  : AppTheme.errorColor,
            ),
          ),
          Text(
            transaction.relativeFormattedCreatedAt,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
