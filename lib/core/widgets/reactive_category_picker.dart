import 'package:dompet/core/enum/category.dart';
import 'package:dompet/routes/select_category_route.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A reactive category picker widget that displays the selected category's display name
/// and opens a category selector when tapped, similar to a date picker.
class DompetReactiveCategoryPicker extends StatelessWidget {
  final FormControl<Category?> formControl;
  final String? labelText;
  final String? hintText;
  final String? Function(Category?)? validationMessages;
  final bool Function(FormControl)? showErrors;
  final String? errorText;
  final InputDecoration? decoration;

  const DompetReactiveCategoryPicker({
    super.key,
    required this.formControl,
    this.labelText,
    this.hintText,
    this.validationMessages,
    this.showErrors,
    this.errorText,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<Category?, Category?>(
      formControl: formControl,
      builder: (ReactiveFormFieldState<Category?, Category?> field) {
        final String displayText = field.value?.displayName ?? '';
        final IconData? iconData = field.value?.icon;

        return InkWell(
          onTap: () async {
            final category = await SelectCategoryRoute(
              selectedCategoryIconKey: formControl.value?.iconKey,
            ).push<Category>(context);
            if (category == null) return;
            formControl.value = category;
          },
          child: InputDecorator(
            decoration: (decoration ?? const InputDecoration()).copyWith(
              labelText: labelText,
              hintText: hintText,
              errorText: errorText ?? (field.errorText),
              prefixIcon: iconData != null
                  ? Icon(
                      iconData,
                      color: displayText.isEmpty
                          ? AppTheme.disabledColor
                          : AppTheme.textColorPrimary,
                    )
                  : null,
              suffixIcon: const Icon(
                Icons.chevron_right,
                color: AppTheme.textColorSecondary,
              ),
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
}
