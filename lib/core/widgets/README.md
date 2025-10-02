# Core Widgets

This directory contains reusable Flutter widgets for the Dompet application.

## Available Widgets

### Reactive Date Picker
A reusable reactive date picker widget based on `ReactiveDatePicker` from the `reactive_forms` package. It displays dates in `DD MMMM yyyy` format and allows users to select dates through the material date picker.

#### Usage
```dart
import 'package:dompet/core/widgets/date_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

// In your form class
late FormControl<DateTime?> dateControl;

// Initialize the control
dateControl = FormControl<DateTime?>(value: DateTime.now());

// In your widget
ReactiveDatePicker(
  formControl: dateControl,
  labelText: 'Date',
  hintText: 'Select date',
)
```

### Refresh Wrapper Widget
A reusable pull-to-refresh wrapper for Flutter applications that can be used with any scrollable widget.

#### Usage

```dart
import 'package:dompet/widgets/refresh_wrapper.dart';

// Wrap any scrollable widget with RefreshWrapper
RefreshWrapper(
  onRefresh: () => ref.read(yourProvider.notifier).refresh(),
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return YourListItem(item: items[index]);
    },
  ),
)
```

#### Parameters

- `onRefresh`: A function that returns a Future<void> which will be called when the user pulls to refresh
- `child`: The scrollable widget to wrap (ListView, GridView, CustomScrollView, etc.)
- `displacement`: The distance from the top of the scrollable widget to the refresh indicator (default: 40.0)
- `loadingIndicatorTitle`: Optional title to display while refreshing

#### Implementation Details

The RefreshWrapper uses Flutter's built-in RefreshIndicator widget, which provides the standard Material Design pull-to-refresh pattern.

#### Adding Refresh to Providers

To use the RefreshWrapper effectively, your providers should implement a refresh method:

```dart
class YourProvider extends AsyncNotifier<YourDataType> {
  @override
  Future<YourDataType> build() async {
    // Initial data loading
    return await loadData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final result = await loadData();
      state = AsyncData(result);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
```