import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/core/widgets/item_card.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:flutter/material.dart';

class PocketCardItem extends StatelessWidget {
  final PocketModel pocket;
  final bool isSelected;
  final VoidCallback? onTap;
  final TransferStaticSubject? transferRole;

  const PocketCardItem({
    super.key,
    required this.pocket,
    this.transferRole,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ItemCard<PocketModel>(
      item: pocket,
      id: (item) => item.id,
      name: (item) => item.name,
      balance: (item) => item.formattedBalance,
      color: (item) => item.color,
      icon: (item) => item.icon?.icon ?? Icons.wallet_outlined,
      displayName: (item) => item.type.displayName,
      onTap: onTap,
      transferRole: transferRole,
    );
  }
}
