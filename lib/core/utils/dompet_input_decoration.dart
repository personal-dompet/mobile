import 'package:flutter/material.dart';

class DompetInputDecoration extends InputDecoration {
  // final ThemeData themeData;
  // final String? placeholder;
  // final bool isRequired;

  DompetInputDecoration({
    required String? labelText,
    super.helperText = '',
    super.errorText,
    super.prefix,
    super.suffixIcon,
    required ThemeData themeData,
    String? placeholder,
    bool isRequired = false,
    FloatingLabelBehavior? customFloatingLabelBehavior,
    super.border = const OutlineInputBorder(),
  }) : super(
         floatingLabelBehavior:
             customFloatingLabelBehavior ??
             (placeholder != null ? .always : .auto),
         hint: placeholder != null
             ? Text(
                 placeholder,
                 style: themeData.textTheme.bodyMedium?.copyWith(
                   color: themeData.hintColor.withValues(alpha: 0.4),
                 ),
               )
             : null,
         label: Text.rich(
           TextSpan(
             children: [
               TextSpan(text: labelText),
               if (isRequired)
                 TextSpan(
                   text: ' (Wajib)',
                   style: TextStyle(color: themeData.colorScheme.error),
                 ),
             ],
           ),
         ),
       );
}
