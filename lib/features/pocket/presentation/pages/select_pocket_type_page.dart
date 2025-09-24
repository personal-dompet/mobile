import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectPocketTypePage extends ConsumerWidget {
  const SelectPocketTypePage({super.key});

  static final List<PocketType> _pocketTypes = [
    PocketType.spending,
    PocketType.saving,
    PocketType.recurring,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Pocket Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: _pocketTypes.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final pocketType = _pocketTypes[index];
            final typeColor = pocketType.color;

            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    pocketType.icon,
                    color: typeColor,
                    size: 28,
                  ),
                ),
                title: Text(
                  pocketType.displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
                subtitle: Text(
                  pocketType.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 16,
                ),
                onTap: () {
                  // Set the selected pocket type in the provider
                  // ref
                  //     .read(pocketTypeProvider.notifier)
                  //     .setPocketType(pocketType);

                  // Navigate to the create pocket page
                  // context.replace('/pockets/create');
                  Navigator.of(context).pop<PocketType>(pocketType);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
