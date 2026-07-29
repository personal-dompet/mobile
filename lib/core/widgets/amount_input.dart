import 'package:dompet_app/core/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AmountInput extends StatelessWidget {
  final FormControl<int> formControl;
  final String? errorMessage;
  final bool readOnly;
  final TextInputAction textInputAction;
  const AmountInput({
    super.key,
    required this.formControl,
    this.errorMessage,
    this.readOnly = false,
    this.textInputAction = .next,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveStatusListenableBuilder(
      formControl: formControl,
      builder: (context, control, child) {
        final amountControl = control as FormControl<int>;
        return StreamBuilder<bool>(
          stream: amountControl.touchChanges,
          builder: (context, control) {
            final textPainter = TextPainter(
              text: TextSpan(
                text: errorMessage,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              maxLines: 1,
              textDirection: .ltr,
            )..layout();

            final errorWidth = textPainter.width;

            return ConstrainedBox(
              constraints: BoxConstraints(
                minWidth:
                    amountControl.invalid &&
                        (amountControl.touched || amountControl.dirty)
                    ? errorWidth
                    : 96,
              ),
              child: IntrinsicWidth(
                child: DompetNumberField(
                  autoFocus: true,
                  border: UnderlineInputBorder(),
                  formControl: amountControl,
                  readOnly: readOnly,
                  textStyle: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(fontWeight: .w600),
                  showErrors: (control) =>
                      control.invalid &&
                      (amountControl.touched || amountControl.dirty),
                  isCurrency: true,
                  textInputAction: textInputAction,
                  floatingLabelBehavior: .always,
                  validationMessages: {
                    ValidationMessage.required: (error) => errorMessage ?? '',
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
