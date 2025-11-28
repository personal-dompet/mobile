import 'package:dompet/core/models/entity_base_type.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class EntityTypeSelectorBottomSheet<T extends EntityBaseType>
    extends StatelessWidget {
  final List<T> types;
  final ValueChanged<T> onSelect;

  const EntityTypeSelectorBottomSheet({
    super.key,
    required this.types,
    required this.onSelect,
  });

  bool get _isPocket => types.first is PocketType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.textColorPrimary.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Select ${_isPocket ? 'Pocket' : 'Account'} Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: types.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final type = types[index];
              final typeColor = type.color;

              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: typeColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
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
                      type.icon,
                      color: typeColor,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    type.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textColorPrimary,
                        ),
                  ),
                  subtitle: Text(
                    type.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.textColorPrimary.withValues(alpha: 0.7),
                        ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: typeColor,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.of(context).pop<T>(type);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
