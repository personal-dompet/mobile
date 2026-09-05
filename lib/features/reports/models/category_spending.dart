/// Pengeluaran satu kategori pada satu periode.
///
/// Diagregasi di SQL: SUM(debit) pada akun EXPENSE per akun,
/// `source` transaction + saving (belanja dari pocket ikut kategori terkait).
/// [percentage] dihitung di Dart terhadap total expense periode (0–100).
/// Bernilai 0 bila total expense nol.
class CategorySpending {
  const CategorySpending({
    required this.accountId,
    required this.name,
    required this.amount,
    required this.percentage,
  });

  final int accountId;
  final String name;
  final int amount;
  final double percentage;

  /// Gabungkan sisa kategori di luar N teratas menjadi satu baris "Lainnya".
  static List<CategorySpending> topWithOthers(List<CategorySpending> all, [int top = 6]) {
    if (all.length <= top) return all;
    final head = all.sublist(0, top);
    final rest = all.sublist(top);
    final restAmount = rest.fold<int>(0, (sum, e) => sum + e.amount);
    final restPercentage = rest.fold<double>(0, (sum, e) => sum + e.percentage);
    return [
      ...head,
      CategorySpending(
        accountId: -1,
        name: 'Lainnya',
        amount: restAmount,
        percentage: restPercentage,
      ),
    ];
  }
}
