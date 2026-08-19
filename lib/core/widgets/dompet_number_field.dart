import 'package:dompet_app/core/utils/dompet_input_decoration.dart';
import 'package:dompet_app/core/utils/format_currency.dart';
import 'package:dompet_app/core/widgets/calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A masked input field for amount values that:
/// - Displays values with thousand separators (e.g., "2.500")
/// - Stores values as integers (e.g., 2500)
/// - Uses reactive_forms for form management
class DompetNumberField extends ReactiveFormField<int?, int?> {
  final String? labelText;
  final String? hintText;
  final String helperText;
  final InputDecoration? decoration;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final bool showRequiredLabel;
  final TextStyle? textStyle;
  final bool autoFocus;
  final InputBorder? border;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool showCalculator;

  DompetNumberField({
    super.key,
    required FormControl<int> formControl,
    this.labelText,
    this.hintText,
    this.helperText = '',
    this.decoration,
    this.keyboardType = TextInputType.number,
    this.textInputAction,
    this.onEditingComplete,
    bool isCurrency = true,
    bool readOnly = false,
    super.validationMessages,
    super.showErrors,
    this.border,
    this.autoFocus = false,
    this.showRequiredLabel = false,
    this.floatingLabelBehavior,
    this.textStyle,
    this.showCalculator = false,
  }) : super(
         formControl: formControl,
         builder: (ReactiveFormFieldState<int?, int?> field) {
           final isRequired = formControl.validators.contains(
             Validators.required,
           );
           return _AmountInput(
             field: field,
             labelText: labelText,
             hintText: hintText,
             helperText: helperText,
             decoration: decoration,
             keyboardType: keyboardType,
             textInputAction: textInputAction,
             onEditingComplete: onEditingComplete,
             isRequired: showRequiredLabel && isRequired,
             isCurrency: isCurrency,
             textStyle: textStyle,
             autoFocus: autoFocus,
             floatingLabelBehavior: floatingLabelBehavior,
             border: border,
             readOnly: readOnly,
             showCalculator: showCalculator,
           );
         },
       );
}

class _AmountInput extends StatefulWidget {
  final ReactiveFormFieldState<int?, int?> field;
  final String? labelText;
  final String? hintText;
  final String helperText;
  final InputDecoration? decoration;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final bool isRequired;
  final bool isCurrency;
  final bool autoFocus;
  final TextStyle? textStyle;
  final InputBorder? border;
  final bool readOnly;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool showCalculator;

  const _AmountInput({
    required this.field,
    this.labelText,
    this.hintText,
    this.helperText = '',
    this.decoration,
    required this.keyboardType,
    this.textInputAction,
    this.onEditingComplete,
    this.isRequired = false,
    this.isCurrency = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.textStyle,
    this.floatingLabelBehavior,
    this.border = const OutlineInputBorder(),
    this.showCalculator = false,
  });

  @override
  _AmountInputState createState() => _AmountInputState();
}

class _AmountInputState extends State<_AmountInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Initialize with formatted value if exists
    if (widget.field.value != null) {
      _controller.text = FormatCurrency.format(widget.field.value!);
    }

    // Listen to changes from the form control
    widget.field.control.valueChanges.listen((value) {
      if (mounted) {
        if (value != null) {
          final formatted = FormatCurrency.format(value);
          if (_controller.text != formatted) {
            setState(() {
              _controller.text = formatted;
            });
          }
        } else {
          // Handle null value case
          if (_controller.text.isNotEmpty) {
            setState(() {
              _controller.text = '';
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return TextFormField(
      style: widget.textStyle,
      controller: _controller,
      focusNode: widget.field.focusNode,
      keyboardType: widget.keyboardType,
      autofocus: widget.autoFocus,
      textInputAction: widget.textInputAction,
      enabled: !widget.field.control.disabled,
      readOnly: widget.readOnly,
      decoration: DompetInputDecoration(
        border: widget.border,
        labelText: widget.labelText,
        themeData: themeData,
        helperText: widget.helperText,
        placeholder: widget.hintText,
        isRequired: widget.isRequired,
        errorText: widget.field.errorText,
        customFloatingLabelBehavior: widget.floatingLabelBehavior,
        prefix: widget.isCurrency
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text('Rp'),
              )
            : null,
        suffixIcon: widget.showCalculator
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CalculatorTriggerButton(
                  initialValue: widget.field.value ?? 0,
                  iconSize: 18,
                  padding: const EdgeInsets.all(4),
                  onValueApplied: (value) {
                    widget.field.control
                      ..updateValue(value)
                      ..markAsDirty()
                      ..markAsTouched();
                  },
                ),
              )
            : null,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onChanged: (value) {
        if (value.isEmpty) {
          _controller.value = const TextEditingValue();
          widget.field.didChange(null);
          return;
        }

        final formattedDisplay = FormatCurrency.formatInput(value);
        if (_controller.text != formattedDisplay) {
          // Count how many digits are to the left of the cursor in the RAW input.
          // `value` here is already stripped of separators by FilteringTextInputFormatter,
          // so the cursor position in `value` == number of digits to the left.
          final cursorPosInRaw = _controller.selection.start.clamp(
            0,
            value.length,
          );

          // Now find where that same digit-count lands in the formatted string.
          int digitsCount = 0;
          int newCursorPosition = formattedDisplay.length; // fallback: end

          for (int i = 0; i < formattedDisplay.length; i++) {
            if (digitsCount == cursorPosInRaw) {
              newCursorPosition = i;
              break;
            }
            if (formattedDisplay[i] != '.') {
              digitsCount++;
            }
          }

          _controller.value = TextEditingValue(
            text: formattedDisplay,
            selection: TextSelection.collapsed(offset: newCursorPosition),
          );
        }

        final intValue = FormatCurrency.parse(value);
        widget.field.didChange(intValue);
      },
      onEditingComplete: widget.onEditingComplete,
    );
  }
}
