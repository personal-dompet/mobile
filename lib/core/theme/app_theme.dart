import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
      tertiary: Colors.green.shade300,
      tertiaryContainer: Colors.green.shade600,
      onTertiary: Colors.green.shade900,
      // Merah default M3 (#BA1A1A) terlalu menyala untuk nada Dompet yang
      // tenang — merah di sini juga dipakai untuk konteks netral seperti
      // label pengeluaran, bukan hanya error. Dilunakkan satu tingkat.
      error: Colors.red.shade400,
      onError: Colors.white,
      errorContainer: Colors.red.shade50,
      onErrorContainer: Colors.red.shade900,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
    ),
    cardTheme: const CardThemeData(margin: EdgeInsets.all(0), elevation: 0),
    appBarTheme: const AppBarTheme(
      titleSpacing: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      textStyle: const TextStyle(color: Colors.white),
    ),
    splashColor: Colors.black.withValues(alpha: 0.05),
    highlightColor: Colors.black.withValues(alpha: 0.03),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
      tertiary: Colors.green.shade300,
      tertiaryContainer: Colors.green.shade600,
      onTertiary: Colors.green.shade900,
      // Varian gelap ikut dilunakkan agar konsisten dengan light.
      error: Colors.red.shade300,
      onError: Colors.red.shade900,
      errorContainer: const Color(0xFF5C1F1B),
      onErrorContainer: Colors.red.shade100,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
    ),
    cardTheme: const CardThemeData(margin: EdgeInsets.all(0), elevation: 0),
    appBarTheme: const AppBarTheme(
      titleSpacing: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      textStyle: const TextStyle(color: Colors.white),
    ),
    splashColor: Colors.white.withValues(alpha: 0.05),
    highlightColor: Colors.white.withValues(alpha: 0.03),
  );
}
