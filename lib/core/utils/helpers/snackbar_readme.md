# Snackbar System

This directory contains an implementation of a global snackbar system for the Dompet app using Flutter's built-in ScaffoldMessenger.

## ScaffoldMessenger Extension (`scaffold_snackbar_helper.dart`)

This implementation extends Flutter's built-in ScaffoldMessenger with styled snackbars that match the app's theme.

### Features:
- Uses Flutter's native snackbar system
- Styled to match the app's theme
- Four types of snackbars with appropriate icons
- Easy to use extension methods

### Usage:
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

### Implementation Details:
The system uses extension methods on BuildContext to provide a clean API for showing snackbars. It leverages Flutter's native ScaffoldMessenger, which provides:
1. Automatic handling of multiple snackbars with a built-in queue system
2. Better performance as it doesn't require additional state management
3. Consistent behavior with the rest of the Flutter framework
4. Built-in accessibility features