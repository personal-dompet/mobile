import 'dart:math';

import 'package:flutter/material.dart';

/// A collection of predefined vibrant OLED-friendly colors for pockets.
/// Users can only select colors from this constant collection.
/// PocketColor extends Color, so instances can be used anywhere a Color is expected.
class PocketColor extends Color {
  /// Creates a PocketColor from an ARGB integer value.
  const PocketColor(super.value);

  /// Returns a list of 16 distinct vibrant OLED-friendly colors
  static List<PocketColor> get colors => [
        // Red/Pink variants
        const PocketColor(0xFFEF5350), // Vibrant Red
        const PocketColor(0xFFF06292), // Vibrant Pink

        // Orange/Yellow variants
        const PocketColor(0xFFFF9800), // Vibrant Orange
        const PocketColor(0xFFFFCA28), // Vibrant Amber
        const PocketColor(0xFFFDD835), // Vibrant Yellow

        // Green variants
        const PocketColor(0xFF4CAF50), // Vibrant Green
        const PocketColor(0xFF8BC34A), // Vibrant Lime Green

        // Blue/Cyan variants
        const PocketColor(0xFF29B6F6), // Vibrant Cyan
        const PocketColor(0xFF42A5F5), // Vibrant Blue
        const PocketColor(0xFF64B5F6), // Vibrant Light Blue

        // Purple/Violet variants
        const PocketColor(0xFFAB47BC), // Vibrant Purple
        const PocketColor(0xFFBA68C8), // Vibrant Orchid
        const PocketColor(0xFFCE93D8), // Vibrant Lavender

        // Neutral variants
        const PocketColor(0xFF8D6E63), // Vibrant Brown
        const PocketColor(0xFF78909C), // Vibrant Blue Grey

        const PocketColor(0xFF757575), // Vibrant Grey
      ];

  /// Converts this PocketColor to a hex string representation
  /// This is used for storing colors in the database
  String toHex() {
    return '#${toARGB32().toRadixString(16).substring(2).padLeft(6, '0')}';
  }

  /// Parses a hex string representation to a PocketColor object
  /// This is used for retrieving colors from the database
  static PocketColor parse(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return PocketColor(int.parse(buffer.toString(), radix: 16));
  }

  /// Returns a randomly selected color from the predefined colors list
  static PocketColor get randomColor {
    final random = Random();
    final randomIndex = random.nextInt(colors.length);
    return colors[randomIndex];
  }

  /// Returns a background color with reduced alpha (0.25)
  Color get background => withValues(alpha: 0.25);

  /// Returns the icon color (this color)
  Color get iconColor => this;
}
