import 'package:dompet_app/core/widgets/dompet_date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Date picker tanggal saja (tanpa jam). Thin alias over [DompetDateTimePicker].
class DompetDatePicker extends StatelessWidget {
  final FormControl<DateTime> formControl;
  final String label;
  final String? placeholder;
  final String helper;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showClearIcon;

  const DompetDatePicker({
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
    return DompetDateTimePicker(
      formControl: formControl,
      label: label,
      placeholder: placeholder,
      firstDate: firstDate,
      lastDate: lastDate,
      helper: helper,
      showClearIcon: showClearIcon,
      withTime: false,
    );
  }
}
