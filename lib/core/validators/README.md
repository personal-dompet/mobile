# Validators Directory

This directory contains custom validation functions and classes for use with reactive forms in the application.

## Purpose

The validators in this directory:

- Provide custom validation logic beyond what's available in the reactive_forms package
- Are reusable across different forms in the application
- Implement validation rules specific to the application's business logic

## Structure

- `not_equal_validator.dart` - Validator to ensure two fields have different values
- `field_comparison_validator.dart` - General validator for comparing two fields with various operations
- `amount_pocket_balance_validator.dart` - Validator to compare an amount with a pocket's balance

## Implementation

Custom validators:

- Implement the Validator interface from reactive_forms
- Are stateless and can be reused across different forms
- Provide clear error messages to users

## Example

```dart
// Using the NotEqualValidator to ensure from and to pockets are different in a transfer
final transferForm = FormGroup({
  'fromPocket': FormControl<SimplePocketModel>(validators: [Validators.required]),
  'toPocket': FormControl<SimplePocketModel>(validators: [Validators.required]),
  'amount': FormControl<int>(validators: [Validators.required, Validators.min(1)]),
}, validators: [
  NotEqualValidator('fromPocket', 'toPocket'),
]);

// Or using the extension method:
transferForm.addNotEqualValidator('fromPocket', 'toPocket');

// Using the FieldComparisonValidator for other types of comparisons
final form = FormGroup({
  'startDate': FormControl<DateTime>(validators: [Validators.required]),
  'endDate': FormControl<DateTime>(validators: [Validators.required]),
}, validators: [
  FieldComparisonValidator('endDate', 'startDate', ComparisonOperation.greaterThan),
]);

// Or using the extension method:
form.addFieldComparisonValidator('endDate', 'startDate', ComparisonOperation.greaterThan);

// Using the AmountPocketBalanceValidator to ensure amount doesn't exceed pocket balance
final transferForm = FormGroup({
  'fromPocket': FormControl<SimplePocketModel>(validators: [Validators.required]),
  'amount': FormControl<int>(validators: [Validators.required, Validators.min(1)]),
}, validators: [
  AmountPocketBalanceValidator()
]);
```
