import 'package:flutter/material.dart';

class RefreshWrapper extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final double displacement;
  final String? loadingIndicatorTitle;

  const RefreshWrapper({
    super.key,
    required this.onRefresh,
    required this.child,
    this.displacement = 40.0,
    this.loadingIndicatorTitle,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      displacement: displacement,
      child: child,
    );
  }
}