import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A masked input field for amount values that:
/// - Displays values with thousand separators (e.g., "2.500")
/// - Stores values as integers (e.g., 2500)
/// - Uses reactive_forms for form management
class MaskedAmountInput extends ReactiveFormField<int?, int?> {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final InputDecoration? decoration;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  MaskedAmountInput({
    super.key,
    required FormControl<int> formControl,
    // required String formControlName,
    this.labelText,
    this.hintText,
    this.helperText,
    this.decoration,
    this.keyboardType = TextInputType.number,
    this.textInputAction,
    this.onEditingComplete,
    super.validationMessages,
    super.showErrors,
  }) : super(
          formControl: formControl,
          builder: (ReactiveFormFieldState<int?, int?> field) {
            return _AmountInput(
              field: field,
              labelText: labelText,
              hintText: hintText,
              helperText: helperText,
              decoration: decoration,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onEditingComplete: onEditingComplete,
            );
          },
        );
}

class _AmountInput extends StatefulWidget {
  final ReactiveFormFieldState<int?, int?> field;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final InputDecoration? decoration;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  const _AmountInput({
    required this.field,
    this.labelText,
    this.hintText,
    this.helperText,
    this.decoration,
    required this.keyboardType,
    this.textInputAction,
    this.onEditingComplete,
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

  InputDecoration _buildInputDecoration() {
    final baseDecoration = widget.decoration ?? const InputDecoration();
    return baseDecoration.copyWith(
      labelText: widget.labelText ?? baseDecoration.labelText,
      hintText: widget.hintText ?? baseDecoration.hintText,
      helperText: widget.helperText ?? baseDecoration.helperText,
      errorText: widget.field.errorText,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: widget.field.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      enabled: !widget.field.control.disabled,
      decoration: _buildInputDecoration(),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        // Format the display value
        if (value.isEmpty) {
          // Handle empty input as null
          _controller.value = const TextEditingValue();
          widget.field.didChange(null);
          return;
        }

        final formattedDisplay = FormatCurrency.formatInput(value);
        if (_controller.text != formattedDisplay) {
          final cursorPosition = _controller.selection.start;
          final oldTextLength = _controller.text.length;

          // Calculate new cursor position
          int newCursorPosition =
              cursorPosition + (formattedDisplay.length - oldTextLength);

          // Handle adding digits that create separators
          if (formattedDisplay.length > oldTextLength &&
              cursorPosition > 0 &&
              cursorPosition < oldTextLength) {
            // Adding a digit
            final charBeforeCursor =
                _controller.text.substring(cursorPosition - 1, cursorPosition);
            if (charBeforeCursor == '.') {
              // If character before cursor was a separator, move cursor after it
              newCursorPosition = cursorPosition +
                  (formattedDisplay.length - oldTextLength) +
                  1;
            }
          }

          // Ensure cursor position is within bounds
          newCursorPosition =
              newCursorPosition.clamp(0, formattedDisplay.length);

          _controller.value = TextEditingValue(
            text: formattedDisplay,
            selection: TextSelection.collapsed(offset: newCursorPosition),
          );
        }

        // Update the form control with the integer value
        final intValue = FormatCurrency.parse(value);
        widget.field.didChange(intValue);
      },
      onEditingComplete: widget.onEditingComplete,
    );
  }
}
