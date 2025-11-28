import 'package:dompet/core/widgets/entity_type_selector_item.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/presentation/provider/account_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountTypeSelector extends ConsumerWidget {
  const AccountTypeSelector({super.key});

  static final List<AccountType> _pocketTypes = [
    AccountType.all,
    AccountType.bank,
    AccountType.cash,
    AccountType.eWallet,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(accountFilterProvider);
    final filterNotifier = ref.read(accountFilterProvider.notifier);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _pocketTypes.length,
        itemBuilder: (context, index) {
          final type = _pocketTypes[index];
          return EntityTypeSelectorItem(
            displayName: type.displayName,
            color: type.color,
            isSelected: type == filter.type,
            onPressed: () {
              filterNotifier.setSelectedType(type);
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 4),
      ),
    );
  }
}
