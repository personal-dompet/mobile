import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';

/// Agregat satu halaman detail tagihan rutin: plan + kategori +
/// 5 tagihan terbaru + total (untuk aturan tombol Lihat Semua).
class BillPlanDetail {
  const BillPlanDetail({
    required this.plan,
    required this.category,
    this.recentBills = const [],
    this.totalCount = 0,
  });

  final BillPlan plan;
  final Account category;
  final List<Bill> recentBills;
  final int totalCount;

  bool get hasMore => totalCount > recentBills.length;

  bool get isEnded {
    final endedAt = plan.endedAt;
    if (endedAt == null) return false;
    final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return nowSec > endedAt;
  }

  /// Tagihan aktif terdekat (belum lunas, billed paling awal).
  Bill? get nextActive {
    final actives = recentBills.where((b) => !b.isPaid && !b.isDrafted);
    if (actives.isEmpty) return null;
    return actives.reduce((a, b) => a.billedAt <= b.billedAt ? a : b);
  }
}
