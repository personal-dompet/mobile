# Utils Helpers Directory

This directory contains general helper functions and utilities used throughout the application.

## Purpose

Helper functions in this directory:
- Provide common utility functions
- Handle repetitive tasks
- Simplify complex operations
- Improve code readability and maintainability

## Structure

- `error_handler.dart` - Error handling utilities
- `logger.dart` - Logging utilities
- `connectivity_helper.dart` - Network connectivity utilities
- `permission_helper.dart` - Permission handling utilities
- `navigation_helper.dart` - Navigation utilities
- `scaffold_snackbar_helper.dart` - Snackbar utilities using ScaffoldMessenger

## Implementation

Helper functions:
- Are pure functions or stateless utilities
- Handle specific tasks efficiently
- Provide clear and descriptive names
- Include appropriate error handling

## Snackbar Helper

The `scaffold_snackbar_helper.dart` file provides extension methods on `BuildContext` to easily show different types of snackbars:

```dart
// Show a success message
context.showSuccessSnackbar('Operation completed successfully!');

// Show an error message
context.showErrorSnackbar('Something went wrong', duration: Duration(seconds: 5));

// Show an info message
context.showInfoSnackbar('This is an informational message');

// Show a warning message
context.showWarningSnackbar('This is a warning message');

// Clear all snackbars
context.clearSnackbars();
```

## Example

```dart
class ErrorHandler {
  static void handleApiError(dynamic error, VoidCallback onRetry) {
    if (error is DioError) {
      switch (error.response?.statusCode) {
        case 400:
          showErrorMessage('Bad Request: Please check your input');
          break;
        case 401:
          showErrorMessage('Unauthorized: Please log in again');
          // Navigate to login screen
          break;
        case 404:
          showErrorMessage('Not Found: The requested resource was not found');
          break;
        case 500:
          showErrorMessage('Server Error: Please try again later');
          break;
        default:
          showErrorMessage('Network Error: ${error.message}');
      }
    } else {
      showErrorMessage('Unknown Error: $error');
    }
  }
  
  static void showErrorMessage(String message) {
    // Implementation for showing error messages to user
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

class Logger {
  static void debug(String message) {
    if (kDebugMode) {
      print('DEBUG: $message');
    }
  }
  
  static void info(String message) {
    print('INFO: $message');
  }
  
  static void error(String message, [dynamic error]) {
    print('ERROR: $message');
    if (error != null) {
      print('ERROR DETAILS: $error');
    }
  }
}
```