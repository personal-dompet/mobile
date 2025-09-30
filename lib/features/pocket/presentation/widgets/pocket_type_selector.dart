import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_provider.dart';
import 'package:dompet/core/widgets/item_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketTypeSelector extends ConsumerWidget {
  const PocketTypeSelector({super.key});

  static final List<PocketType> _pocketTypes = [
    PocketType.all,
    PocketType.spending,
    PocketType.recurring,
    PocketType.saving,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(pocketFilterFormProvider);
    return ItemTypeSelector<PocketType>(
      formGroup: form,
      types: _pocketTypes,
      displayName: (type) => type.displayName,
      color: (type) => type.color,
      icon: (type) => type.icon,
      onTypeChanged: (type) {
        ref.invalidate(pocketProvider);
      },
    );
  }
}
