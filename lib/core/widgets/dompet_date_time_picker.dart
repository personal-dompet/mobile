import 'package:dompet_app/core/utils/dompet_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DompetDateTimePicker extends StatelessWidget {
  final FormControl<DateTime> formControl;
  final String label;
  final String? placeholder;
  final String helper;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showClearIcon;

  const DompetDateTimePicker({
    super.key,
    required this.formControl,
    required this.label,
    this.placeholder,
    this.firstDate,
    this.lastDate,
    this.helper = '',
    this.showClearIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder(
      formControl: formControl,
      builder: (context, control, child) {
        final dateControl = control as FormControl<DateTime>;
        return ReactiveDateTimePicker(
          formControl: dateControl,
          type: .dateTime,
          showErrors: (control) {
            return control.invalid && (control.touched || control.dirty);
          },
          dateFormat: DateFormat('d MMMM yyyy • HH:mm', 'id'),
          showClearIcon: showClearIcon,
          confirmText: 'Simpan',
          cancelText: 'Batal',
          datePickerEntryMode: .calendarOnly,
          hourLabelText: 'Jam',
          minuteLabelText: 'Menit',
          locale: Locale('id', ''),
          firstDate: firstDate,
          lastDate: lastDate,
          validationMessages: {
            ValidationMessage.required: (error) {
              return 'Pilih ${label.toLowerCase()} dahulu';
            },
          },
          decoration: DompetInputDecoration(
            labelText: label,
            themeData: Theme.of(context),
            placeholder: placeholder,
            helperText: helper,
          ),
        );
      },
    );
  }
}
