import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconPicker extends ConsumerWidget {
  final PocketCreateForm form;

  const IconPicker({super.key, required this.form});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIcon = form.iconControl.value;
    final uniqueCategories = Category.getUniqueCategoriesByIcon();

    return SizedBox(
      height: 200, // Fixed height for the scrollable area
      child: GridView.builder(
        physics: const BouncingScrollPhysics(), // Enable scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: uniqueCategories.length,
        itemBuilder: (context, index) {
          final category = uniqueCategories[index];
          final isSelected = selectedIcon?.iconKey == category.iconKey;

          final color = form.colorControl.value;

          return GestureDetector(
            onTap: () {
              form.iconControl.value = category;
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected && color != null
                    ? color.background
                    : Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  category.icon,
                  color: isSelected && color != null
                      ? color
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
