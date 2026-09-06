import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

class RouterHistoryWrapper extends StatefulWidget {
  final Widget child;
  const RouterHistoryWrapper({super.key, required this.child});

  @override
  State<RouterHistoryWrapper> createState() => _RouterHistoryWrapperState();
}

class _RouterHistoryWrapperState extends State<RouterHistoryWrapper> {
  final NavigationHistoryObserver historyObserver = NavigationHistoryObserver();
  StreamSubscription? _historySub;

  @override
  void initState() {
    super.initState();

    _historySub = historyObserver.historyChangeStream.listen(
      (change) {
        if (!mounted) return;
        setState(() {
          debugPrint(historyObserver.history.toString());
        });
      },
    );
  }

  @override
  void dispose() {
    _historySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
