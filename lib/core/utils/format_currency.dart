import 'package:intl/intl.dart';

class FormatCurrency {
  static final NumberFormat _currencyFormatter = NumberFormat.decimalPattern(
    'id',
  );

  /// Parse a currency string back to an integer value via intl
  /// e.g., "1.000.000" -> 1000000
  static int parse(String value) {
    if (value.isEmpty) return 0;
    try {
      return _currencyFormatter.parse(value).toInt();
    } catch (_) {
      final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
      return int.tryParse(cleaned) ?? 0;
    }
  }

  /// Format a string value during input to show thousand separators
  /// e.g., "1000000" -> "1.000.000"
  static String formatInput(String value) {
    if (value.isEmpty) return '';

    // Remove all non-digit characters first
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.isEmpty) return '';

    // Format with thousand separators
    return _currencyFormatter.format(int.parse(digits));
  }
}
