import 'package:dompet_app/core/widgets/widget.dart';
import 'package:flutter/material.dart';

class QuickActionSection extends StatelessWidget {
  const QuickActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        Text(
          'Mulai Catat',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: .w700),
        ),
        QuickAction(context),
      ],
    );
  }
}
