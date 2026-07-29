import 'package:dompet_app/core/utils/open_add_activity_bottom_sheet.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:flutter/material.dart';

class DompetFab extends StatelessWidget {
  final Account? selectedAccount;
  const DompetFab({super.key, this.selectedAccount});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return FloatingActionButton(
      onPressed: () async {
        await openAddActivityBottomSheet(
          context,
          selectedAccount: selectedAccount,
        );
      },
      backgroundColor: themeData.colorScheme.primary,
      foregroundColor: themeData.scaffoldBackgroundColor,
      elevation: 0,
      shape: const CircleBorder(),
      child: Icon(Icons.add_rounded),
    );
  }
}
