import 'package:intl/intl.dart';

class FormatCurrency {
  static final NumberFormat _currencyFormatter =
      NumberFormat.decimalPattern('id');

  static final NumberFormat _rupiahFormatter =
      NumberFormat.simpleCurrency(locale: 'id', name: 'IDR', decimalDigits: 0);

  /// Format an integer value as a currency string with thousand separators
  /// e.g., 1000000 -> "1.000.000"
  static String format(int value) {
    return _currencyFormatter.format(value);
  }

  /// Format an integer value as Rupiah currency with Rp symbol
  /// e.g., 1000000 -> "Rp1.000.000"
  static String formatRupiah(int value) {
    return _rupiahFormatter.format(value);
  }

  /// Parse a currency string back to an integer value
  /// e.g., "1.000.000" -> 1000000
  static int parse(String value) {
    // Remove all non-digit characters
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleaned) ?? 0;
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
