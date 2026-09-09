import 'package:dompet_app/core/widgets/dompet_dialog.dart';
import 'package:flutter/material.dart';

/// FIX-12 (IMP-8): penanda anggaran yang kategorinya sudah diarsipkan.
/// Anggaran tetap aktif dan terhitung; badge hanya komunikasi.
/// Ikon (i) membuka modal info bertone kalem.
class ArchivedCategoryBadge extends StatelessWidget {
  final String categoryName;
  const ArchivedCategoryBadge({super.key, required this.categoryName});

  static Future<void> showInfo(BuildContext context, String categoryName) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return DompetDialog(
          title: 'Kategori $categoryName diarsipkan',
          subtitle:
              'Kategori ini sudah diarsipkan, jadi anggaran ini tidak bisa '
              'dilacak lagi dari transaksi baru. Riwayat dan anggarannya '
              'tetap tersimpan di sini.',
          confirmationText: 'Mengerti',
          onConfirm: () => Navigator.pop(dialogContext),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          Text(
            'Kategori diarsipkan',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          InkWell(
            onTap: () => showInfo(context, categoryName),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
