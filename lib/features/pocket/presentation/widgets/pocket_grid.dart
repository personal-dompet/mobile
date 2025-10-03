import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/widgets/add_pocket_card_item.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketGrid extends ConsumerWidget {
  final List<PocketModel> data;
  final int? selectedPocketId;
  final void Function(PocketModel) onTap;
  final ListType listType;

  const PocketGrid({
    super.key,
    this.data = const [],
    this.selectedPocketId,
    required this.onTap,
    this.listType = ListType.filtered,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: data.length + 1, // Add 1 for the "Add Pocket" card
      itemBuilder: (context, index) {
        // If this is the last item, show the "Add Pocket" card
        if (index == data.length) {
          return AddPocketCardItem(
            listType: listType,
          );
        }
        // Otherwise, show the regular pocket card
        final pocket = data[index];
        final isSelected = pocket.id == selectedPocketId;
        return PocketCardItem(
          pocket: pocket,
          isSelected: isSelected,
          onTap: () => onTap(pocket),
        );
      },
    );
  }
}
