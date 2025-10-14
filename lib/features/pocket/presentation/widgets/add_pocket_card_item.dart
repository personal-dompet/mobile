import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/add_card_item.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/presentation/provider/create_pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector_bottom_sheet.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPocketCardItem extends ConsumerWidget {
  final ListType listType;
  const AddPocketCardItem({super.key, required this.listType});

  // Future<void> _handlePocketCreation(BuildContext context) async {
  //   // Determine pocket type
  //   final type = await _determinePocketType(context);
  //   if (type == null) return;

  //   // Check if context is still valid
  //   if (!context.mounted) return;

  //   // Navigate to create pocket screen
  //   final resultData = await _navigateToCreatePocket(context, type);
  //   if (resultData == null || !context.mounted) return;

  //   // Save the created pocket
  //   _saveCreatedPocket(context, resultData);
  // }

  // Future<PocketType?> _determinePocketType(BuildContext context) async {
  //   // If viewing all pockets, use all type
  //   if (listType == ListType.all) {
  //     return await showModalBottomSheet<PocketType>(
  //       context: context,
  //       isScrollControlled: true,
  //       useRootNavigator: true,
  //       builder: (context) => const PocketTypeSelectorBottomSheet(),
  //     );
  //   }

  //   // Get current filter
  //   final filter =
  //       ProviderScope.containerOf(context).read(pocketFilterProvider);

  //   // If filter is set to 'all', ask user to select specific type
  //   if (filter.type == PocketType.all) {
  //     return await showModalBottomSheet<PocketType>(
  //       context: context,
  //       isScrollControlled: true,
  //       useRootNavigator: true,
  //       builder: (context) => const PocketTypeSelectorBottomSheet(),
  //     );
  //   }

  //   // Use the filtered type
  //   return filter.type;
  // }

  // Future<CreatePocketForm?> _navigateToCreatePocket(
  //     BuildContext context, PocketType type) async {
  //   final form =
  //       ProviderScope.containerOf(context).read(createPocketFormProvider);
  //   form.type.value = type;

  //   return await CreatePocketRoute().push<CreatePocketForm>(context);
  // }

  // void _saveCreatedPocket(BuildContext context, CreatePocketForm resultData) {
  //   ProviderScope.containerOf(context)
  //       .read(pocketListProvider.notifier)
  //       .create(resultData);
  // }

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
