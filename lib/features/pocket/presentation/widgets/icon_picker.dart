import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconPicker extends ConsumerStatefulWidget {
  final CreatePocketForm form;

  const IconPicker({super.key, required this.form});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IconPickerState();
}

class _IconPickerState extends ConsumerState<IconPicker> {
  final _controller = TextEditingController();
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _keyword = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIcon = widget.form.icon.value;
    final uniqueCategories = Category.getUniqueCategoriesByIcon();

    final filteredCategories = uniqueCategories.where((category) {
      if (_keyword.isEmpty) return true;
      final isDisplayNameMatch =
          category.displayName.toLowerCase().contains(_keyword.toLowerCase());
      final isNameMatch =
          category.name.toLowerCase().contains(_keyword.toLowerCase());
      final isIconKeymatch = category.iconKey
          .split('_')
          .join(' ')
          .contains(_keyword.toLowerCase());
      return isDisplayNameMatch || isNameMatch || isIconKeymatch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field with enhanced styling
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search icons...',
            prefixIcon: Icon(Icons.search),
            suffix: _keyword.isEmpty
                ? null
                : GestureDetector(
                    onTap: () {
                      _controller.clear();
                    },
                    child: Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          textInputAction: TextInputAction.search,
        ),
        const SizedBox(height: 16),

        // Category header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _keyword.isEmpty ? 'All Icons' : 'Search Results',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (filteredCategories.length > 12)
              Text(
                '${filteredCategories.length} icons',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Icons grid
        if (filteredCategories.isEmpty)
          Opacity(
            opacity: 0.6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_outlined,
                    size: 48,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No icons found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try using different keywords',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            // padding: const EdgeInsets.only(bottom: 30),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // Changed from 6 to 4 for better touch targets
              // crossAxisSpacing: 12,
              // mainAxisSpacing: 12,
              childAspectRatio:
                  1.0, // Square aspect ratio for better consistency
            ),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              final isSelected = selectedIcon?.iconKey == category.iconKey;

              return GestureDetector(
                onTap: () {
                  widget.form.icon.value = category;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected && widget.form.color.value != null
                        ? widget.form.color.value?.withValues(alpha: 0.25)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected && widget.form.color.value != null
                          ? widget.form.color.value!
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      category.icon,
                      color: isSelected && widget.form.color.value != null
                          ? widget.form.color.value
                          : Theme.of(context).iconTheme.color,
                      size: 24,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
