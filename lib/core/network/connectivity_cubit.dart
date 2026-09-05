import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Global connectivity state: `true` = online, `false` = offline.
///
/// Wraps `connectivity_plus` so Settings + Setup can react to network
/// changes via `BlocBuilder`. Initial state is `true` (assume online until
/// proven offline) to avoid disabling backup on startup flash.
class ConnectivityCubit extends Cubit<bool> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityCubit({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity(),
      super(true);

  /// `true` if any result is not [ConnectivityResult.none].
  /// An empty list is treated as offline.
  static bool isOnlineFromResults(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Performs initial check then listens to connectivity changes.
  /// Safe to call once; subsequent calls are ignored while subscribed.
  Future<void> init() async {
    if (_subscription != null) return;

    try {
      final results = await _connectivity.checkConnectivity();
      if (!isClosed) emit(isOnlineFromResults(results));
    } catch (e) {
      debugPrint('[ConnectivityCubit] checkConnectivity failed: $e');
      // Keep previous state (default online) on failure.
    }

    try {
      _subscription = _connectivity.onConnectivityChanged.listen(
        (results) {
          if (!isClosed) emit(isOnlineFromResults(results));
        },
        onError: (Object e) {
          debugPrint('[ConnectivityCubit] stream error: $e');
        },
      );
    } catch (e) {
      debugPrint('[ConnectivityCubit] listen failed: $e');
    }
  }

  /// Re-checks connectivity on demand (e.g. pull-to-refresh).
  Future<void> refresh() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (!isClosed) emit(isOnlineFromResults(results));
    } catch (e) {
      debugPrint('[ConnectivityCubit] refresh failed: $e');
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
