import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/provider/account_provider.dart';
import 'package:dompet/core/widgets/item_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountTypeSelector extends ConsumerWidget {
  const AccountTypeSelector({super.key});

  static final List<AccountType> _accountTypes = [
    AccountType.all,
    AccountType.cash,
    AccountType.bank,
    AccountType.eWallet,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(accountFilterFormProvider);
    return ItemTypeSelector<AccountType>(
      formGroup: form,
      types: _accountTypes,
      displayName: (type) => type.displayName,
      color: (type) => type.color,
      icon: (type) => type.icon,
      onTypeChanged: (type) {
        ref.invalidate(accountProvider);
      },
    );
  }
}
