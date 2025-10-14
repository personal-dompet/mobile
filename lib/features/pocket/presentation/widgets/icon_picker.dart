import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconPicker extends ConsumerWidget {
  final CreatePocketForm form;

  const IconPicker({super.key, required this.form});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIcon = form.icon.value;
    final uniqueCategories = Category.getUniqueCategoriesByIcon();

    return SizedBox(
      height: 200, // Fixed height for the scrollable area
      child: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.only(bottom: 30),
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

              final color = form.color.value;

              return GestureDetector(
                onTap: () {
                  form.icon.value = category;
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: AlignmentGeometry.bottomCenter,
                  begin: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.surface.withValues(alpha: 0),
                    Theme.of(context).colorScheme.surface
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
