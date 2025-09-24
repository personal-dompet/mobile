import 'package:dompet/core/widgets/add_card_item.dart';
import 'package:flutter/material.dart';

class AddPocketCardItem extends StatelessWidget {
  final VoidCallback onTap;

  const AddPocketCardItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AddCardItem(
      onTap: onTap,
      label: 'Add Pocket',
      icon: Icons.add,
    );
  }
}
