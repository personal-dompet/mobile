import 'package:flutter/material.dart';

enum ActivityType {
  all('Semua', Icons.more_rounded),
  income('Pemasukan', Icons.trending_up_rounded),
  expense('Pengeluaran', Icons.trending_down_rounded),
  transfer('Pindah dana', Icons.swap_horiz_rounded),
  billPayment('Tagihan', Icons.electric_bolt_rounded),
  adjustment('Penyesuaian saldo', Icons.adjust_rounded);

  final String label;
  final IconData icon;

  const ActivityType(this.label, this.icon);
}
