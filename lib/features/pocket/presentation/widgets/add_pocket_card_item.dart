import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/add_card_item.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPocketCardItem extends ConsumerWidget {
  final ListType listType;
  final ValueChanged<PocketModel>? onFormCreated;
  const AddPocketCardItem({
    super.key,
    required this.listType,
    this.onFormCreated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AddCardItem(
      onTap: () async {
        await ref.read(pocketProvider(listType)).execute(
          context,
          onFormCreated: (pocketForm) {
            onFormCreated?.call(pocketForm.toPocketModel());
          },
        );
      },
      label: 'Add Pocket',
      icon: Icons.add,
    );
  }
}
