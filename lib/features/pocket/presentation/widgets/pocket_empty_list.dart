import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/item_list_empty_widget.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/presentation/provider/all_pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/filtered_pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector_bottom_sheet.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketEmptyList extends ConsumerWidget {
  final ListType listType;

  const PocketEmptyList({
    super.key,
    this.listType = ListType.filtered,
  });

  Future<void> _handlePocketCreation(BuildContext context) async {
    // Determine pocket type
    final type = await _determinePocketType(context);
    if (type == null) return;

    // Check if context is still valid
    if (!context.mounted) return;

    // Navigate to create pocket screen
    final resultData = await _navigateToCreatePocket(context, type);
    if (resultData == null || !context.mounted) return;

    // Save the created pocket
    _saveCreatedPocket(context, resultData);
  }

  Future<PocketType?> _determinePocketType(BuildContext context) async {
    // If viewing all pockets, use all type
    if (listType == ListType.all) {
      return PocketType.all;
    }

    // Get current filter
    final filter =
        ProviderScope.containerOf(context).read(pocketFilterFormProvider);

    // If filter is set to 'all', ask user to select specific type
    if (filter.typeValue == PocketType.all) {
      return await showModalBottomSheet<PocketType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const PocketTypeSelectorBottomSheet(),
      );
    }

    // Use the filtered type
    return filter.typeValue;
  }

  Future<PocketCreateForm?> _navigateToCreatePocket(
      BuildContext context, PocketType type) async {
    final form =
        ProviderScope.containerOf(context).read(pocketCreateFormProvider);
    form.type.value = type;

    return await CreatePocketRoute().push<PocketCreateForm>(context);
  }

  void _saveCreatedPocket(BuildContext context, PocketCreateForm resultData) {
    if (listType == ListType.filtered) {
      ProviderScope.containerOf(context)
          .read(filteredPocketProvider.notifier)
          .create(resultData);
    } else {
      ProviderScope.containerOf(context)
          .read(allPocketProvider.notifier)
          .create(resultData);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(pocketFilterFormProvider);

    return ItemListEmptyWidget<PocketType>(
      title: 'No pockets yet',
      message: 'Start organizing your finances by creating your first pocket',
      icon: Icons.wallet_outlined,
      form: form,
      keywordValue: () => form.keywordValue,
      typeValue: () => form.typeValue,
      allTypeValue: PocketType.all,
      displayName: (type) => type.displayName,
      itemType: 'pockets',
      onTypeChanged: (type) {
        // Update type if needed
      },
      onAddPressed: () async {
        await _handlePocketCreation(context);
      },
    );
  }
}
