import 'package:flutter/material.dart';

/// AppTheme provides easy access to all theme colors and properties
/// Access colors using AppTheme.primaryColor, AppTheme.successColor, etc.
class AppTheme {
  // Base pastel colors
  static const Color primaryPastel = Color(0xFF60a39c); // Slightly darker pastel teal
  static const Color secondaryPastel = Color(0xFFffafcc); // Pastel Coral
  static const Color accentPastel = Color(0xFFffd6a5); // Pastel Orange

  // Surface and background colors (darker pastels for contrast)
  static const Color surfaceColor = Color(0xFF2C2C2C); // Dark gray
  static const Color backgroundColor =
      Color(0xFF1A1A1A); // Very dark gray (natural dark)
  static const Color cardColor = Color(0xFF3A3A3A); // Lighter gray for cards

  // Utility colors (pastel variants)
  static const Color primaryColor = primaryPastel;
  static const Color secondaryColor = secondaryPastel;
  static const Color errorColor = Color(0xFFffb3ba); // Pastel Red
  static const Color successColor = Color(0xFFb5ead7); // Mint Green
  static const Color warningColor = Color(0xFFffeaa7); // Mellow Yellow
  static const Color infoColor = Color(0xFF87ceeb); // Sky Blue
  static const Color disabledColor = Color(0xFFa8a8a8); // Pastel Gray

  // Text and icon colors
  static const Color textColorPrimary = Color(0xFFE5E7EB); // Light gray
  static const Color textColorSecondary = Color(0xFFD1D5DB); // Medium gray
  static const Color textColorTertiary = Color(0xFF9CA3AF); // Darker gray
}

class AppThemes {
  static ThemeData get darkTheme {
    return ThemeData(
      // Core theme properties
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppTheme.primaryPastel,
        brightness: Brightness.dark,
        primary: AppTheme.primaryColor,
        onPrimary: Colors.white,
        secondary: AppTheme.secondaryColor,
        onSecondary: Colors.white,
        surface: AppTheme.surfaceColor,
        onSurface: AppTheme.textColorPrimary,
        error: AppTheme.errorColor,
        onError: Colors.white,
        tertiary: AppTheme.successColor,
        onTertiary: Colors.white,
        outline: AppTheme.textColorTertiary,
        outlineVariant: AppTheme.textColorSecondary,
        surfaceContainerHighest: AppTheme.cardColor,
        onSurfaceVariant: AppTheme.textColorSecondary,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppTheme.backgroundColor,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppTheme.cardColor,
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
          backgroundColor: AppTheme.primaryColor,
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
          foregroundColor: AppTheme.primaryColor,
          side: BorderSide(color: AppTheme.primaryColor, width: 1.5),
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
          foregroundColor: AppTheme.primaryColor,
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: const CircleBorder(),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.textColorTertiary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.textColorTertiary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.errorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: AppTheme.textColorTertiary),
        hintStyle: const TextStyle(color: AppTheme.textColorSecondary),
        prefixIconColor: AppTheme.textColorTertiary,
        suffixIconColor: AppTheme.textColorTertiary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: BorderSide(color: AppTheme.textColorTertiary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor;
          }
          return AppTheme.textColorTertiary;
        }),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor;
          }
          return AppTheme.textColorTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primaryColor.withValues(alpha: 0.5);
          }
          return AppTheme.surfaceColor;
        }),
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppTheme.primaryColor,
        inactiveTrackColor: AppTheme.surfaceColor,
        thumbColor: AppTheme.primaryColor,
        overlayColor: AppTheme.primaryColor.withValues(alpha: 0.1),
        valueIndicatorColor: AppTheme.primaryColor,
        valueIndicatorTextStyle: const TextStyle(color: Colors.white),
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppTheme.primaryColor,
        linearTrackColor: AppTheme.surfaceColor,
        circularTrackColor: AppTheme.surfaceColor,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: AppTheme.textColorPrimary,
          fontSize: 16,
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppTheme.surfaceColor,
        modalBackgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppTheme.backgroundColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textColorTertiary,
        selectedIconTheme: const IconThemeData(color: AppTheme.primaryColor),
        unselectedIconTheme: IconThemeData(color: AppTheme.textColorTertiary),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTheme.cardColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppTheme.surfaceColor,
        thickness: 1,
        space: 1,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: AppTheme.textColorPrimary,
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
          color: AppTheme.textColorPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppTheme.textColorPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppTheme.textColorPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppTheme.textColorTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.textColorPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppTheme.textColorTertiary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppTheme.textColorSecondary,
        ),
      ),
    );
  }
}
