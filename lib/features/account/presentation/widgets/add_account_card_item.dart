import 'package:dompet/core/widgets/add_card_item.dart';
import 'package:flutter/material.dart';

class AddAccountCardItem extends StatelessWidget {
  final VoidCallback onTap;

  const AddAccountCardItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AddCardItem(
      onTap: onTap,
      label: 'Add Account',
      icon: Icons.add,
    );
  }
}