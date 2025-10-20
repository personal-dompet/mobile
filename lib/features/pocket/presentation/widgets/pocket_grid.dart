import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/widgets/add_pocket_card_item.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketGrid extends ConsumerWidget {
  final List<PocketModel> data;
  final int? selectedPocketId;
  final PocketModel? sourcePocket;
  final PocketModel? destinationPocket;
  final void Function(PocketModel) onTap;
  final ListType listType;

  const PocketGrid({
    super.key,
    this.data = const [],
    this.selectedPocketId,
    required this.onTap,
    this.destinationPocket,
    this.sourcePocket,
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
            onFormCreated: (pocket) => onTap(pocket),
          );
        }
        // Otherwise, show the regular pocket card
        final pocket = data[index];
        TransferStaticSubject? transferRole;

        if (pocket.id == sourcePocket?.id) {
          transferRole = TransferStaticSubject.source;
        }
        if (pocket.id == destinationPocket?.id) {
          transferRole = TransferStaticSubject.destination;
        }

        return PocketCardItem(
          pocket: pocket,
          transferRole: transferRole,
          onTap: () => onTap(pocket),
        );
      },
    );
  }
}
