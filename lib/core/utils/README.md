# Utils Directory

This directory contains utility functions, helpers, and shared functionality used throughout the application.

## Purpose

The utils directory provides:
- Validation functions for user input
- Data formatting and parsing functions
- Helper functions for common operations
- Extension methods
- Constants and enums

## Structure

- `/validators` - Input validation functions
- `/formatters` - Data formatting functions (currency, date, etc.)
- `/helpers` - General helper functions
- `/extensions` - Dart extension methods

## Implementation

Utility functions should be pure functions that don't have side effects and don't depend on application state. They provide common functionality that can be reused across different parts of the application.

## Example

```dart
// Validator
class EmailValidator {
  static String? validate(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!email.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }
}

// Formatter
class CurrencyFormatter {
  static String format(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}
```