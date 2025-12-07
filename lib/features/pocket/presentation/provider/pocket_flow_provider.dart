import 'package:auto_route/auto_route.dart';
import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/core/enum/creation_type.dart';
import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/core/widgets/entity_type_selector_bottom_sheet.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_logic_provider.dart';
import 'package:dompet/features/transaction/domain/forms/transaction_form.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PocketFlowService {
  final Ref ref;
  final ListType listType;

  _PocketFlowService({required this.listType, required this.ref});

  Future<void> beginCreate(
    BuildContext context, {
    ValueChanged<CreatePocketForm>? onFormCreated,
    CreateFrom? createFrom,
  }) async {
    try {
      final type = await _selectPocketType(context);
      if (type == null || !context.mounted) return;

      final creationType = await _navigateToCreatePocket(context, type);
      if (creationType == null || !context.mounted) return;
      await _saveCreatedPocket(
        context,
        creationType,
        onFormCreated,
        createFrom,
      );
    } finally {
      ref.invalidateSelf();
    }
  }

  Future<PocketType?> _selectPocketType(BuildContext context) async {
    final filter = ref.read(pocketFilterProvider);

    if (listType == ListType.option || filter.type == PocketType.all) {
      return await showModalBottomSheet<PocketType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => EntityTypeSelectorBottomSheet<PocketType>(
          onSelect: (type) {
            Navigator.of(context).pop<PocketType>(type);
          },
          types: [
            PocketType.spending,
            PocketType.recurring,
            PocketType.saving,
          ],
        ),
      );
    }

    return filter.type;
  }

  Future<CreationType?> _navigateToCreatePocket(
    BuildContext context,
    PocketType type,
  ) async {
    final form = ref.read(createPocketFormProvider);
    form.type.value = type;

    return await context.router.push<CreationType>(CreatePocketRoute());
  }

  Future<void> _saveCreatedPocket(
    BuildContext context,
    CreationType creationType, [
    ValueChanged<CreatePocketForm>? onFormCreated,
    CreateFrom? createFrom,
  ]) async {
    final pocketForm = ref.read(createPocketFormProvider);
    onFormCreated?.call(pocketForm);
    try {
      await ref.read(pocketLogicProvider).create(creationType);

      if (!context.mounted) return;

      context.showSuccessSnackbar(
        'Pocket "${pocketForm.nameValue}" created successfully.',
      );
    } catch (e) {
      if (!ref.mounted) return;
      final message =
          'Failed to create new pocket. Please select existing pocket or create new one.';
      if (createFrom == CreateFrom.transaction) {
        final transactionForm = ref.read(transactionFormProvider);
        transactionForm.pocket.reset();
        transactionForm.pocket.setErrors({'failed': message});
        transactionForm.pocket.markAsTouched();
        return;
      }
      if (createFrom == CreateFrom.transferSource) {
        final pocketTransferForm = ref.read(pocketTransferFormProvider);
        pocketTransferForm.fromPocket.reset();
        pocketTransferForm.fromPocket.setErrors({'failed': message});
        pocketTransferForm.fromPocket.markAsTouched();
        return;
      }
      if (createFrom == CreateFrom.transferDestination) {
        final pocketTransferForm = ref.read(pocketTransferFormProvider);
        pocketTransferForm.toPocket.reset();
        pocketTransferForm.toPocket.setErrors({'failed': message});
        pocketTransferForm.toPocket.markAsTouched();
        return;
      }
    }
  }
}

final pocketFlowProvider =
    Provider.family<_PocketFlowService, ListType>((Ref ref, ListType listType) {
  return _PocketFlowService(listType: listType, ref: ref);
});
