import 'package:dompet_app/features/reports/models/report_period.dart';

/// Ringkasan keuangan satu periode bulanan.
///
/// Diagregasi di SQL dari jurnal double-entry:
/// - pemasukan = SUM(credit) pada akun bertipe INCOME
///   (jurnal tabungan tidak pernah menyentuh akun INCOME)
/// - pengeluaran = SUM(debit) pada akun bertipe EXPENSE
///   (`source` transaction + saving, sehingga belanja langsung
///   dari pocket tabungan ikut terhitung)
/// - ditabung neto = topup − withdraw pocket pada periode ini
///   (baris terpisah: alokasi tabungan BUKAN pengeluaran,
///   tapi menjelaskan selisih vs perubahan Total Uang)
///
/// Jurnal transfer / penyesuaian / saldo awal tidak bocor ke angka mana pun.
class MonthlySummary {
  const MonthlySummary({
    required this.period,
    this.income = 0,
    this.expense = 0,
    this.transactionCount = 0,
    this.savingTopup = 0,
    this.savingWithdraw = 0,
    this.savingSpend = 0,
  });

  final ReportPeriod period;
  final int income;
  final int expense;
  final int transactionCount;

  /// Total alokasi ke pocket tabungan pada periode ini.
  final int savingTopup;

  /// Total penarikan dari pocket kembali ke dompet cair.
  /// BUKAN pemasukan.
  final int savingWithdraw;

  /// Total belanja langsung dari pocket. Sudah termasuk di [expense].
  final int savingSpend;

  int get net => income - expense;

  /// Delta saldo pocket = topup − withdraw − spend.
  /// Dengan definisi ini rekonsiliasi ke uang aktif bersifat exact
  /// terhadap arus yang dimodelkan: liquidChange = net − netSaving.
  int get netSaving => savingTopup - savingWithdraw - savingSpend;

  /// Rekonsiliasi ke Beranda: perubahan uang aktif ≈ net − netSaving.
  /// Tanda ≈ karena transfer/penyesuaian/tagihan juga menggerakkan
  /// saldo likuid di luar metrik ini.
  int get liquidChange => net - netSaving;

  bool get hasSavingActivity =>
      savingTopup > 0 || savingWithdraw > 0 || savingSpend > 0;

  bool get isEmpty =>
      income == 0 &&
      expense == 0 &&
      transactionCount == 0 &&
      savingTopup == 0 &&
      savingWithdraw == 0 &&
      savingSpend == 0;

  factory MonthlySummary.fromJson(
    Map<String, dynamic> json,
    ReportPeriod period,
  ) {
    int asInt(Object? value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return 0;
    }

    return MonthlySummary(
      period: period,
      income: asInt(json['income']),
      expense: asInt(json['expense']),
      transactionCount: asInt(json['transaction_count']),
      savingTopup: asInt(json['saving_topup']),
      savingWithdraw: asInt(json['saving_withdraw']),
      savingSpend: asInt(json['saving_spend']),
    );
  }

  MonthlySummary copyWith({
    ReportPeriod? period,
    int? income,
    int? expense,
    int? transactionCount,
    int? savingTopup,
    int? savingWithdraw,
    int? savingSpend,
  }) {
    return MonthlySummary(
      period: period ?? this.period,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      transactionCount: transactionCount ?? this.transactionCount,
      savingTopup: savingTopup ?? this.savingTopup,
      savingWithdraw: savingWithdraw ?? this.savingWithdraw,
      savingSpend: savingSpend ?? this.savingSpend,
    );
  }
}
