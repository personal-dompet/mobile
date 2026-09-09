import 'package:dompet_app/core/widgets/empty_message.dart';
import 'package:flutter/material.dart';

/// FIX-13 (ISSUE 4 + 12): empty state seragam untuk hasil pencarian kosong.
///
/// Dipakai di Dompet, Anggaran, Target, Kategori, dan Pilih Kategori dengan
/// [subject] berbeda (`'dompet'`, `'anggaran'`, `'target'`, `'kategori'`).
/// Berbeda dari empty state "belum ada data" (mis. [EmptyBudgets]) yang
/// mengajak membuat data baru — widget ini khusus kondisi pencarian tanpa
/// hasil dan menawarkan reset keyword.
class DompetEmptySearch extends StatelessWidget {
  final String subject;
  final VoidCallback? onReset;
  final bool center;
  const DompetEmptySearch({
    super.key,
    required this.subject,
    this.onReset,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyMessage(
      center: center,
      title: 'Tidak ada $subject cocok.',
      text: 'Coba kata kunci lain.',
      actionText: 'Reset pencarian',
      onAction: onReset,
    );
  }
}
