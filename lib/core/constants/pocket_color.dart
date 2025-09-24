import 'dart:math';

import 'package:flutter/material.dart';

/// A collection of predefined warm pastel colors for pockets.
/// Users can only select colors from this constant collection.
/// PocketColor extends Color, so instances can be used anywhere a Color is expected.
class PocketColor extends Color {
  /// Creates a PocketColor from an ARGB integer value.
  const PocketColor(super.value);

  /// Returns a list of 16 distinct warm pastel colors
  static List<PocketColor> get colors => [
        // Red/Pink variants
        const PocketColor(0xFFffadad), // Pastel Red
        const PocketColor(0xFFff847c), // Watermelon

        // Orange/Yellow variants
        const PocketColor(0xFFffd6a5), // Pastel Orange
        const PocketColor(0xFFffd8be), // Apricot
        const PocketColor(0xFFffffba), // Light Yellow

        // Green variants
        const PocketColor(0xFFcaffbf), // Pastel Green
        const PocketColor(0xFF99b898), // Sage Green

        // Blue/Cyan variants
        const PocketColor(0xFF9bf6ff), // Pastel Cyan
        const PocketColor(0xFFa0c4ff), // Pastel Blue
        const PocketColor(0xFFbae1ff), // Baby Blue

        // Purple/Violet variants
        const PocketColor(0xFFbdb2ff), // Pastel Indigo
        const PocketColor(0xFFe1baff), // Lavender
        const PocketColor(0xFFd291bc), // Orchid

        // Neutral variants
        const PocketColor(0xFFe2f0cb), // Light Moss Green
        const PocketColor(0xFFc7ceea), // Periwinkle

        const PocketColor(0xFFb0b0b0), // Grey
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
