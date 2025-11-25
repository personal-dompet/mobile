enum ErrorKey {
  required,
  minLength,
  maxLength,
  number,
  exceedsBalance,
  exceedsPocketBalance,
  exceedsAccountBalance,
  min,
  notEqual;

  String message({
    int? min,
    int? max,
    int? minLength,
    int? maxLength,
  }) {
    return ErrorMessageHelper.getMessage(
      this,
      min: min,
      max: max,
      minLength: minLength,
      maxLength: maxLength,
    );
  }
}

class ErrorMessageHelper {
  static String getMessage(
    ErrorKey errorKey, {
    int? min,
    int? max,
    int? minLength,
    int? maxLength,
  }) {
    switch (errorKey) {
      case ErrorKey.required:
        return 'This field is required';
      case ErrorKey.minLength:
        return 'Must be at least $minLength characters';
      case ErrorKey.maxLength:
        return 'Must be at most $maxLength characters';
      case ErrorKey.number:
        return 'Must be a valid number';
      case ErrorKey.exceedsBalance:
        return 'Amount exceeds balance';
      case ErrorKey.exceedsPocketBalance:
        return 'Amount exceeds pocket balance';
      case ErrorKey.exceedsAccountBalance:
        return 'Amount exceeds account balance';
      case ErrorKey.min:
        return 'Must be at least $min';
      case ErrorKey.notEqual:
        return 'Values must be different';
      default:
        return 'Invalid input';
    }
  }
}
