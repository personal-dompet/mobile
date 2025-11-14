import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/core/widgets/item_card.dart';
import 'package:flutter/material.dart';

class AccountCardItem extends StatelessWidget {
  final AccountModel account;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const AccountCardItem({
    super.key,
    required this.account,
    this.isSelected = false,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ItemCard<AccountModel>(
      item: account,
      id: (item) => item.id,
      name: (item) => item.name,
      balance: (item) => item.formattedBalance,
      color: (item) => item.color,
      icon: (item) => item.type.icon,
      displayName: (item) => item.type.displayName,
      isSelected: isSelected,
      isDisabled: isDisabled,
      onTap: onTap,
    );
  }
}
