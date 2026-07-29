import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final bool center;
  final String title;
  final String text;
  final String? actionText;
  final VoidCallback? onAction;
  const EmptyMessage({
    super.key,
    this.center = false,
    required this.text,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: center ? .center : .start,
      children: [
        Text(
          title,
          style: themeData.textTheme.bodyLarge?.copyWith(
            color: themeData.dividerColor,
          ),
        ),
        Text(
          text,
          textAlign: center ? .center : .start,
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: themeData.dividerColor,
          ),
        ),
        SizedBox(height: 4),
        if (actionText != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Row(
              spacing: 4,
              mainAxisSize: .min,
              children: [
                Text(actionText!),
                if (!center) Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
      ],
    );
  }
}
