import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class CardInput extends StatelessWidget {
  final String? label;
  final String? info;
  final Widget child;

  const CardInput({
    super.key,
    this.label,
    this.info,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            if (label != null)
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (info != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.infoColor,
                  ),
                  color: AppTheme.infoColor.withValues(alpha: 0.3),
                ),
                child: Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.infoColor,
                    ),
                    Expanded(
                      child: Text(
                        info!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            if (info != null) const SizedBox.shrink(),
            child,
          ],
        ),
      ),
    );
  }
}
