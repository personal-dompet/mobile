import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A reactive date time picker widget that displays date and time in DD MMMM yyyy, HH:mm format
class DompetReactiveDateTimePicker extends StatelessWidget {
  final FormControl<DateTime?> formControl;
  final String? labelText;
  final String? hintText;
  final String? Function(DateTime?)? validationMessages;
  final bool Function(FormControl)? showErrors;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final TimePickerEntryMode? timePickerEntryMode;
  final String? errorText;
  final InputDecoration? decoration;

  const DompetReactiveDateTimePicker({
    super.key,
    required this.formControl,
    this.labelText,
    this.hintText,
    this.validationMessages,
    this.showErrors,
    this.firstDate,
    this.lastDate,
    this.timePickerEntryMode,
    this.errorText,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<DateTime?, DateTime?>(
      formControl: formControl,
      builder: (ReactiveFormFieldState<DateTime?, DateTime?> field) {
        final String displayText = field.value != null
            ? DateFormat('dd MMMM yyyy, HH:mm').format(field.value!)
            : '';

        return InkWell(
          onTap: () {
            _selectDateTime(context, field);
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

  Future<void> _selectDateTime(
    BuildContext context,
    ReactiveFormFieldState<DateTime?, DateTime?> field,
  ) async {
    final DateTime pickedDate = field.value ?? DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2101),
    );

    if (selectedDate != null && context.mounted) {
      // Get the selected time
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(field.value ?? DateTime.now()),
        builder: (context, child) {
          // This builder is needed if you want to customize the time picker theme
          return child!;
        },
        // Use the provided timePickerEntryMode or default to dial
        initialEntryMode: timePickerEntryMode ?? TimePickerEntryMode.dial,
      );

      if (selectedTime != null) {
        // Combine selected date and selected time into a DateTime
        final DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Check if context is still valid before updating the field
        if (context.mounted) {
          field.didChange(selectedDateTime);
        }
      }
    }
  }
}
