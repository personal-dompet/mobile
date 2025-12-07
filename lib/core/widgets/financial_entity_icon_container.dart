import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class FinancialEntityIconContainer extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final IconData icon;
  final double size;
  final double iconSize;

  const FinancialEntityIconContainer({
    super.key,
    required this.color,
    this.isSelected = false,
    required this.icon,
    this.size = 56,
    this.iconSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: iconSize,
        ),
      ),
    );
  }
}
