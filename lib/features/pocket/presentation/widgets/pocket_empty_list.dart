import 'package:dompet/core/widgets/item_list_empty_widget.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/domain/provider/pocket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PocketEmptyList extends ConsumerWidget {
  const PocketEmptyList({super.key});

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
        final result = await context.push<PocketType?>('/pockets/types');
        if (result != null && context.mounted) {
          final formProvider = ref.read(pocketCreateFormProvider);
          final typeControl = formProvider.typeControl;
          typeControl.value = result;
          final resultData =
              await context.push<PocketCreateForm>('/pockets/create');
          if (resultData == null) return;

          ref.read(pocketProvider.notifier).create(resultData);
        }
      },
    );
  }
}
