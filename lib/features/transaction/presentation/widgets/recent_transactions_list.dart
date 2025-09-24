import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/transaction/domain/models/recent_transaction_model.dart';
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
  final RecentTransactionModel transaction;

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
            _getCategoryIcon(transaction.category),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          transaction.description ?? transaction.category,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          transaction.formattedDate,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        trailing: Text(
          transaction.formattedAmount,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: transaction.isIncome
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    try {
      // Try to find the matching enum value
      final categoryEnum = Category.values.firstWhere((e) {
        return e.displayName.toLowerCase() == category.toLowerCase();
      });
      return categoryEnum.icon;
    } catch (e) {
      // If not found, return a default icon
      return Icons.payment_outlined;
    }
  }
}
