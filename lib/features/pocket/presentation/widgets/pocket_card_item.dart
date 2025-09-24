import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:dompet/core/widgets/item_card.dart';
import 'package:flutter/material.dart';

class PocketCardItem extends StatelessWidget {
  final SimplePocketModel pocket;

  const PocketCardItem({super.key, required this.pocket});

  @override
  Widget build(BuildContext context) {
    return ItemCard<SimplePocketModel>(
      item: pocket,
      id: (item) => item.id,
      name: (item) => item.name,
      balance: (item) => item.balance,
      color: (item) => item.color,
      icon: (item) => item.icon?.icon ?? Icons.wallet_outlined,
      displayName: (item) => item.type.displayName,
    );
  }
}
