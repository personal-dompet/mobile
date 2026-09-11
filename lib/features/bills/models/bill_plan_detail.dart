import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';

/// Agregat satu halaman detail tagihan rutin: plan + kategori +
/// 5 tagihan terbaru + total (untuk aturan tombol Lihat Semua).
class BillPlanDetail {
  const BillPlanDetail({
    required this.plan,
    required this.category,
    this.recentBills = const [],
    this.totalCount = 0,
    this.linkedTarget,
  });

  final BillPlan plan;
  final Account category;
  final List<Bill> recentBills;
  final int totalCount;

  /// Target sisihan kemunculan terdekat (null bila tak ada / bukan yearly).
  final SavingPlan? linkedTarget;

  /// Nominal target tak lagi sama dengan nominal tagihan terkini.
  bool get isTargetAmountStale =>
      linkedTarget != null &&
      linkedTarget!.targetAmount != null &&
      linkedTarget!.targetAmount != plan.amount;

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
