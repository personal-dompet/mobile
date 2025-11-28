import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/add_entity_card.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_flow_provider.dart';
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
    return AddEntityCard(
      onTap: () async {
        await ref.read(pocketFlowProvider(listType)).beginCreate(
          context,
          onFormCreated: (pocketForm) {
            onFormCreated?.call(pocketForm.toPocketModel());
          },
        );
      },
      label: 'Add Pocket',
    );
  }
}
