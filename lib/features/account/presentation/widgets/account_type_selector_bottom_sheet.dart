import 'package:dompet/core/widgets/entity_type_selector_bottom_sheet.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountTypeSelectorBottomSheet extends ConsumerWidget {
  const AccountTypeSelectorBottomSheet({super.key});

  static final List<AccountType> _accountTypes = [
    AccountType.cash,
    AccountType.bank,
    AccountType.eWallet,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EntityTypeSelectorBottomSheet<AccountType>(
      types: _accountTypes,
      onSelect: (type) {
        Navigator.of(context).pop<AccountType>(type);
      },
    );
  }
}
