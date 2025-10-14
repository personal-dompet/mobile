import 'package:dompet/core/widgets/type_selector_item.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
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
    final filter = ref.watch(pocketFilterProvider);
    final filterNotifier = ref.read(pocketFilterProvider.notifier);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _pocketTypes.length,
        itemBuilder: (context, index) {
          final type = _pocketTypes[index];
          return TypeSelectorItem(
            displayName: type.displayName,
            color: type.color,
            isSelected: type == filter.type,
            onPressed: () {
              filterNotifier.setSelectedType(type);
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 4),
      ),
    );
  }
}
