import 'dart:convert';

import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/activities/extensions/activity.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';
import 'package:flutter/material.dart';

class ActivityItemTile extends StatelessWidget {
  final JournalEntry activity;
  final bool hideDate;
  final int? accountId;

  /// FIX-10 (ISSUE 13): teks kecil di dalam card, di bawah nominal dan
  /// sejajar keterangan waktu (mis. "Terkumpul RpX" di riwayat target).
  final String? footerTrailing;
  const ActivityItemTile({
    super.key,
    required this.activity,
    this.accountId,
    this.hideDate = false,
    this.footerTrailing,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    Color color = themeData.colorScheme.onSurface;

    final savingColor = _savingGlobalColor(themeData);
    if (savingColor != null) {
      color = savingColor;
    } else {
      if (activity.displayAmount(accountId: accountId).startsWith('+')) {
        color = themeData.colorScheme.tertiary;
      }

      if (activity.displayAmount(accountId: accountId).startsWith('-')) {
        color = themeData.colorScheme.error;
      }
    }

    return Card(
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: () {
          ActivityDetailRoute(id: activity.id).push(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Row(
                spacing: 4,
                children: [
                  Expanded(
                    child: Text(
                      activity.title(accountId: accountId),
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        fontWeight: .w600,
                      ),
                      overflow: .ellipsis,
                    ),
                  ),
                  Text(
                    activity.displayAmount(accountId: accountId),
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
              if (footerTrailing != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.activityData(
                          hideDate: hideDate,
                          accountId: accountId,
                        ),
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.colorScheme.onSurface.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        overflow: .ellipsis,
                      ),
                    ),
                    Text(
                      footerTrailing!,
                      style: themeData.textTheme.labelSmall?.copyWith(
                        color: themeData.colorScheme.onSurface.withValues(
                          alpha: 0.55,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  activity.activityData(
                    hideDate: hideDate,
                    accountId: accountId,
                  ),
                  style: themeData.textTheme.bodySmall?.copyWith(
                    color: themeData.colorScheme.onSurface.withValues(
                      alpha: 0.8,
                    ),
                  ),
                  overflow: .ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Warna khusus alokasi/tarik Target, hanya untuk list global
  /// ([accountId] == null). Detail per-akun (riwayat Target/Aset/Budget)
  /// tetap hijau/merah agar sesuai konteks +/-. Transfer murni dan
  /// tipe lain return null (netral, tak diubah).
  Color? _savingGlobalColor(ThemeData themeData) {
    if (accountId != null) return null;
    if (activity.source != JournalSource.saving) return null;

    final meta = activity.metadata;
    if (meta == null || meta.isEmpty) return null;
    SavingTxType? tx;
    try {
      final json = jsonDecode(meta);
      if (json is! Map) return null;
      tx = SavingTxType.values
          .where((e) => e.value == json['saving_tx'])
          .firstOrNull;
    } catch (_) {
      return null;
    }

    final isDark = themeData.brightness == Brightness.dark;
    // Kaki-tarik belanja (J1 SPEND aset-aset) ikut oranye withdraw.
    // Legacy SPEND langsung pocket->expense (ada line expense) tetap merah
    // via fallback agar tak salah warna.
    final hasExpense = activity.lines.any((line) => line.accountType == .expense);
    return switch (tx) {
      // Alokasi: ungu muted, selevel red.shade400/300 + green.shade300.
      SavingTxType.topup =>
        isDark ? Colors.deepPurple.shade200 : Colors.deepPurple.shade400,
      // Tarik: oranye kecoklatan (distinct dari biru/hijau/merah).
      // Light pakai shade800 agar kontras di putih (shade400 terlalu terang).
      SavingTxType.withdraw =>
        isDark ? Colors.orange.shade300 : Colors.orange.shade800,
      SavingTxType.spend => hasExpense
          ? null
          : (isDark ? Colors.orange.shade300 : Colors.orange.shade800),
      _ => null,
    };
  }
}
