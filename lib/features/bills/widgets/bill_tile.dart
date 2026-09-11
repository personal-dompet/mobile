import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:flutter/material.dart';

/// Tile satu tagihan: nominal + periode + rentang tanggal + badge status.
/// Dipakai di detail plan (terbaru), list penuh per plan, dan daftar bayar.
class BillTile extends StatelessWidget {
  final Bill bill;
  final VoidCallback? onTap;
  const BillTile({super.key, required this.bill, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = switch (bill.statusValue) {
      BillStatus.drafted => ('Terjadwal', theme.colorScheme.onSurface),
      BillStatus.unpaid => bill.isDueReminderAt(DateTime.now())
          ? ('Segera dibayar', theme.colorScheme.primary)
          : ('Belum dibayar', theme.colorScheme.primary),
      BillStatus.paid => ('Lunas', theme.colorScheme.tertiary),
      BillStatus.overdue => ('Terlambat', theme.colorScheme.error),
    };
    final billed = DateTime.fromMillisecondsSinceEpoch(bill.billedAt * 1000);
    final due = DateTime.fromMillisecondsSinceEpoch(bill.dueDate * 1000);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      bill.amount.currency,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${billed.format()} → ${due.format()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
