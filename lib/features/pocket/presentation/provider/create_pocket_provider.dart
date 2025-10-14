import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector_bottom_sheet.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePocketService {
  final Ref _ref;
  final ListType _listType;

  CreatePocketService({required ListType listType, required Ref ref})
      : _listType = listType,
        _ref = ref;

  Future<void> execute(BuildContext context) async {
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
    if (_listType == ListType.all) {
      return await showModalBottomSheet<PocketType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const PocketTypeSelectorBottomSheet(),
      );
    }

    // Get current filter
    final filter = _ref.read(pocketFilterProvider);

    // If filter is set to 'all', ask user to select specific type
    if (filter.type == PocketType.all) {
      return await showModalBottomSheet<PocketType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const PocketTypeSelectorBottomSheet(),
      );
    }

    // Use the filtered type
    return filter.type;
  }

  Future<CreatePocketForm?> _navigateToCreatePocket(
      BuildContext context, PocketType type) async {
    final form = _ref.read(createPocketFormProvider);
    form.type.value = type;

    return await CreatePocketRoute().push<CreatePocketForm>(context);
  }

  Future<void> _saveCreatedPocket(
      BuildContext context, CreatePocketForm resultData) async {
    await _ref.read(pocketListProvider.notifier).create(resultData);
    _ref.invalidateSelf();
  }
}

final createPocketProvider = Provider.family<CreatePocketService, ListType>(
    (Ref ref, ListType listType) {
  return CreatePocketService(listType: listType, ref: ref);
});
