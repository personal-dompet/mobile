import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:dompet/features/pocket/domain/provider/pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/add_pocket_card_item.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PocketGrid extends ConsumerWidget {
  final List<SimplePocketModel> data;
  final int? selectedPocketId;
  final void Function(SimplePocketModel) onTap;
  const PocketGrid({
    super.key,
    this.data = const [],
    this.selectedPocketId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount:
          data.length + 1, // Add 1 for the "Add Pocket" card
      itemBuilder: (context, index) {
        // If this is the last item, show the "Add Pocket" card
        if (index == data.length) {
          return AddPocketCardItem(
            onTap: () async {
              final result = await context
                  .push<PocketType?>('/pockets/types');
              if (result != null && context.mounted) {
                final form =
                    ref.read(pocketCreateFormProvider);
                final typeControl = form.typeControl;
                typeControl.value = result;
                final resultData =
                    await context.push<PocketCreateForm>(
                        '/pockets/create');
                if (resultData == null) return;

                ref
                    .read(pocketProvider.notifier)
                    .create(resultData);
              }
            },
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
