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

  @override
  void initState() {
    super.initState();

    historyObserver.historyChangeStream.listen(
      (change) => setState(() {
        debugPrint(historyObserver.history.toString());
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
