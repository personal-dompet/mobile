import 'package:dompet/features/transaction/domain/models/transaction_detail_model.dart';
import 'package:dompet/features/transaction/presentation/providers/recent_transaction_providers.dart';
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

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (context, index) => Divider(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            height: 1,
            indent: 72,
            endIndent: 16,
          ),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _RecentTransactionItem(transaction: transaction);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            transaction.category.icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          transaction.description ?? transaction.category.displayName,
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
                color: transaction.pocket.color ??
                    Theme.of(context).colorScheme.primary,
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
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.error,
              ),
            ),
            Text(
              transaction.realtiveFormattedDate,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
