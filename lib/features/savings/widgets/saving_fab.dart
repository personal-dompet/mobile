import 'package:dompet_app/core/router/router.gr.dart';
import 'package:flutter/material.dart';

class SavingFab extends StatelessWidget {
  const SavingFab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return FloatingActionButton(
      onPressed: () => SavingFormRoute().push(context),
      backgroundColor: themeData.colorScheme.primary,
      foregroundColor: themeData.scaffoldBackgroundColor,
      elevation: 0,
      shape: const CircleBorder(),
      child: const Icon(Icons.add_rounded),
    );
  }
}
