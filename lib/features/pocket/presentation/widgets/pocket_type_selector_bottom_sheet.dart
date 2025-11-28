import 'package:dompet/core/widgets/entity_type_selector_bottom_sheet.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketTypeSelectorBottomSheet extends ConsumerWidget {
  const PocketTypeSelectorBottomSheet({super.key});

  static final List<PocketType> _pocketTypes = [
    PocketType.spending,
    PocketType.recurring,
    PocketType.saving,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EntityTypeSelectorBottomSheet<PocketType>(
      types: _pocketTypes,
      onSelect: (type) {
        Navigator.of(context).pop<PocketType>(type);
      },
    );
  }
}
