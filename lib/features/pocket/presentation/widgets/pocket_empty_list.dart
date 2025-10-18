import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketEmptyList extends ConsumerWidget {
  final ListType listType;
  final ValueChanged<PocketModel>? onFormCreated;

  const PocketEmptyList({
    super.key,
    this.listType = ListType.filtered,
    this.onFormCreated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final filter = ref.watch(pocketFilterProvider);

    // Get the current filter values
    final keyword = filter.keyword;
    final type = filter.type;

    // Determine appropriate title and message based on filters
    String displayTitle = 'No pockets yet';
    String displayMessage =
        'Start organizing your finances by creating your first pocket';

    if ((keyword != null && keyword.isNotEmpty == true) ||
        (type != PocketType.all)) {
      // Filters are applied
      displayTitle = 'No matching pocket';
      if (keyword != null &&
          keyword.isNotEmpty == true &&
          type != PocketType.all) {
        displayMessage =
            'We couldn\'t find any ${type.displayName.toLowerCase()} pockets matching "$keyword". Try a different search term or filter. Or would you like to create a new one?';
      } else if (keyword != null && keyword.isNotEmpty == true) {
        displayMessage =
            'We couldn\'t find any pockets matching "$keyword". Try a different search term. Or would you like to create a new pockets?';
      } else if (type != PocketType.all) {
        displayMessage =
            'You don\'t have any ${type.displayName.toLowerCase()} pockets yet. Would you like to create one?';
      } else {
        displayMessage =
            'We couldn\'t find any pockets matching your filters. Try adjusting your filters. Or would you like to create a new pockets?';
      }
    } else {
      // No filters applied
      displayTitle = 'No pockets yet';
      displayMessage =
          'Start organizing your finances by creating your first pocket';
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            type.icon,
            size: 64,
            color: textColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            displayTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await ref.read(pocketProvider(listType)).execute(
                context,
                onFormCreated: (pocketForm) {
                  onFormCreated?.call(pocketForm.toPocketModel());
                },
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: Text('Create pockets'),
          ),
        ],
      ),
    );
  }
}


    // final form = ref.watch(pocketFilterFormProvider);

    // return ItemListEmptyWidget<PocketType>(
    //   title: 'No pockets yet',
    //   message: 'Start organizing your finances by creating your first pocket',
    //   icon: Icons.wallet_outlined,
    //   form: form,
    //   keywordValue: () => form.keywordValue,
    //   typeValue: () => form.typeValue,
    //   PocketType.all: PocketType.all,
    //   displayName: (type) => type.displayName,
    //   itemType: 'pockets',
    //   onTypeChanged: (type) {
    //     // Update type if needed
    //   },
    //   onAddPressed: () async {
    //     await _handlePocketCreation(context);
      // },
