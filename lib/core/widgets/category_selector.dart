import 'package:dompet/core/enum/category.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final Category? selectedCategory;
  final ValueChanged<Category> onSelected;

  const CategorySelector(
      {super.key, this.selectedCategory, required this.onSelected});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String _searchQuery = '';
  final Map<String, bool> _expandedGroups = {};

  @override
  Widget build(BuildContext context) {
    // final groupedCategories = Category.getGroupedCategories();

    // Initialize expanded state for all groups as expanded by default
    // for (final group in groupedCategories) {
    //   _expandedGroups.putIfAbsent(group.title, () => true);
    // }

    // List<CategoryGroup> filteredGroups = groupedCategories;

    // if (_searchQuery.isNotEmpty) {
    //   filteredGroups = groupedCategories
    //       .map((group) {
    //         final filteredCategories = group.categories
    //             .where((category) => category.displayName
    //                 .toLowerCase()
    //                 .contains(_searchQuery.toLowerCase()))
    //             .toList();
    //         return CategoryGroup(
    //           title: group.title,
    //           categories: filteredCategories,
    //         );
    //       })
    //       .where((group) => group.categories.isNotEmpty)
    //       .toList();
    // }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field at the top
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search category',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.textColorTertiary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.textColorTertiary,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        // Categories list - now fully scrollable
        Expanded(
          child: ListView.builder(
            itemCount: 0,
            // itemCount: filteredGroups.length,
            itemBuilder: (context, groupIndex) {
              return SizedBox.shrink();
              // final group = filteredGroups[groupIndex];
              // final isExpanded = _expandedGroups[group.title] ?? false;

              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     // Group header with expand/collapse
              //     Container(
              //       decoration: BoxDecoration(
              //         color: Colors.transparent, // Blend with background
              //         border: Border(
              //           bottom: BorderSide(
              //             color: AppTheme.disabledColor,
              //             width: 0.5,
              //           ),
              //         ),
              //       ),
              //       child: ListTile(
              //         contentPadding: const EdgeInsets.symmetric(
              //             horizontal: 16.0, vertical: 8.0),
              //         title: Text(
              //           group.title,
              //           style: const TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: AppTheme.textColorPrimary,
              //             fontSize: 16,
              //           ),
              //         ),
              //         trailing: Icon(
              //           isExpanded ? Icons.expand_less : Icons.expand_more,
              //           color: AppTheme.textColorSecondary,
              //         ),
              //         onTap: () {
              //           setState(() {
              //             _expandedGroups[group.title] = !isExpanded;
              //           });
              //         },
              //       ),
              //     ),
              //     // Category items in the group if expanded
              //     if (isExpanded)
              //       ...group.categories.map((category) {
              //         final isSelected = widget.selectedCategory == category;
              //         return ListTile(
              //           leading: Icon(
              //             category.icon,
              //             color: isSelected
              //                 ? AppTheme.primaryColor
              //                 : AppTheme.textColorSecondary,
              //           ),
              //           title: Text(
              //             category.displayName,
              //             style: TextStyle(
              //               color: isSelected
              //                   ? AppTheme.primaryColor
              //                   : AppTheme.textColorPrimary,
              //             ),
              //           ),
              //           selected: isSelected,
              //           selectedTileColor:
              //               AppTheme.primaryColor.withValues(alpha: 0.1),
              //           onTap: () {
              //             widget.onSelected(category);
              //           },
              //         );
              //       }),
              //   ],
              // );
            },
          ),
        ),
      ],
    );
  }
}
