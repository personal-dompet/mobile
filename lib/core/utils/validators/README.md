# Utils Validators Directory

This directory contains input validation functions for user data.

## Purpose

Validation functions in this directory:
- Validate user input before processing
- Provide consistent validation rules across the application
- Return appropriate error messages for invalid input
- Handle different types of validation (email, amount, etc.)

## Structure

- `email_validator.dart` - Email address validation
- `amount_validator.dart` - Monetary amount validation
- `password_validator.dart` - Password validation
- `name_validator.dart` - Name validation
- `date_validator.dart` - Date validation

## Implementation

Validation functions:
- Are pure functions with no side effects
- Return null for valid input or error messages for invalid input
- Handle edge cases and special conditions
- Are reusable across different parts of the application

## Example

```dart
class EmailValidator {
  static String? validate(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
}

class AmountValidator {
  static String? validate(String? amount, {double? min, double? max}) {
    if (amount == null || amount.isEmpty) {
      return 'Amount is required';
    }
    
    final amountDouble = double.tryParse(amount);
    
    if (amountDouble == null) {
      return 'Please enter a valid number';
    }
    
    if (amountDouble <= 0) {
      return 'Amount must be greater than zero';
    }
    
    if (min != null && amountDouble < min) {
      return 'Amount must be at least $min';
    }
    
    if (max != null && amountDouble > max) {
      return 'Amount must be no more than $max';
    }
    
    return null;
  }
}
```