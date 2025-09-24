import 'dart:async';

import 'package:flutter/foundation.dart';

/// A helper class for implementing debounce functionality
class Debounce {
  Timer? _timer;

  static final _duration = const Duration(milliseconds: 500);

  void debounce(VoidCallback function) {
    // Cancel the previous timer if it exists
    _timer?.cancel();

    // Start a new timer
    _timer = Timer(_duration, function);
  }

  /// Cancels any pending debounce timer
  void cancel() {
    _timer?.cancel();
  }
}
