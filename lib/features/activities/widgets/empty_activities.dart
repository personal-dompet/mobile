import 'package:dompet_app/core/utils/open_add_activity_bottom_sheet.dart';
import 'package:dompet_app/core/widgets/empty_message.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:flutter/material.dart';

class EmptyActivities extends StatelessWidget {
  final bool center;
  final String emptyText;
  final Account? selectedAccount;
  const EmptyActivities({
    super.key,
    this.selectedAccount,
    this.center = false,
    this.emptyText =
        'Mulai dengan mencatat pemasukan atau pengeluaran pertamamu.',
  });

  @override
  Widget build(BuildContext context) {
    return EmptyMessage(
      text: emptyText,
      title: 'Belum ada aktivitas.',
      onAction: () async {
        await openAddActivityBottomSheet(
          context,
          selectedAccount: selectedAccount,
        );
      },
      actionText: 'Catat Sekarang',
      center: center,
    );
  }
}
