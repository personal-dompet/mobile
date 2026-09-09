import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:flutter/material.dart';

class DompetDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String confirmationText;
  final String? cancellationText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const DompetDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    this.subtitle,
    this.confirmationText = 'Konfirmasi',
    this.cancellationText,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Dialog(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: themeData.textTheme.titleMedium),
              if (subtitle != null) ...[
                SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: themeData.colorScheme.onSurface.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (cancellationText != null && onCancel != null)
                    TextButton(
                      key: TestKeys.dialogCancel,
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).dividerColor,
                      ),
                      onPressed: onCancel,
                      child: Text(cancellationText!),
                    ),
                  const SizedBox(width: 8),
                  FilledButton(
                    key: TestKeys.dialogConfirm,
                    onPressed: onConfirm,
                    child: Text(confirmationText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
