import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SelectPocketCard extends StatelessWidget {
  final String formControlName;
  final String? label;
  final String? placeholder;
  final bool isDisabled;

  const SelectPocketCard({
    super.key,
    required this.formControlName,
    this.label,
    this.placeholder,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<PocketModel, PocketModel>(
      formControlName: formControlName,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Text(
                label!,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
            ],
            GestureDetector(
              onTap: isDisabled
                  ? null
                  : () async {
                      final selectedPocket =
                          await SelectPocketRoute().push<PocketModel>(context);
                      if (selectedPocket != null && context.mounted) {
                        field.control.updateValue(selectedPocket);
                      }
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: field.control.invalid
                        ? Theme.of(context).colorScheme.error
                        : (field.value != null
                            ? field.value!.color?.withValues(alpha: 0.3) ??
                                Theme.of(context).dividerColor
                            : Theme.of(context).dividerColor),
                    width: field.control.invalid ? 2 : 1.5,
                  ),
                  boxShadow: [
                    if (!field.control.invalid)
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: field.value?.color?.withValues(alpha: 0.15) ??
                            Colors.grey[300]?.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: field.value?.color?.withValues(alpha: 0.3) ??
                              Theme.of(context).dividerColor,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          field.value?.icon?.icon ?? Icons.wallet_outlined,
                          color: field.value?.color ?? Colors.grey,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      field.value?.name ?? (placeholder ?? 'Select a pocket'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: field.value != null
                            ? Theme.of(context).colorScheme.onSurface
                            : (field.control.invalid
                                ? Theme.of(context).colorScheme.error
                                : Colors.grey[600]),
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (field.value != null) ...[
                      Text(
                        field.value!.type.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: field.value!.color?.withValues(alpha: 0.8) ??
                              Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: field.value!.color?.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: field.value!.color?.withValues(alpha: 0.3) ??
                                Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          field.value!.formattedBalance,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: field.value!.color,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (field.control.invalid) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  field.control.errors.values.first.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
