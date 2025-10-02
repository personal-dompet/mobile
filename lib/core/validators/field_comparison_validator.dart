import 'package:reactive_forms/reactive_forms.dart';

/// An enum representing different comparison operations
enum ComparisonOperation {
  equal,
  notEqual,
  greaterThan,
  greaterThanOrEqual,
  lessThan,
  lessThanOrEqual,
}

/// A validator that compares two fields in a form group based on a specific operation.
/// 
/// This validator allows for flexible comparisons between two form fields.
class FieldComparisonValidator extends Validator<dynamic> {
  final String controlName;
  final String comparisonControlName;
  final ComparisonOperation operation;
  final String? errorKey;

  /// Creates a new [FieldComparisonValidator] instance.
  /// 
  /// [controlName] is the name of the control to compare.
  /// [comparisonControlName] is the name of the control to compare against.
  /// [operation] is the type of comparison to perform.
  /// [errorKey] is an optional custom error key to use (defaults to the operation name).
  FieldComparisonValidator(
    this.controlName,
    this.comparisonControlName,
    this.operation, {
    this.errorKey,
  }) : super();

  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    // Only proceed if the control is a FormGroup
    if (control is! FormGroup) {
      return null;
    }

    final form = control;
    final controlToValidate = form.control(controlName);
    final comparisonControl = form.control(comparisonControlName);

    // Skip validation if either control is null or doesn't have a value
    if (controlToValidate.value == null || comparisonControl.value == null) {
      return null;
    }

    bool isValid = _performComparison(controlToValidate.value, comparisonControl.value);

    // If validation fails, return an error map
    if (!isValid) {
      final errorKeyToUse = errorKey ?? _getOperationErrorKey(operation);
      return {errorKeyToUse: true};
    }

    // Return null if validation passes
    return null;
  }

  /// Performs the actual comparison based on the operation
  bool _performComparison(dynamic value1, dynamic value2) {
    switch (operation) {
      case ComparisonOperation.equal:
        return value1 == value2;
      case ComparisonOperation.notEqual:
        return value1 != value2;
      case ComparisonOperation.greaterThan:
        if (value1 is num && value2 is num) {
          return value1 > value2;
        }
        // For other types, use compareTo if available
        if (value1 is Comparable && value2 is Comparable) {
          return value1.compareTo(value2) > 0;
        }
        return false;
      case ComparisonOperation.greaterThanOrEqual:
        if (value1 is num && value2 is num) {
          return value1 >= value2;
        }
        if (value1 is Comparable && value2 is Comparable) {
          return value1.compareTo(value2) >= 0;
        }
        return false;
      case ComparisonOperation.lessThan:
        if (value1 is num && value2 is num) {
          return value1 < value2;
        }
        if (value1 is Comparable && value2 is Comparable) {
          return value1.compareTo(value2) < 0;
        }
        return false;
      case ComparisonOperation.lessThanOrEqual:
        if (value1 is num && value2 is num) {
          return value1 <= value2;
        }
        if (value1 is Comparable && value2 is Comparable) {
          return value1.compareTo(value2) <= 0;
        }
        return false;
    }
  }

  /// Gets the default error key for an operation
  String _getOperationErrorKey(ComparisonOperation operation) {
    switch (operation) {
      case ComparisonOperation.equal:
        return 'equal';
      case ComparisonOperation.notEqual:
        return 'notEqual';
      case ComparisonOperation.greaterThan:
        return 'greaterThan';
      case ComparisonOperation.greaterThanOrEqual:
        return 'greaterThanOrEqual';
      case ComparisonOperation.lessThan:
        return 'lessThan';
      case ComparisonOperation.lessThanOrEqual:
        return 'lessThanOrEqual';
    }
  }
}

