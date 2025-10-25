import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A reactive date picker widget that displays dates in DD MMMM yyyy format
class DompetReactiveDatePicker extends StatelessWidget {
  final FormControl<DateTime?> formControl;
  final String? labelText;
  final String? hintText;
  final String? Function(DateTime?)? validationMessages;
  final bool Function(FormControl)? showErrors;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? errorText;
  final InputDecoration? decoration;

  const DompetReactiveDatePicker({
    super.key,
    required this.formControl,
    this.labelText,
    this.hintText,
    this.validationMessages,
    this.showErrors,
    this.firstDate,
    this.lastDate,
    this.errorText,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<DateTime?, DateTime?>(
      formControl: formControl,
      builder: (ReactiveFormFieldState<DateTime?, DateTime?> field) {
        final String displayText = field.value != null
            ? DateFormat('dd MMMM yyyy').format(field.value!)
            : '';

        return InkWell(
          onTap: () {
            _selectDate(context, field);
          },
          child: InputDecorator(
            decoration: (decoration ?? const InputDecoration()).copyWith(
              labelText: labelText,
              hintText: hintText,
              errorText: errorText ?? (field.errorText),
            ),
            isEmpty: displayText.isEmpty,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                displayText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: displayText.isEmpty
                        ? AppTheme.disabledColor
                        : AppTheme.textColorPrimary,
                    height: 1),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    ReactiveFormFieldState<DateTime?, DateTime?> field,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: field.value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1971),
      lastDate: lastDate ?? DateTime(2097),
    );

    if (picked != null) {
      field.didChange(picked);
    }
  }
}
