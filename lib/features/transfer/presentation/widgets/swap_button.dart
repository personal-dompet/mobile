import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SwapButton<T> extends StatelessWidget {
  // final T form;
  final void Function() onTap;
  // final bool disabled;

  const SwapButton({
    super.key,
    // required this.form,
    required this.onTap,
    // this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(
      builder: (context, _, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: AppTheme.disabledColor,
                ),
              ),
              InkWell(
                onTap: onTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: BoxBorder.all(color: AppTheme.secondaryColor)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_vert,
                        size: 12,
                        color: AppTheme.secondaryColor,
                      ),
                      Text(
                        'Swap pockets',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppTheme.disabledColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
