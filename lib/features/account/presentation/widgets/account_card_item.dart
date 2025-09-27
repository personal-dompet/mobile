import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:dompet/core/widgets/item_card.dart';
import 'package:flutter/material.dart';

class AccountCardItem extends StatelessWidget {
  final SimpleAccountModel account;
  final bool isSelected;
  final VoidCallback? onTap;

  const AccountCardItem({
    super.key, 
    required this.account,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ItemCard<SimpleAccountModel>(
      item: account,
      id: (item) => item.id,
      name: (item) => item.name,
      balance: (item) => item.formattedBalance,
      color: (item) => item.color,
      icon: (item) => item.type.icon,
      displayName: (item) => item.type.displayName,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
