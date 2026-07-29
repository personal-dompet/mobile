import 'package:dompet_app/core/utils/dompet_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DompetTextField<T> extends StatelessWidget {
  final FormControl<T> formControl;
  final Map<String, String Function(Object)>? validationMessages;
  final Widget? suffixIcon;
  final void Function(FormControl<T> control)? onTap;
  final FocusNode? focusNode;
  final String? label;
  final String? placeholder;
  final String helper;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final Widget? prefix;
  final bool hidePrefixOnEmpty;
  final TextInputType? keyboardType;
  final bool showRequiredLabel;
  final bool readOnly;
  final bool clearable;
  final ControlValueAccessor<T, String>? valueAccessor;

  const DompetTextField({
    super.key,
    this.label,
    required this.formControl,
    this.validationMessages,
    this.placeholder,
    this.textCapitalization,
    this.textInputAction,
    this.keyboardType,
    this.onTap,
    this.focusNode,
    this.valueAccessor,
    this.prefix,
    this.helper = '',
    this.hidePrefixOnEmpty = false,
    this.readOnly = false,
    this.showRequiredLabel = false,
    this.clearable = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isRequired = formControl.validators.contains(Validators.required);
    final themeData = Theme.of(context);
    final searchPrefix = textInputAction == TextInputAction.search
        ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.search_rounded,
              size: 16,
              color: themeData.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          )
        : prefix;
    final isControlEmpty = formControl.value == null;
    final isShowPrefix = !hidePrefixOnEmpty || !isControlEmpty;
    return ReactiveTextField(
      formControl: formControl,
      showErrors: (control) {
        return control.invalid && (control.touched || control.dirty);
      },
      valueAccessor: valueAccessor,
      onTap: onTap,
      focusNode: focusNode,
      readOnly: readOnly,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      validationMessages: validationMessages,
      minLines:
          keyboardType != null &&
              (keyboardType == TextInputType.multiline ||
                  keyboardType == TextInputType.streetAddress)
          ? 3
          : 1,
      maxLines:
          keyboardType != null &&
              (keyboardType == TextInputType.multiline ||
                  keyboardType == TextInputType.streetAddress)
          ? 5
          : 1,
      decoration: DompetInputDecoration(
        labelText: label,
        themeData: themeData,
        helperText: helper,
        isRequired: showRequiredLabel && isRequired,
        placeholder: placeholder,
        suffixIcon:
            clearable &&
                (formControl.value != null ||
                    (formControl.value is String &&
                        (formControl.value as String).isNotEmpty))
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  formControl.reset();
                },
              )
            : suffixIcon,
        prefix: isShowPrefix ? searchPrefix : null,
      ),
    );
  }
}
