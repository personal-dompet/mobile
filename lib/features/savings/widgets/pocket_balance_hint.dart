import 'package:dompet_app/core/extensions/number.dart';
import 'package:flutter/material.dart';

/// FIX-10 (IMP-6, Q18): info santai tak mencolok soal saldo target kini.
/// Dipakai di form Tarik + Belanja: `Terkumpul RpX • maksimal RpX`.
class PocketBalanceHint extends StatelessWidget {
  final int balance;
  const PocketBalanceHint({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: .min,
      spacing: 4,
      children: [
        Icon(
          Icons.savings_outlined,
          size: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        Flexible(
          child: Text(
            'Terkumpul ${balance.currency} • maksimal ${balance.currency}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
      ],
    );
  }
}
