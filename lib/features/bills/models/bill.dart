import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill.freezed.dart';
part 'bill.g.dart';

@freezed
abstract class Bill with _$Bill {
  const Bill._();
  const factory Bill({
    @JsonKey(name: BillKey.id) required int id,
    @JsonKey(name: BillKey.billPlanId) required int billPlanId,
    @JsonKey(name: BillKey.amount) required int amount,
    @JsonKey(name: BillKey.billPeriod) required String billPeriod,
    @JsonKey(name: BillKey.billedAt) required int billedAt,
    @JsonKey(name: BillKey.dueDate) required int dueDate,
    @JsonKey(name: BillKey.remindedAt) required int remindedAt,
    @JsonKey(name: BillKey.status) required String status,
    @JsonKey(name: BillKey.isDeleted) @Default(0) int isDeleted,
    @JsonKey(name: BillKey.createdAt) @Default(0) int createdAt,
  }) = _Bill;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  BillStatus get statusValue =>
      BillStatus.values.firstWhere((e) => e.value == status);

  bool get isDrafted => statusValue == BillStatus.drafted;
  bool get isUnpaid => statusValue == BillStatus.unpaid;
  bool get isPaid => statusValue == BillStatus.paid;
  bool get isOverdue => isOverdueAt(DateTime.now());

  /// Bisa dibayar: sudah aktif dan belum lunas (termasuk terlambat —
  /// fitur ini pengingat, bukan penilai).
  bool get canPay => !isPaid && !isDrafted;

  /// Terlambat: belum lunas dan sudah lewat jatuh tempo.
  bool isOverdueAt(DateTime now) {
    if (isPaid || isDrafted) return false;
    final nowSec = now.millisecondsSinceEpoch ~/ 1000;
    return nowSec > dueDate;
  }

  /// Waktunya diingatkan: belum lunas, reminded_at tiba, belum jatuh tempo.
  bool isDueReminderAt(DateTime now) {
    if (!isUnpaid) return false;
    final nowSec = now.millisecondsSinceEpoch ~/ 1000;
    return remindedAt <= nowSec && nowSec < dueDate;
  }
}
