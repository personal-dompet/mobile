import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class AddEntityCard extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const AddEntityCard({
    super.key,
    required this.onTap,
    this.label = 'Add Item',
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = AppTheme.primaryColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: itemColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        color: AppTheme.surfaceColor,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(
                  color: itemColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: itemColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textColorPrimary,
                    fontSize: 20,
                    height: 1.2,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
