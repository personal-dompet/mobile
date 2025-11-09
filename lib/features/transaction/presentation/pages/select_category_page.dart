import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/widgets/category_selector.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class SelectCategoryPage extends StatelessWidget {
  final String? selectedCategoryIconKey;

  const SelectCategoryPage({
    super.key,
    this.selectedCategoryIconKey,
  });

  @override
  Widget build(BuildContext context) {
    final Category? selectedCategory = selectedCategoryIconKey != null
        ? Category.fromValue(selectedCategoryIconKey!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.textColorPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 0),
        child: CategorySelector(
          selectedCategory: selectedCategory,
          onSelected: (category) {
            // Return the selected category back to the calling screen
            Navigator.of(context).pop(category);
          },
        ),
      ),
    );
  }
}
