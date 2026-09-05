import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:flutter/material.dart';

/// Baris "Ditabung (neto)": alokasi ke pocket − penarikan kembali.
///
/// BUKAN pengeluaran — uangnya masih milik pengguna, hanya terkunci di
/// pocket non-likuid (keluar dari Total Uang Beranda). Kartu ini menjelaskan
/// selisih antara net laporan dan perubahan uang aktif.
///
/// Disembunyikan (SizedBox.shrink) bila tidak ada aktivitas tabungan
/// pada periode ini agar UI tetap minimal.
class SavingAllocationCard extends StatelessWidget {
  const SavingAllocationCard({super.key, required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    if (!summary.hasSavingActivity) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final parts = [
      'Masuk pocket ${summary.savingTopup.compactCurrency}',
      'Kembali cair ${summary.savingWithdraw.compactCurrency}',
      if (summary.savingSpend > 0)
        'Belanja dari pocket ${summary.savingSpend.compactCurrency}',
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Row(
              spacing: 8,
              children: [
                Icon(
                  Icons.savings_rounded,
                  color: theme.colorScheme.primary,
                ),
                Text(
                  'Ditabung (neto)',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Tooltip(
                  message: summary.netSaving.currency,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Text(
                    summary.netSaving.compactCurrency,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              parts.join(' • '),
              style: theme.textTheme.bodySmall,
            ),
            Text(
              'Perubahan uang aktif ≈ ${summary.liquidChange.compactCurrency}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
