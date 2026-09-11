import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';

/// Agregat satu halaman detail tagihan: bill + plan + kategori +
/// riwayat jurnal (bill_generated / bill_payment).
class BillDetail {
  const BillDetail({
    required this.bill,
    required this.plan,
    required this.category,
    this.journals = const [],
  });

  final Bill bill;
  final BillPlan plan;
  final Account category;
  final List<JournalEntry> journals;

  /// Tanggal pelunasan (jurnal pembayaran terakhir), bila sudah lunas.
  DateTime? get paidAt {
    final payments = journals.where((j) => j.source == .billPayment);
    if (payments.isEmpty) return null;
    final latest = payments.reduce(
      (a, b) => a.entryDate >= b.entryDate ? a : b,
    );
    return DateTime.fromMillisecondsSinceEpoch(latest.entryDate * 1000);
  }
}
