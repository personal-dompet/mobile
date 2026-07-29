import 'package:dompet_app/core/utils/dompet_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DompetDropdownField<T> extends StatelessWidget {
  final FormControl<T> formControl;
  final List<DropdownMenuItem<T>> items;
  final Map<String, String Function(Object)>? validationMessages;
  final String label;
  final String? placeholder;
  final String helper;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final bool showRequiredLabel;
  final bool readOnly;
  final void Function(FormControl<T>)? onTap;

  const DompetDropdownField({
    super.key,
    required this.label,
    required this.formControl,
    required this.items,
    this.validationMessages,
    this.placeholder,
    this.textCapitalization,
    this.textInputAction,
    this.helper = '',
    this.showRequiredLabel = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRequired = formControl.validators.contains(Validators.required);
    final themeData = Theme.of(context);
    return ReactiveValueListenableBuilder(
      formControl: formControl,
      builder: (context, control, child) {
        return ReactiveDropdownField(
          formControl: formControl,
          showErrors: (control) {
            return control.invalid && (control.touched || control.dirty);
          },
          validationMessages: validationMessages,
          readOnly: readOnly,
          onTap: (control) {},
          decoration: DompetInputDecoration(
            labelText: label,
            themeData: themeData,
            helperText: helper,
            isRequired: showRequiredLabel && isRequired,
            placeholder: placeholder,
          ),
          items: items,
        );
      },
    );
  }
}
