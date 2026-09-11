import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BillPlanRepository {
  final DbService _dbService;

  const BillPlanRepository(this._dbService);

  Future<BillPlan?> getById(int id) async {    final db = await _dbService.database;

    final rows = await db.query(
      billPlanTable,
      where: '${BillPlanKey.id} = ? AND ${BillPlanKey.isDeleted} = 0',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return BillPlan.fromJson(rows.first);
  }

  /// Simpan (buat / ubah) tagihan rutin. Bila [bulkCreate] dan [endedAt] terisi,
  /// generate draft dari kemunculan terdekat s.d. billed terakhir inklusif.
  /// Jurnal `bill_generated` TIDAK ditulis di sini (baru saat aktivasi).
  Future<BillPlan> savePlan({
    int? id,
    required int accountId,
    required String name,
    required int amount,
    required String period,
    required String billedSchedule,
    required String dueDateSchedule,
    required int reminderDays,
    DateTime? endedAt,
    String? reference,
    String? note,
    bool bulkCreate = false,
  }) async {
    if (amount <= 0) {
      throw Exception('Nominal harus lebih dari 0');
    }
    if (name.isEmpty) {
      throw Exception('Nama tagihan belum diisi');
    }
    if (period == BillPlanPeriodEnum.monthly.name &&
        BillSchedule.monthlyDayOrder(billedSchedule) >=
            BillSchedule.monthlyDayOrder(dueDateSchedule)) {
      throw Exception('Jadwal tagih harus sebelum jatuh tempo');
    }

    final db = await _dbService.database;
    final endedAtEpoch = endedAt?.startOfDay.secondsSinceEpoch;

    final planId = await db.transaction((txn) async {
      int currentId;
      if (id == null) {
        currentId = await txn.insert(billPlanTable, {
          BillPlanKey.accountId: accountId,
          BillPlanKey.name: name,
          BillPlanKey.amount: amount,
          BillPlanKey.period: period,
          BillPlanKey.billedSchedule: billedSchedule,
          BillPlanKey.dueDateSchedule: dueDateSchedule,
          BillPlanKey.reminderDays: reminderDays,
          BillPlanKey.endedAt: endedAtEpoch,
          BillPlanKey.reference: reference,
          BillPlanKey.note: note,
          BillPlanKey.isDeleted: 0,
        });
      } else {
        await txn.update(
          billPlanTable,
          {
            BillPlanKey.name: name,
            BillPlanKey.amount: amount,
            BillPlanKey.period: period,
            BillPlanKey.billedSchedule: billedSchedule,
            BillPlanKey.dueDateSchedule: dueDateSchedule,
            BillPlanKey.reminderDays: reminderDays,
            BillPlanKey.endedAt: endedAtEpoch,
            BillPlanKey.reference: reference,
            BillPlanKey.note: note,
          },
          where: '${BillPlanKey.id} = ?',
          whereArgs: [id],
        );
        // Edit: draft lama yang belum aktif dibuang, regenerate bila diminta.
        await txn.delete(
          billTable,
          where:
              '${BillKey.billPlanId} = ? AND ${BillKey.status} = ? AND ${BillKey.isDeleted} = 0',
          whereArgs: [id, BillStatus.drafted.value],
        );
        currentId = id;
      }

      if (bulkCreate && endedAt != null) {
        await _insertDrafts(
          txn,
          planId: currentId,
          amount: amount,
          period: period,
          billedSchedule: billedSchedule,
          dueDateSchedule: dueDateSchedule,
          reminderDays: reminderDays,
          endedAt: endedAt,
        );
      }
      return currentId;
    });

    final plan = await getById(planId);
    if (plan == null) {
      throw Exception('Gagal memuat tagihan rutin yang baru disimpan');
    }
    return plan;
  }

  Future<void> _insertDrafts(
    Transaction txn, {
    required int planId,
    required int amount,
    required String period,
    required String billedSchedule,
    required String dueDateSchedule,
    required int reminderDays,
    required DateTime endedAt,
  }) async {
    final end = endedAt.startOfDay;
    var billed = BillSchedule.nextBilled(DateTime.now(), period, billedSchedule);
    while (!billed.isAfter(end)) {
      final due = BillSchedule.dueDateFor(billed, period, dueDateSchedule);
      final reminded = due.subtract(Duration(days: reminderDays));
      await txn.insert(billTable, {
        BillKey.billPlanId: planId,
        BillKey.amount: amount,
        BillKey.billPeriod: BillSchedule.billPeriodFor(billed, period),
        BillKey.billedAt: billed.startOfDay.secondsSinceEpoch,
        BillKey.dueDate: due.startOfDay.secondsSinceEpoch,
        BillKey.remindedAt: reminded.startOfDay.secondsSinceEpoch,
        BillKey.status: BillStatus.drafted.value,
        BillKey.isDeleted: 0,
      });
      billed = BillSchedule.nextBilledAfter(billed, period, billedSchedule);
    }
  }

  /// Hapus lemas plan + draft-draftnya dalam satu transaksi.
  /// Tagihan yang sudah aktif (unpaid ke atas) tidak disentuh.
  Future<void> deletePlan(int id) async {
    final db = await _dbService.database;
    await db.transaction((txn) async {
      await txn.update(
        billPlanTable,
        {BillPlanKey.isDeleted: 1},
        where: '${BillPlanKey.id} = ?',
        whereArgs: [id],
      );
      await txn.update(
        billTable,
        {BillKey.isDeleted: 1},
        where:
            '${BillKey.billPlanId} = ? AND ${BillKey.status} = ? AND ${BillKey.isDeleted} = 0',
        whereArgs: [id, BillStatus.drafted.value],
      );
    });
  }

  /// Semua tagihan rutin aktif + kategorinya untuk list.
  /// Satu kategori boleh punya banyak tagihan rutin. Tanpa N+1 via satu IN-query.
  /// [nameKeyword] memfilter nama tagihan rutin (LIKE, case-insensitive).
  Future<List<({BillPlan plan, Account category})>> getPlansWithCategories({
    String? nameKeyword,
  }) async {
    final db = await _dbService.database;

    final keyword = nameKeyword?.trim();
    final planRows = await db.query(
      billPlanTable,
      where: keyword == null || keyword.isEmpty
          ? '${BillPlanKey.isDeleted} = 0'
          : '${BillPlanKey.isDeleted} = 0 AND ${BillPlanKey.name} LIKE ?',
      whereArgs: keyword == null || keyword.isEmpty
          ? null
          : ['%$keyword%'],
    );
    if (planRows.isEmpty) return [];

    final plans = planRows.map(BillPlan.fromJson).toList();
    final ids = {for (final plan in plans) plan.accountId}.toList();
    final placeholders = List.filled(ids.length, '?').join(',');
    final accountRows = await db.query(
      accountTable,
      where:
          '${AccountKey.id} IN ($placeholders) AND ${AccountKey.isDeleted} = 0',
      whereArgs: ids,
      orderBy: '${AccountKey.name} ASC',
    );
    final accounts = {
      for (final row in accountRows)
        (row[AccountKey.id] as int): Account.fromJson(row),
    };
    final result = [
      for (final plan in plans)
        if (accounts.containsKey(plan.accountId))
          (plan: plan, category: accounts[plan.accountId]!),
    ];
    result.sort((a, b) => a.category.name.compareTo(b.category.name));
    return result;
  }
}
