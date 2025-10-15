import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/add_card_item.dart';
import 'package:dompet/features/pocket/presentation/provider/create_pocket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPocketCardItem extends ConsumerWidget {
  final ListType listType;
  const AddPocketCardItem({super.key, required this.listType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AddCardItem(
      onTap: () async {
        await ref.read(createPocketProvider(listType)).execute(context);
      },
      label: 'Add Pocket',
      icon: Icons.add,
    );
  }
}
