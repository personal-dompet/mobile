import 'package:dompet_app/core/utils/dompet_input_decoration.dart';
import 'package:dompet_app/core/widgets/dompet_month_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DompetMonthField extends ReactiveFormField<DateTime, DateTime> {
  final String? labelText;
  final String? hintText;
  final String helperText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showRequiredLabel;
  final bool readOnly;
  final InputDecoration? decoration;
  final InputBorder? border;
  final FloatingLabelBehavior? floatingLabelBehavior;

  DompetMonthField({
    super.key,
    required FormControl<DateTime> formControl,
    this.labelText,
    this.hintText,
    this.helperText = '',
    this.firstDate,
    this.lastDate,
    this.showRequiredLabel = false,
    this.readOnly = false,
    this.decoration,
    this.border = const OutlineInputBorder(),
    this.floatingLabelBehavior,
    super.validationMessages,
    super.showErrors,
  }) : super(
         formControl: formControl,
         builder: (ReactiveFormFieldState<DateTime, DateTime> field) {
           final isRequired = formControl.validators.contains(
             Validators.required,
           );
           return _MonthInput(
             field: field,
             labelText: labelText,
             hintText: hintText,
             helperText: helperText,
             isRequired: showRequiredLabel && isRequired,
             firstDate: firstDate,
             lastDate: lastDate,
             readOnly: readOnly,
             decoration: decoration,
             border: border,
             floatingLabelBehavior: floatingLabelBehavior,
           );
         },
       );
}

class _MonthInput extends StatefulWidget {
  final ReactiveFormFieldState<DateTime, DateTime> field;
  final String? labelText;
  final String? hintText;
  final String helperText;
  final bool isRequired;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool readOnly;
  final InputDecoration? decoration;
  final InputBorder? border;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const _MonthInput({
    required this.field,
    this.labelText,
    this.hintText,
    this.helperText = '',
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
    this.readOnly = false,
    this.decoration,
    this.border = const OutlineInputBorder(),
    this.floatingLabelBehavior,
  });

  @override
  State<_MonthInput> createState() => _MonthInputState();
}

class _MonthInputState extends State<_MonthInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.field.value));
    widget.field.control.valueChanges.listen((value) {
      if (mounted) {
        final formatted = _format(value);
        if (_controller.text != formatted) {
          setState(() {
            _controller.text = formatted;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(DateTime? value) {
    if (value == null) return '';
    return DateFormat('MMMM yyyy', 'id').format(value);
  }

  Future<void> _openPicker() async {
    final selected = await showMonthPicker(
      context,
      initialDate: widget.field.value ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (selected != null) {
      widget.field.didChange(selected);
      widget.field.control.markAsTouched();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: widget.readOnly ? null : _openPicker,
      decoration:
          widget.decoration ??
          DompetInputDecoration(
            border: widget.border,
            labelText: widget.labelText,
            themeData: themeData,
            helperText: widget.helperText,
            placeholder: widget.hintText,
            isRequired: widget.isRequired,
            errorText: widget.field.errorText,
            customFloatingLabelBehavior: widget.floatingLabelBehavior,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.calendar_month_rounded,
                size: 18,
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
    );
  }
}
