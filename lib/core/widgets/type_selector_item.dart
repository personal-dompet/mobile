import 'package:flutter/material.dart';

class TypeSelectorItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onPressed;
  final String displayName;
  final Color color;

  const TypeSelectorItem({
    super.key,
    this.isSelected = false,
    this.onPressed,
    required this.displayName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Colors.transparent;
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor:
            isSelected ? activeColor.withValues(alpha: 0.3) : inactiveColor,
        side: BorderSide(
            color: isSelected
                ? activeColor
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: .5)),
      ),
      onPressed: onPressed,
      child: Text(
        displayName,
        style: TextStyle(
            color: isSelected
                ? activeColor
                : Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
