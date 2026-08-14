import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:flutter/material.dart';

Future<void> openAddActivityBottomSheet(
  BuildContext context, {
  Account? selectedAccount,
}) async {
  await showModalBottomSheet(
    context: context,
    builder: (modalContext) {
      return BottomSheet(
        onClosing: () {},
        builder: (modalContext) {
          final themeData = Theme.of(modalContext);
          return Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 24),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              spacing: 16,
              children: [
                Text(
                  'Apa yang ingin kamu catat?',
                  style: themeData.textTheme.titleMedium,
                ),
                QuickAction(
                  context,
                  selectedAccount: selectedAccount,
                  backgroundColor:
                      themeData.colorScheme.surfaceContainerHighest,
                  onBeforeAction: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
