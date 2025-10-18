import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ItemListEmptyWidget<T> extends ConsumerWidget {
  final String title;
  final String message;
  final IconData icon;
  final FormGroup form;
  final String? Function()? keywordValue;
  final T? Function()? typeValue;
  final T? allTypeValue;
  final String Function(T) displayName;
  final void Function(T)? onTypeChanged;
  final String itemType;
  final VoidCallback? onAddPressed;

  const ItemListEmptyWidget({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.form,
    required this.keywordValue,
    required this.typeValue,
    required this.allTypeValue,
    required this.displayName,
    required this.itemType,
    this.onTypeChanged,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = AppTheme.textColorPrimary;

    // Get the current filter values
    final keyword = keywordValue?.call();
    final type = typeValue?.call();

    // Determine appropriate title and message based on filters
    String displayTitle = title;
    String displayMessage = message;

    if ((keyword != null && keyword.isNotEmpty == true) ||
        (type != null && type != allTypeValue)) {
      // Filters are applied
      displayTitle = 'No matching $itemType';
      if (keyword != null &&
          keyword.isNotEmpty == true &&
          type != null &&
          type != allTypeValue) {
        displayMessage =
            'We couldn\'t find any ${displayName(type).toLowerCase()} $itemType matching "$keyword". Try a different search term or filter. Or would you like to create a new one?';
      } else if (keyword != null && keyword.isNotEmpty == true) {
        displayMessage =
            'We couldn\'t find any $itemType matching "$keyword". Try a different search term. Or would you like to create a new $itemType?';
      } else if (type != null && type != allTypeValue) {
        displayMessage =
            'You don\'t have any ${displayName(type).toLowerCase()} $itemType yet. Would you like to create one?';
      } else {
        displayMessage =
            'We couldn\'t find any $itemType matching your filters. Try adjusting your filters. Or would you like to create a new $itemType?';
      }
    } else {
      // No filters applied
      displayTitle = 'No $itemType yet';
      displayMessage = message;
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.textColorPrimary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            displayTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textColorPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (onAddPressed != null) {
                onAddPressed!();
              }
            },
            icon: const Icon(Icons.add_rounded),
            label: Text('Create $itemType'),
          ),
        ],
      ),
    );
  }
}
