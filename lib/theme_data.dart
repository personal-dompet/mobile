import 'package:flutter/material.dart';

class AppThemes {
  // Define custom colors
  static const Color _primaryColor = Color(0xFF6366F1); // Indigo
  static const Color _secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color _surfaceColor = Color(0xFF1F2023); // Dark gray
  static const Color _backgroundColor = Colors.black;
  static const Color _cardColor = _surfaceColor; // Very dark gray
  static const Color _errorColor = Color(0xFFEF4444); // Red
  static const Color _successColor = Color(0xFF10B981); // Green
  // static const Color _warningColor = Color(0xFFF59E0B); // Amber

  static ThemeData get darkTheme {
    return ThemeData(
      // Core theme properties
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        onPrimary: Colors.white,
        secondary: _secondaryColor,
        onSecondary: Colors.white,
        surface: _surfaceColor,
        onSurface: Color(0xFFE5E7EB), // Almost white text
        error: _errorColor,
        onError: Colors.white,
        tertiary: _successColor,
        onTertiary: Colors.white,
        outline: Color(0xFF6B7280), // Gray border
        outlineVariant: Color(0xFF4B5563), // Darker gray border
        surfaceContainerHighest: _cardColor,
        onSurfaceVariant: Color(0xFFD1D5DB), // Light gray text
      ),

      // Scaffold background
      scaffoldBackgroundColor: _backgroundColor,

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: _cardColor,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6B7280)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6B7280)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _errorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
        prefixIconColor: Color(0xFF9CA3AF),
        suffixIconColor: Color(0xFF9CA3AF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: Color(0xFF6B7280), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor;
          }
          return Color(0xFF6B7280);
        }),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor;
          }
          return Color(0xFF9CA3AF);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor.withValues(alpha: 0.5);
          }
          return Color(0xFF4B5563);
        }),
      ),

      // Slider theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: _primaryColor,
        inactiveTrackColor: Color(0xFF4B5563),
        thumbColor: _primaryColor,
        overlayColor: Color(0x1A6366F1),
        valueIndicatorColor: _primaryColor,
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryColor,
        linearTrackColor: Color(0xFF4B5563),
        circularTrackColor: Color(0xFF4B5563),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: Color(0xFFE5E7EB),
          fontSize: 16,
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _surfaceColor,
        modalBackgroundColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _backgroundColor,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Color(0xFF9CA3AF),
        selectedIconTheme: IconThemeData(color: _primaryColor),
        unselectedIconTheme: IconThemeData(color: Color(0xFF9CA3AF)),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _cardColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF4B5563),
        thickness: 1,
        space: 1,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: Color(0xFFE5E7EB),
        size: 24,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE5E7EB),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFFE5E7EB),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFE5E7EB),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9CA3AF),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE5E7EB),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9CA3AF),
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }
}

// class AppThemeData {
//   static final darkTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     primaryColor: Colors.blue,
//     colorScheme: const ColorScheme.dark(
//       primary: Colors.blue,
//       onPrimary: Colors.white,
//       secondary: Colors.lightBlue,
//       onSecondary: Colors.black,
//       surface: Colors.grey,
//       onSurface: Colors.white,
//     ),
//     scaffoldBackgroundColor: Colors.black,
//     cardColor: Colors.grey.shade900,
//     dividerColor: Colors.white.withValues(alpha: 0.3),
//     textTheme: const TextTheme(
//       headlineLarge: TextStyle(
//         color: Colors.white,
//         fontSize: 32,
//         fontWeight: FontWeight.bold,
//       ),
//       headlineMedium: TextStyle(
//         color: Colors.white,
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//       ),
//       headlineSmall: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//       titleLarge: TextStyle(
//         color: Colors.white,
//         fontSize: 18,
//         fontWeight: FontWeight.w600,
//       ),
//       titleMedium: TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//       ),
//       titleSmall: TextStyle(
//         color: Colors.white,
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//       ),
//       bodyLarge: TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//       ),
//       bodyMedium: TextStyle(
//         color: Colors.white70,
//         fontSize: 14,
//       ),
//       bodySmall: TextStyle(
//         color: Colors.white60,
//         fontSize: 12,
//       ),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ButtonStyle(
//         backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
//         foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//         textStyle: WidgetStateProperty.all<TextStyle>(
//           const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         padding: WidgetStateProperty.all<EdgeInsets>(
//           const EdgeInsets.symmetric(
//             horizontal: 24,
//             vertical: 12,
//           ),
//         ),
//         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//     ),
//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: ButtonStyle(
//         foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
//         side: WidgetStateProperty.all<BorderSide>(
//           const BorderSide(
//             color: Colors.blue,
//             width: 2,
//           ),
//         ),
//         textStyle: WidgetStateProperty.all<TextStyle>(
//           const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         padding: WidgetStateProperty.all<EdgeInsets>(
//           const EdgeInsets.symmetric(
//             horizontal: 24,
//             vertical: 12,
//           ),
//         ),
//         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//     ),
//     inputDecorationTheme: const InputDecorationTheme(
//       filled: true,
//       fillColor: Colors.grey,
//       focusColor: Colors.blue,
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.white70,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(8)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.blue,
//           width: 2,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(8)),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.red,
//           width: 2,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(8)),
//       ),
//       labelStyle: TextStyle(
//         color: Colors.white70,
//       ),
//       hintStyle: TextStyle(
//         color: Colors.white60,
//       ),
//     ),
//   );
// }
