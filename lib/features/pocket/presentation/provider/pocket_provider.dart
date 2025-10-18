import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_recurring_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_saving_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_spending_pocket_form.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector_bottom_sheet.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PocketCreationType {
  pocket,
  detail,
}

class _PocketService {
  final Ref _ref;
  final ListType _listType;

  _PocketService({required ListType listType, required Ref ref})
      : _listType = listType,
        _ref = ref;

  Future<void> execute(
    BuildContext context, {
    ValueChanged<CreatePocketForm>? onFormCreated,
  }) async {
    try {
      final type = await _selectPocketType(context);
      if (type == null) return;

      if (!context.mounted) return;

      final creationType = await _navigateToCreatePocket(context, type);
      if (creationType == null || !context.mounted) return;
      await _saveCreatedPocket(
        context,
        creationType,
        onFormCreated,
      );
    } finally {
      _ref.invalidateSelf();
      _ref.invalidate(createPocketFormProvider);
      _ref.invalidate(createSpendingPocketFormProvider);
      _ref.invalidate(createSavingPocketFormProvider);
      _ref.invalidate(createRecurringPocketFormProvider);
    }
  }

  Future<PocketType?> _selectPocketType(BuildContext context) async {
    if (_listType == ListType.all) {
      return await showModalBottomSheet<PocketType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const PocketTypeSelectorBottomSheet(),
      );
    }

    final filter = _ref.read(pocketFilterProvider);

    if (filter.type == PocketType.all) {
      return await showModalBottomSheet<PocketType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const PocketTypeSelectorBottomSheet(),
      );
    }

    return filter.type;
  }

  Future<PocketCreationType?> _navigateToCreatePocket(
    BuildContext context,
    PocketType type,
  ) async {
    final form = _ref.read(createPocketFormProvider);
    form.type.value = type;

    return await CreatePocketRoute().push<PocketCreationType>(context);
  }

  Future<void> _saveCreatedPocket(
    BuildContext context,
    PocketCreationType creationType, [
    ValueChanged<CreatePocketForm>? onFormCreated,
  ]) async {
    final pocketForm = _ref.read(createPocketFormProvider);
    onFormCreated?.call(pocketForm);
    if (creationType == PocketCreationType.pocket) {
      await _ref.read(pocketListProvider.notifier).create(pocketForm);
      return;
    }

    if (pocketForm.type.value == PocketType.spending) {
      final spendingForm = _ref.read(createSpendingPocketFormProvider);
      await _ref
          .read(pocketListProvider.notifier)
          .create(pocketForm, spendingForm: spendingForm);
      return;
    }

    if (pocketForm.type.value == PocketType.saving) {
      final savingForm = _ref.read(createSavingPocketFormProvider);
      await _ref
          .read(pocketListProvider.notifier)
          .create(pocketForm, savingForm: savingForm);
      return;
    }

    if (pocketForm.type.value == PocketType.recurring) {
      final recurringForm = _ref.read(createRecurringPocketFormProvider);
      await _ref
          .read(pocketListProvider.notifier)
          .create(pocketForm, recurringForm: recurringForm);
      return;
    }
  }
}

final pocketProvider =
    Provider.family<_PocketService, ListType>((Ref ref, ListType listType) {
  return _PocketService(listType: listType, ref: ref);
});
