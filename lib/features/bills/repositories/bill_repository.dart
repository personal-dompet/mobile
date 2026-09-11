import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/account_preset.dart';
import 'package:dompet_app/core/enums/account_type.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/core/models/pagination_meta.dart';
import 'package:dompet_app/core/models/pagination_result.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';
import 'package:dompet_app/features/bills/enums/bill_status.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/models/bill_filter.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/savings/enums/saving_status.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';
import 'package:dompet_app/features/transactions/repositories/overspend_adjustment.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BillRepository {
  final DbService _dbService;

  const BillRepository(this._dbService);

  Future<PaginationResult<Bill>> getBills({
    required Pagination pagination,
    BillFilter? filter,
  }) async {
    final db = await _dbService.database;
    final effectiveFilter = filter ?? const BillFilter();

    final where = effectiveFilter.whereClauses.join(' AND ');
    final args = effectiveFilter.arguments;

    final totalRow = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM $billTable WHERE $where',
      args,
    );
    final total = (totalRow.first['total'] as int?) ?? 0;

    final rows = await db.query(
      billTable,
      where: where,
      whereArgs: args,
      orderBy: '${BillKey.billedAt} DESC',
      limit: pagination.limit,
      offset: pagination.offset,
    );

    return PaginationResult(
      items: rows.map(Bill.fromJson).toList(),
      meta: PaginationMeta(
        total: total,
        page: pagination.page,
        limit: pagination.limit,
      ),
    );
  }

  Future<int> countBills(BillFilter filter) async {
    final db = await _dbService.database;
    final where = filter.whereClauses.join(' AND ');
    final totalRow = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM $billTable WHERE $where',
      filter.arguments,
    );
    return (totalRow.first['total'] as int?) ?? 0;
  }

  Future<Bill?> getBillById(int id) async {    final db = await _dbService.database;
    final rows = await db.query(
      billTable,
      where: '${BillKey.id} = ? AND ${BillKey.isDeleted} = 0',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Bill.fromJson(rows.first);
  }

  /// Tagihan satu kemunculan tagihan rutin ([planId] + [period]).
  /// Dipakai detail target sisihan untuk bayar langsung.
  Future<Bill?> getBillByPlanAndPeriod(int planId, String period) async {
    final db = await _dbService.database;
    final rows = await db.query(
      billTable,
      where:
          '${BillKey.billPlanId} = ? AND ${BillKey.billPeriod} = ? AND ${BillKey.isDeleted} = 0',
      whereArgs: [planId, period],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Bill.fromJson(rows.first);
  }

  /// Riwayat jurnal satu tagihan (bill_generated / bill_payment),
  /// terbaru dulu. Tanpa lines (cukup untuk histori).
  Future<List<JournalEntry>> getBillJournals(int billId) async {
    final db = await _dbService.database;
    final rows = await db.query(
      journalEntryTable,
      where:
          '${JournalEntryKey.sourceId} = ? AND ${JournalEntryKey.source} IN (?, ?)',
      whereArgs: [
        billId,
        JournalSource.billGenerated.value,
        JournalSource.billPayment.value,
      ],
      orderBy: '${JournalEntryKey.entryDate} DESC',
    );
    return rows.map(JournalEntry.fromJson).toList();
  }

  /// Catat pembayaran lunas dari dompet [assetId].
  /// Saldo kurang → jurnal penyesuaian dulu (cermin expense),
  /// lalu jurnal bill_payment (posted) + status bill → paid, satu transaksi.
  Future<void> payBill({required int billId, required int assetId}) async {
    final db = await _dbService.database;
    final now = DateTime.now();

    await db.transaction((txn) async {
      final billRows = await txn.query(
        billTable,
        where: '${BillKey.id} = ? AND ${BillKey.isDeleted} = 0',
        whereArgs: [billId],
        limit: 1,
      );
      if (billRows.isEmpty) {
        throw Exception('Tagihan tidak ditemukan');
      }
      final bill = Bill.fromJson(billRows.first);
      if (!bill.canPay) {
        throw Exception('Tagihan ini tidak bisa dibayar');
      }

      final planRows = await txn.query(
        billPlanTable,
        where: '${BillPlanKey.id} = ?',
        whereArgs: [bill.billPlanId],
        limit: 1,
      );
      if (planRows.isEmpty) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }
      final planName = planRows.first[BillPlanKey.name] as String?;

      final payableId = await _payableAccountId(txn);

      final assetRows = await txn.query(
        accountTable,
        where:
            '${AccountKey.id} = ? AND ${AccountKey.isDeleted} = 0',
        whereArgs: [assetId],
        limit: 1,
      );
      if (assetRows.isEmpty) {
        throw Exception('Dompet tidak ditemukan');
      }

      final live = await liveBalanceOf(txn, assetId);
      final shortfall = bill.amount - live;
      if (shortfall > 0) {
        await insertShortfallAdjustment(
          txn,
          assetId: assetId,
          effectiveBalance: live,
          shortfall: shortfall,
          date: now,
        );
      }

      final journalEntryId = await txn.rawInsert(
        '''
          INSERT INTO $journalEntryTable (
            ${JournalEntryKey.entryDate},
            ${JournalEntryKey.source},
            ${JournalEntryKey.sourceId},
            ${JournalEntryKey.description},
            ${JournalEntryKey.status}
          ) VALUES (?,?,?,?,?)
        ''',
        [
          now.secondsSinceEpoch,
          JournalSource.billPayment.value,
          billId,
          'Pembayaran ${planName ?? 'tagihan'} • ${bill.billPeriod}',
          JournalStatus.draft.name,
        ],
      );

      await txn.rawInsert(
        '''
          INSERT INTO $journalLineTable (
            ${JournalLineKey.journalEntryId},
            ${JournalLineKey.accountId},
            ${JournalLineKey.debitAmount},
            ${JournalLineKey.creditAmount},
            ${JournalLineKey.lineOrder},
            ${JournalLineKey.note}
          ) VALUES (?,?,?,?,?,?), (?,?,?,?,?,?)
        ''',
        [
          journalEntryId,
          payableId,
          bill.amount,
          0,
          0,
          null,
          journalEntryId,
          assetId,
          0,
          bill.amount,
          1,
          null,
        ],
      );

      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.posted.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [journalEntryId],
      );

      await txn.update(
        billTable,
        {BillKey.status: BillStatus.paid.value},
        where: '${BillKey.id} = ?',
        whereArgs: [billId],
      );
    });
  }

  /// Bayar lunas dari pocket target ([pocketId]) via dompet perantara
  /// ([assetId]) dalam satu transaksi atomik.
  ///
  /// - Jurnal 1 withdraw: debit dompet, credit pocket (`source=saving`,
  ///   metadata WITHDRAW). Masuk histori pocket seperti withdraw biasa.
  /// - Jurnal 2 bill_payment: debit Tagihan Tertunda, credit dompet —
  ///   sama persis seperti [payBill], tapi TANPA penyesuaian shortfall:
  ///   Jurnal 1 mengisi dompet dulu sehingga neto dompet 0
  ///   (pola yang sama dipakai `SavingRepository.spend`).
  /// - Kecukupan dana dicek di pocket, bukan dompet.
  /// Gagal di jurnal mana pun = rollback total.
  Future<void> payBillFromPocket({
    required int billId,
    required int pocketId,
    required int assetId,
  }) async {
    final db = await _dbService.database;
    final now = DateTime.now();

    await db.transaction((txn) async {
      final billRows = await txn.query(
        billTable,
        where: '${BillKey.id} = ? AND ${BillKey.isDeleted} = 0',
        whereArgs: [billId],
        limit: 1,
      );
      if (billRows.isEmpty) {
        throw Exception('Tagihan tidak ditemukan');
      }
      final bill = Bill.fromJson(billRows.first);
      if (!bill.canPay) {
        throw Exception('Tagihan ini tidak bisa dibayar');
      }

      final planRows = await txn.query(
        billPlanTable,
        where: '${BillPlanKey.id} = ?',
        whereArgs: [bill.billPlanId],
        limit: 1,
      );
      if (planRows.isEmpty) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }
      final planName = planRows.first[BillPlanKey.name] as String?;

      final pocketRows = await txn.query(
        savingPlanTable,
        where:
            '${SavingPlanKey.accountId} = ? AND ${SavingPlanKey.isDeleted} = 0 AND ${SavingPlanKey.status} = ?',
        whereArgs: [pocketId, SavingStatus.active.value],
        limit: 1,
      );
      if (pocketRows.isEmpty) {
        throw Exception('Target tidak ditemukan atau sudah ditutup');
      }

      final assetRows = await txn.query(
        accountTable,
        where: '${AccountKey.id} = ? AND ${AccountKey.isDeleted} = 0',
        whereArgs: [assetId],
        limit: 1,
      );
      if (assetRows.isEmpty) {
        throw Exception('Dompet tidak ditemukan');
      }

      final balances = await txn.rawQuery(
        '''
        SELECT ${AccountKey.balance}
        FROM $accountBalanceView
        WHERE ${AccountKey.id} = ?
        LIMIT 1
      ''',
        [pocketId],
      );
      if (balances.isEmpty) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }
      final pocketBalance =
          (balances.first[AccountKey.balance] as num?)?.toInt() ?? 0;
      if (pocketBalance < bill.amount) {
        throw Exception('Saldo target tidak mencukupi');
      }

      final payableId = await _payableAccountId(txn);
      final entryDate = now.secondsSinceEpoch;

      // Jurnal 1: tarik pocket -> dompet.
      final withdrawId = await txn.rawInsert(
        '''
          INSERT INTO $journalEntryTable (
            ${JournalEntryKey.description},
            ${JournalEntryKey.entryDate},
            ${JournalEntryKey.source},
            ${JournalEntryKey.status},
            ${JournalEntryKey.metadata}
          ) VALUES (?,?,?,?,?)
        ''',
        [
          'Bayar ${planName ?? 'tagihan'} • ${bill.billPeriod} dari target',
          entryDate,
          JournalSource.saving.value,
          JournalStatus.draft.name,
          jsonEncode({
            'saving_tx': SavingTxType.withdraw.value,
            'pocket_id': pocketId,
            // Tautan balik ke bill (TC-BINT-010): tanpa ini J1 tak bisa
            // dibedakan dari Tarik biasa sehingga void-nya tak bisa cascade.
            'bill_id': bill.id,
          }),
        ],
      );

      await txn.rawInsert(
        '''
          INSERT INTO $journalLineTable (
            ${JournalLineKey.journalEntryId},
            ${JournalLineKey.accountId},
            ${JournalLineKey.debitAmount},
            ${JournalLineKey.creditAmount},
            ${JournalLineKey.lineOrder},
            ${JournalLineKey.note}
          ) VALUES (?,?,?,?,?,?), (?,?,?,?,?,?)
        ''',
        [
          withdrawId,
          pocketId,
          0,
          bill.amount,
          0,
          null,
          withdrawId,
          assetId,
          bill.amount,
          0,
          1,
          null,
        ],
      );

      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.posted.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [withdrawId],
      );

      // Jurnal 2: lunasi tagihan dari dompet.
      final journalEntryId = await txn.rawInsert(
        '''
          INSERT INTO $journalEntryTable (
            ${JournalEntryKey.entryDate},
            ${JournalEntryKey.source},
            ${JournalEntryKey.sourceId},
            ${JournalEntryKey.description},
            ${JournalEntryKey.status}
          ) VALUES (?,?,?,?,?)
        ''',
        [
          entryDate,
          JournalSource.billPayment.value,
          billId,
          'Pembayaran ${planName ?? 'tagihan'} • ${bill.billPeriod}',
          JournalStatus.draft.name,
        ],
      );

      await txn.rawInsert(
        '''
          INSERT INTO $journalLineTable (
            ${JournalLineKey.journalEntryId},
            ${JournalLineKey.accountId},
            ${JournalLineKey.debitAmount},
            ${JournalLineKey.creditAmount},
            ${JournalLineKey.lineOrder},
            ${JournalLineKey.note}
          ) VALUES (?,?,?,?,?,?), (?,?,?,?,?,?)
        ''',
        [
          journalEntryId,
          payableId,
          bill.amount,
          0,
          0,
          null,
          journalEntryId,
          assetId,
          0,
          bill.amount,
          1,
          null,
        ],
      );

      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.posted.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [journalEntryId],
      );

      await txn.update(
        billTable,
        {BillKey.status: BillStatus.paid.value},
        where: '${BillKey.id} = ?',
        whereArgs: [billId],
      );
    });
  }

  /// Sinkronisasi malas (idempoten, panggil tiap baca).
  /// Kembalikan jumlah tagihan tersentuh (aktivasi + generate).
  /// 1. draft yang billed-nya tiba → unpaid + jurnal bill_generated,
  /// 2. plan tanpa tagihan periode berjalan → buatkan satu unpaid langsung.
  Future<int> synchronizeBills({DateTime? now}) async {
    final today = (now ?? DateTime.now()).startOfDay;
    final todaySec = today.secondsSinceEpoch;
    final db = await _dbService.database;

    var touched = 0;
    await db.transaction((txn) async {
      final drafts = await txn.query(
        billTable,
        where:
            '${BillKey.status} = ? AND ${BillKey.isDeleted} = 0 AND ${BillKey.billedAt} <= ?',
        whereArgs: [BillStatus.drafted.value, todaySec],
      );
      for (final row in drafts) {
        final bill = Bill.fromJson(row);
        final planRows = await txn.query(
          billPlanTable,
          where: '${BillPlanKey.id} = ?',
          whereArgs: [bill.billPlanId],
          limit: 1,
        );
        if (planRows.isEmpty) continue;
        final plan = BillPlan.fromJson(planRows.first);
        await _postGeneratedJournal(
          txn,
          billId: bill.id,
          plan: plan,
          amount: bill.amount,
          billedAtSec: bill.billedAt,
          billPeriod: bill.billPeriod,
        );
        await txn.update(
          billTable,
          {BillKey.status: BillStatus.unpaid.value},
          where: '${BillKey.id} = ?',
          whereArgs: [bill.id],
        );
        touched++;
      }

      final planRows = await txn.query(
        billPlanTable,
        where: '${BillPlanKey.isDeleted} = 0',
      );
      if (planRows.isEmpty) return;
      final plans = planRows.map(BillPlan.fromJson).toList();
      final ids = plans.map((p) => p.id).toList();
      final placeholders = List.filled(ids.length, '?').join(',');
      final existingRows = await txn.rawQuery(
        '''
          SELECT ${BillKey.billPlanId}, ${BillKey.billPeriod}
          FROM $billTable
          WHERE ${BillKey.billPlanId} IN ($placeholders)
            AND ${BillKey.isDeleted} = 0
        ''',
        ids,
      );
      final existing = {
        for (final r in existingRows)
          (r[BillKey.billPlanId], r[BillKey.billPeriod]),
      };

      for (final plan in plans) {
        final label = _currentPeriodLabel(plan.period, today);
        if (existing.contains((plan.id, label))) continue;
        final billed = _currentPeriodBilled(plan, today);
        if (billed.isAfter(today)) continue;
        if (plan.endedAt != null &&
            billed.isAfter(
              DateTime.fromMillisecondsSinceEpoch(plan.endedAt! * 1000),
            )) {
          continue;
        }
        final due = BillSchedule.dueDateFor(
          billed,
          plan.period,
          plan.dueDateSchedule,
        );
        final reminded = due.subtract(
          Duration(days: plan.reminderDays ?? 0),
        );
        final billId = await txn.insert(billTable, {
          BillKey.billPlanId: plan.id,
          BillKey.amount: plan.amount,
          BillKey.billPeriod: label,
          BillKey.billedAt: billed.secondsSinceEpoch,
          BillKey.dueDate: due.startOfDay.secondsSinceEpoch,
          BillKey.remindedAt: reminded.startOfDay.secondsSinceEpoch,
          BillKey.status: BillStatus.unpaid.value,
          BillKey.isDeleted: 0,
        });
        await _postGeneratedJournal(
          txn,
          billId: billId,
          plan: plan,
          amount: plan.amount,
          billedAtSec: billed.secondsSinceEpoch,
          billPeriod: label,
        );
        touched++;
      }
    });
    return touched;
  }

  /// Total nominal tagihan aktif (unpaid, termasuk efektif terlambat).
  Future<int> getPendingTotal() async {
    final db = await _dbService.database;
    final rows = await db.rawQuery(
      '''
        SELECT SUM(${BillKey.amount}) AS total
        FROM $billTable
        WHERE ${BillKey.status} = ? AND ${BillKey.isDeleted} = 0
      ''',
      [BillStatus.unpaid.value],
    );
    return (rows.first['total'] as int?) ?? 0;
  }

  /// Semua tagihan aktif (unpaid, termasuk yang efektif terlambat),
  /// billed paling awal dulu. [planKeyword] memfilter nama tagihan rutin.
  Future<List<Bill>> getActiveBills({String? planKeyword}) async {
    final db = await _dbService.database;
    final keyword = planKeyword?.trim();
    final hasKeyword = keyword != null && keyword.isNotEmpty;
    final rows = await db.rawQuery(
      '''
        SELECT $billTable.*
        FROM $billTable
        INNER JOIN $billPlanTable
          ON $billPlanTable.${BillPlanKey.id} = $billTable.${BillKey.billPlanId}
        WHERE $billTable.${BillKey.status} = ?
          AND $billTable.${BillKey.isDeleted} = 0
          ${hasKeyword ? 'AND $billPlanTable.${BillPlanKey.name} LIKE ?' : ''}
        ORDER BY $billTable.${BillKey.billedAt} ASC
      ''',
      hasKeyword
          ? [BillStatus.unpaid.value, '%$keyword%']
          : [BillStatus.unpaid.value],
    );
    return rows.map(Bill.fromJson).toList();
  }

  Future<int> _payableAccountId(Transaction txn) async {
    final rows = await txn.rawQuery(
      '''
        SELECT * FROM $accountBalanceView
        WHERE ${AccountKey.code} = ? AND ${AccountKey.type} = ?
        LIMIT 1
      ''',
      [AccountPreset.delayedBill.code, AccountType.liability.value],
    );
    if (rows.isEmpty) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }
    return rows.first[AccountKey.id] as int;
  }

  /// Jurnal akrual ditagih (posted): Dr beban kategori / Kr Tagihan Tertunda.
  Future<void> _postGeneratedJournal(
    Transaction txn, {
    required int billId,
    required BillPlan plan,
    required int amount,
    required int billedAtSec,
    required String billPeriod,
  }) async {
    final payableId = await _payableAccountId(txn);
    final journalEntryId = await txn.rawInsert(
      '''
        INSERT INTO $journalEntryTable (
          ${JournalEntryKey.entryDate},
          ${JournalEntryKey.source},
          ${JournalEntryKey.sourceId},
          ${JournalEntryKey.description},
          ${JournalEntryKey.status}
        ) VALUES (?,?,?,?,?)
      ''',
      [
        billedAtSec,
        JournalSource.billGenerated.value,
        billId,
        'Tagihan ${plan.name} • $billPeriod',
        JournalStatus.draft.name,
      ],
    );
    await txn.rawInsert(
      '''
        INSERT INTO $journalLineTable (
          ${JournalLineKey.journalEntryId},
          ${JournalLineKey.accountId},
          ${JournalLineKey.debitAmount},
          ${JournalLineKey.creditAmount},
          ${JournalLineKey.lineOrder},
          ${JournalLineKey.note}
        ) VALUES (?,?,?,?,?,?), (?,?,?,?,?,?)
      ''',
      [
        journalEntryId,
        plan.accountId,
        amount,
        0,
        0,
        null,
        journalEntryId,
        payableId,
        0,
        amount,
        1,
        null,
      ],
    );
    await txn.update(
      journalEntryTable,
      {JournalEntryKey.status: JournalStatus.posted.name},
      where: '${JournalEntryKey.id} = ?',
      whereArgs: [journalEntryId],
    );
  }

  String _currentPeriodLabel(String period, DateTime today) {
    if (period == BillPlanPeriodEnum.yearly.name) {
      return today.year.toString();
    }
    return DateFormat('yyyy-MM').format(today);
  }

  DateTime _currentPeriodBilled(BillPlan plan, DateTime today) {
    if (plan.period == BillPlanPeriodEnum.yearly.name) {
      return BillSchedule.yearlyDate(today.year, plan.billedSchedule);
    }
    return BillSchedule.monthlyDate(
      today.year,
      today.month,
      plan.billedSchedule,
    );
  }
}
