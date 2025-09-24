import 'package:dompet/core/constants/pocket_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ColorPickerController {
  final FormControl<PocketColor> colorControl;

  ColorPickerController(this.colorControl);

  PocketColor? get value => colorControl.value;
  set value(PocketColor? color) {
    colorControl.value = color;
  }
}

class GenericColorPicker extends ConsumerWidget {
  final ColorPickerController controller;

  const GenericColorPicker({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = controller.value;

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
            controller.value = color;
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