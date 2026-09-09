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
  /// FIX-13: dipanggil setelah `reset()` saat tombol clear ditekan.
  /// Halaman search mengisinya dengan fetch eksplisit tanpa keyword
  /// (mis. `() => _budgetCubit.fetch()`), tanpa mengandalkan debounce.
  /// Fokus tidak diubah agar user bisa langsung mengetik lagi (Q13 A).
  final VoidCallback? onClear;
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
    this.onClear,
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
        // FIX-13: predicate `&&` (dulu `||` sehingga `""` tetap
        // dianggap ada), rebuild reaktif agar tombol muncul/hilang live,
        // dan `onClear` picu fetch ulang eksplisit tanpa keyword.
        suffixIcon: clearable
            ? ReactiveValueListenableBuilder(
                formControl: formControl,
                builder: (context, control, _) {
                  final value = control.value;
                  final hasValue =
                      value != null &&
                      (value is! String || value.isNotEmpty);
                  if (!hasValue) return suffixIcon ?? SizedBox.shrink();
                  return IconButton(
                    tooltip: 'Bersihkan pencarian',
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      formControl.reset();
                      onClear?.call();
                    },
                  );
                },
              )
            : suffixIcon,
        prefix: isShowPrefix ? searchPrefix : null,
      ),
    );
  }
}
