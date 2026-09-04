import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/empty_message.dart';
import 'package:flutter/material.dart';

class EmptySavings extends StatelessWidget {
  final bool center;
  final String emptyText;
  const EmptySavings({
    super.key,
    this.center = false,
    this.emptyText = 'Mulai dengan membuat target pertamamu.',
  });

  @override
  Widget build(BuildContext context) {
    return EmptyMessage(
      text: emptyText,
      title: 'Belum ada target.',
      onAction: () => SavingFormRoute().push(context),
      actionText: 'Buat Target',
      center: center,
    );
  }
}
