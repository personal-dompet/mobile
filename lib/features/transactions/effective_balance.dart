import 'package:dompet_app/features/transactions/enums/transaction_type.dart';

/// Menghitung Effective Balance untuk validasi edit transaksi (DOCUMENT.md):
/// saldo setelah efek transaksi lama dibalik terlebih dahulu.
///
/// - Bukan mode edit ([previousAmount] null): efektif = saldo saat ini.
/// - Dompet yang dipilih berbeda dari dompet transaksi lama
///   ([previousAssetId] != [currentAssetId]): efek transaksi lama tidak
///   memengaruhi dompet tersebut, sehingga efektif = saldo saat ini.
/// - Edit pada dompet yang sama: efek transaksi lama dibalik dulu, yaitu
///   pengeluaran lama ditambahkan kembali / pemasukan lama dikurangi.
int computeEffectiveBalance({
  required int currentBalance,
  required TransactionType type,
  int? previousAmount,
  int? previousAssetId,
  int? currentAssetId,
}) {
  final isEdit = previousAmount != null && previousAssetId != null;

  if (!isEdit ||
      currentAssetId == null ||
      previousAssetId != currentAssetId) {
    return currentBalance;
  }

  return type == .expense
      ? currentBalance + previousAmount
      : currentBalance - previousAmount;
}
