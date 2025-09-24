import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectAccountTypePage extends ConsumerWidget {
  const SelectAccountTypePage({super.key});

  static final List<AccountType> _accountTypes = [
    AccountType.cash,
    AccountType.bank,
    AccountType.eWallet,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Account Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: _accountTypes.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final accountType = _accountTypes[index];
            final typeColor = accountType.color;

            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    accountType.icon,
                    color: typeColor,
                    size: 28,
                  ),
                ),
                title: Text(
                  accountType.displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
                subtitle: Text(
                  accountType.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 16,
                ),
                onTap: () {
                  Navigator.of(context).pop<AccountType>(accountType);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}