# Utils Formatters Directory

This directory contains data formatting functions for displaying information to users.

## Purpose

Formatting functions in this directory:
- Format data for consistent display
- Convert between different data representations
- Handle locale-specific formatting
- Provide reusable formatting utilities

## Structure

- `currency_formatter.dart` - Currency formatting
- `date_formatter.dart` - Date and time formatting
- `number_formatter.dart` - Number formatting
- `phone_formatter.dart` - Phone number formatting

## Implementation

Formatting functions:
- Are pure functions with no side effects
- Handle different locales and formatting options
- Provide default formatting with optional customization
- Are reusable across different parts of the application

## Example

```dart
class CurrencyFormatter {
  static String format(double amount, {String currency = 'USD', Locale? locale}) {
    final format = NumberFormat.simpleCurrency(
      name: currency,
      locale: locale?.toString(),
    );
    return format.format(amount);
  }
  
  static String formatCompact(double amount, {Locale? locale}) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}

class DateFormatter {
  static String format(DateTime date, {Locale? locale}) {
    final format = DateFormat.yMMMMd(locale?.toString());
    return format.format(date);
  }
  
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
```