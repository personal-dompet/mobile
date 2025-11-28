import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class EntityTypeSelectorItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onPressed;
  final String displayName;
  final Color color;

  const EntityTypeSelectorItem({
    super.key,
    this.isSelected = false,
    this.onPressed,
    required this.displayName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppTheme.primaryColor;
    final inactiveColor = Colors.transparent;
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor:
            isSelected ? activeColor.withValues(alpha: 0.3) : inactiveColor,
        side: BorderSide(
            color: isSelected
                ? activeColor
                : AppTheme.textColorPrimary.withValues(alpha: .5)),
      ),
      onPressed: onPressed,
      child: Text(
        displayName,
        style: TextStyle(
            color: isSelected ? activeColor : AppTheme.textColorPrimary),
      ),
    );
  }
}
