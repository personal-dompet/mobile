import 'package:flutter/material.dart';

/// @Deprecated
/// This page has been replaced by PocketTypeSelectorBottomSheet
/// which is now used as a bottom sheet for pocket type selection.
class SelectPocketTypePage extends StatelessWidget {
  const SelectPocketTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('This page has been deprecated. Use PocketTypeSelectorBottomSheet instead.'),
      ),
    );
  }
}
