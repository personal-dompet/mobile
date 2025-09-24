import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorPicker extends ConsumerWidget {
  final PocketCreateForm form;

  const ColorPicker({super.key, required this.form});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = form.colorControl.value;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: PocketColor.colors.length,
      itemBuilder: (context, index) {
        final color = PocketColor.colors[index];
        final isSelected = selectedColor?.toHex() == color.toHex();

        return GestureDetector(
          onTap: () {
            form.colorControl.value = color;
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: Colors.black,
                      width: 3,
                    )
                  : null,
            ),
            child: isSelected
                ? const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 16,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
