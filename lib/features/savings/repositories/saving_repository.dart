import 'dart:convert';

import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/savings/enums/saving_status.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/models/journal_line.dart';
import 'package:dompet_app/features/savings/models/saving_filter.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';
import 'package:sqflite/sqflite.dart';

class SavingRepository {
  final DbService _dbService;

  const SavingRepository(this._dbService);

  Future<List<SavingPlan>> getPockets(SavingFilter filter) async {
    final db = await _dbService.database;

    final clauses = <String>[];
    final args = <dynamic>[];

    if (filter.accountName != null && filter.accountName!.isNotEmpty) {
      clauses.add('${SavingPlanKey.accountName} LIKE ?');
      args.add('%${filter.accountName!.trim()}%');
    }

    if (filter.status != null && filter.status!.isNotEmpty) {
      clauses.add('$savingTrackerView.${SavingPlanKey.status} = ?');
      args.add(filter.status);
    }

    final where = clauses.isEmpty ? '' : 'WHERE ${clauses.join(' AND ')}';

    final rows = await db.rawQuery('''
      SELECT *
      FROM $savingTrackerView
      $where
      ORDER BY ${SavingPlanKey.createdAt} DESC
    ''', args);

    return rows.map((row) => SavingPlan.fromJson(row)).toList();
  }

  Future<SavingPlan?> getByAccountId(int accountId) async {
    final db = await _dbService.database;

    final rows = await db.rawQuery(
      '''
      SELECT *
      FROM $savingTrackerView
      WHERE ${SavingPlanKey.accountId} = ?
      LIMIT 1
    ''',
      [accountId],
    );

    if (rows.isEmpty) return null;
    return SavingPlan.fromJson(rows.first);
  }

  Future<SavingPlan?> getById(int id) async {
    final db = await _dbService.database;

    final rows = await db.rawQuery(
      '''
      SELECT *
      FROM $savingTrackerView
      WHERE ${SavingPlanKey.id} = ?
      LIMIT 1
    ''',
      [id],
    );

    if (rows.isEmpty) return null;
    return SavingPlan.fromJson(rows.first);
  }

  /// Riwayat jurnal pocket (alokasi/tarik/belanja) untuk Detail Target.
  ///
  /// Filter `source = saving` + `status = posted` + ada line dengan
  /// `accountId` pocket. Urut terbaru dulu (full list, tanpa pagination:
  /// histori satu pocket umumnya kecil).
  Future<List<JournalEntry>> getPocketJournals(int accountId) async {
    final db = await _dbService.database;

    final journalResults = await db.rawQuery('''
      SELECT
        $journalEntryTable.${JournalEntryKey.id},
        $journalEntryTable.${JournalEntryKey.entryDate},
        $journalEntryTable.${JournalEntryKey.description},
        $journalEntryTable.${JournalEntryKey.reference},
        $journalEntryTable.${JournalEntryKey.source},
        $journalEntryTable.${JournalEntryKey.status},
        $journalEntryTable.${JournalEntryKey.sourceId},
        $journalEntryTable.${JournalEntryKey.metadata},
        json_group_array(
          json_object(
            '${JournalLineKey.id}', $journalLineTable.${JournalLineKey.id},
            '${JournalLineKey.journalEntryId}', $journalLineTable.${JournalLineKey.journalEntryId},
            '${JournalLineKey.accountId}', $journalLineTable.${JournalLineKey.accountId},
            '${JournalLineKey.accountName}', $accountBalanceView.${AccountKey.name},
            '${JournalLineKey.accountType}', $accountBalanceView.${AccountKey.type},
            '${JournalLineKey.accountBalance}', $accountBalanceView.${AccountKey.balance},
            '${JournalLineKey.accountNormalBalance}', $accountBalanceView.${AccountKey.normalBalance},
            '${JournalLineKey.debitAmount}', $journalLineTable.${JournalLineKey.debitAmount},
            '${JournalLineKey.creditAmount}', $journalLineTable.${JournalLineKey.creditAmount},
            '${JournalLineKey.lineOrder}', $journalLineTable.${JournalLineKey.lineOrder},
            '${JournalLineKey.note}', $journalLineTable.${JournalLineKey.note}
          )
        ) AS ${JournalEntryKey.lines}
      FROM $journalEntryTable
      INNER JOIN $journalLineTable ON $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
      INNER JOIN $accountBalanceView ON $accountBalanceView.${AccountKey.id} = $journalLineTable.${JournalLineKey.accountId}
      WHERE $journalEntryTable.${JournalEntryKey.source} = ?
        AND $journalEntryTable.${JournalEntryKey.status} = ?
        AND EXISTS (
          SELECT 1 FROM $journalLineTable jl
          WHERE jl.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
          AND jl.${JournalLineKey.accountId} = ?
        )
      GROUP BY $journalEntryTable.${JournalEntryKey.id}
      ORDER BY $journalEntryTable.${JournalEntryKey.entryDate} DESC
    ''', [JournalSource.saving.value, JournalStatus.posted.name, accountId]);

    return journalResults.map((journalResult) {
      final result = {...journalResult};

      final List<dynamic> journalLines = jsonDecode(
        result[JournalEntryKey.lines] as String,
      );

      result.remove(JournalEntryKey.lines);

      final journal = JournalEntry.fromJson(result);

      return journal.copyWith(
        lines: journalLines.map((line) => JournalLine.fromJson(line)).toList(),
      );
    }).toList();
  }

  Future<SavingPlan> createPocket({
    required String name,
    int? iconCode,
    int? targetAmount,
    int? targetDate,
    String? note,
    int? initialAssetId,
    int? initialAmount,
    DateTime? date,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw Exception('Nama target belum diisi');
    }
    if (targetAmount != null && targetAmount <= 0) {
      throw Exception('Target harus lebih dari 0');
    }
    if (initialAmount != null && initialAmount <= 0) {
      throw Exception('Nominal awal harus lebih dari 0');
    }

    final db = await _dbService.database;

    final accountId = await db.transaction((txn) async {
      final nextCode = await _generateCode(
        txn,
        code: AccountPreset.savingPocket.code,
      );

      final presetResult = await txn.query(
        accountTable,
        where: '${AccountKey.code} = ? AND ${AccountKey.isSystem} = 1',
        whereArgs: [AccountPreset.savingPocket.code],
        limit: 1,
      );
      if (presetResult.isEmpty) {
        throw Exception('Terjadi kesalahan data pada aplikasi');
      }
      final preset = Account.fromJson(presetResult.first);

      final newAccountId = await txn.rawInsert(
        '''
        INSERT INTO $accountTable (
          ${AccountKey.code},
          ${AccountKey.name},
          ${AccountKey.isLiquid},
          ${AccountKey.type},
          ${AccountKey.normalBalance},
          ${AccountKey.iconCode},
          ${AccountKey.isSystem}
        ) VALUES (?,?,?,?,?,?,?)
      ''',
        [
          nextCode,
          trimmedName,
          0,
          preset.type.value,
          preset.normalbalance.value,
          iconCode ?? preset.iconCode,
          0,
        ],
      );

      await txn.rawInsert(
        '''
        INSERT INTO $savingPlanTable (
          ${SavingPlanKey.accountId},
          ${SavingPlanKey.targetAmount},
          ${SavingPlanKey.targetDate},
          ${SavingPlanKey.note},
          ${SavingPlanKey.status},
          ${SavingPlanKey.isDeleted}
        ) VALUES (?,?,?,?,?,0)
      ''',
        [
          newAccountId,
          targetAmount,
          targetDate,
          note,
          SavingStatus.active.value,
        ],
      );

      if (initialAssetId != null && initialAmount != null) {
        await _recordTopup(
          txn,
          pocketId: newAccountId,
          assetId: initialAssetId,
          amount: initialAmount,
          note: note,
          date: date ?? DateTime.now(),
        );
      }

      return newAccountId;
    });

    final plan = await getByAccountId(accountId);
    if (plan == null) {
      throw Exception('Gagal memuat target yang baru dibuat');
    }
    return plan;
  }

  Future<SavingPlan?> updatePlan({
    required int accountId,
    required String name,
    int? iconCode,
    int? targetAmount,
    int? targetDate,
    String? note,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw Exception('Nama target belum diisi');
    }
    if (targetAmount != null && targetAmount <= 0) {
      throw Exception('Target harus lebih dari 0');
    }

    final db = await _dbService.database;

    await db.transaction((txn) async {
      final existing = await txn.query(
        savingPlanTable,
        where:
            '${SavingPlanKey.accountId} = ? AND ${SavingPlanKey.isDeleted} = 0',
        whereArgs: [accountId],
        limit: 1,
      );
      if (existing.isEmpty) {
        throw Exception('Target tidak ditemukan');
      }

      await txn.update(
        savingPlanTable,
        {
          SavingPlanKey.targetAmount: targetAmount,
          SavingPlanKey.targetDate: targetDate,
          SavingPlanKey.note: note,
        },
        where: '${SavingPlanKey.accountId} = ?',
        whereArgs: [accountId],
      );

      await txn.update(
        accountTable,
        {AccountKey.name: trimmedName, AccountKey.iconCode: iconCode},
        where: '${AccountKey.id} = ?',
        whereArgs: [accountId],
      );
    });

    return getByAccountId(accountId);
  }

  Future<int> topup({
    required int pocketId,
    required int assetId,
    required int amount,
    String? note,
    DateTime? date,
  }) async {
    if (amount <= 0) {
      throw Exception('Nominal harus lebih dari 0');
    }

    final db = await _dbService.database;

    return db.transaction((txn) async {
      await _assertActivePocket(txn, pocketId);
      await _assertLiquidAsset(txn, assetId);
      await _assertSufficientBalance(txn, assetId, amount);

      return _recordTopup(
        txn,
        pocketId: pocketId,
        assetId: assetId,
        amount: amount,
        note: note,
        date: date ?? DateTime.now(),
      );
    });
  }

  Future<int> withdraw({
    required int pocketId,
    required int assetId,
    required int amount,
    String? note,
    DateTime? date,
  }) async {
    if (amount <= 0) {
      throw Exception('Nominal harus lebih dari 0');
    }

    final db = await _dbService.database;

    return db.transaction((txn) async {
      await _assertActivePocket(txn, pocketId);
      await _assertLiquidAsset(txn, assetId);
      await _assertSufficientBalance(txn, pocketId, amount);

      return _recordWithdraw(
        txn,
        pocketId: pocketId,
        assetId: assetId,
        amount: amount,
        note: note,
        date: date ?? DateTime.now(),
      );
    });
  }

  /// FIX-09 (IMP-7 opsi B + ISSUE 15): Belanja = Tarik + Pengeluaran,
  /// 2 jurnal atomik dalam satu `db.transaction`.
  ///
  /// - Jurnal 1 tarik: debit dompet, credit pocket (`source=saving`,
  ///   metadata SPEND + flag `hybrid`). Masuk histori pocket dengan judul
  ///   "Belanja", baris `saving_spend` laporan (kontribusi expense 0 —
  ///   tak sentuh akun expense, ikut pola topup/withdraw existing).
  ///   Flag `hybrid` sengaja netral (tanpa substring TOPUP/WITHDRAW/SPEND)
  ///   agar query laporan `LIKE` tak double-count.
  /// - Jurnal 2 keluar: debit expense, credit dompet (`source=transaction`,
  ///   Q6; metadata `spend_expense` + `pocket_id`). Inilah yang dihitung
  ///   laporan per-kategori dan `v_budget_tracker.actualSpend`, sehingga
  ///   list + detail anggaran segar bersama (TC-BGT-011).
  /// - `categoryId` opsional: kosong → fallback akun expense `Lain-Lain`
  ///   (Q7: cari by code, buat bila tak ada).
  /// - Hanya pocket yang divalidasi kecukupannya (Q8: dompet perantara boleh
  ///   0 — Jurnal 1 mengisinya dulu, neto dompet 0).
  ///
  /// Gagal di jurnal mana pun = rollback total (tak ada jurnal parsial).
  /// Mengembalikan id Jurnal 2 (jurnal expense).
  Future<int> spend({
    required int pocketId,
    required int assetId,
    int? categoryId,
    required int amount,
    String? note,
    DateTime? date,
  }) async {
    if (amount <= 0) {
      throw Exception('Nominal harus lebih dari 0');
    }

    final db = await _dbService.database;

    return db.transaction((txn) async {
      await _assertActivePocket(txn, pocketId);
      await _assertLiquidAsset(txn, assetId);
      final expenseId = await _resolveSpendCategory(txn, categoryId);
      await _assertSufficientBalance(txn, pocketId, amount);

      final entryDate = (date ?? DateTime.now()).secondsSinceEpoch;

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
          note,
          entryDate,
          JournalSource.saving.value,
          JournalStatus.draft.name,
          jsonEncode({
            'saving_tx': SavingTxType.spend.value,
            'pocket_id': pocketId,
            'hybrid': true,
          }),
        ],
      );

      await txn.rawInsert(
        '''
        INSERT INTO $journalLineTable (
          ${JournalLineKey.accountId},
          ${JournalLineKey.creditAmount},
          ${JournalLineKey.debitAmount},
          ${JournalLineKey.journalEntryId},
          ${JournalLineKey.lineOrder},
          ${JournalLineKey.note}
        ) VALUES (?,?,?,?,?,?), (?,?,?,?,?,?)
      ''',
        [
          pocketId,
          amount,
          0,
          withdrawId,
          0,
          note,
          assetId,
          0,
          amount,
          withdrawId,
          1,
          note,
        ],
      );

      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.posted.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [withdrawId],
      );

      // Jurnal 2: pengeluaran dompet -> kategori expense.
      final expenseJournalId = await txn.rawInsert(
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
          note,
          entryDate,
          JournalSource.transaction.value,
          JournalStatus.draft.name,
          jsonEncode({
            'hybrid_expense': true,
            'pocket_id': pocketId,
          }),
        ],
      );

      await txn.rawInsert(
        '''
        INSERT INTO $journalLineTable (
          ${JournalLineKey.accountId},
          ${JournalLineKey.creditAmount},
          ${JournalLineKey.debitAmount},
          ${JournalLineKey.journalEntryId},
          ${JournalLineKey.lineOrder},
          ${JournalLineKey.note}
        ) VALUES (?,?,?,?,?,?), (?,?,?,?,?,?)
      ''',
        [
          expenseId,
          0,
          amount,
          expenseJournalId,
          0,
          note,
          assetId,
          amount,
          0,
          expenseJournalId,
          1,
          note,
        ],
      );

      await txn.update(
        journalEntryTable,
        {JournalEntryKey.status: JournalStatus.posted.name},
        where: '${JournalEntryKey.id} = ?',
        whereArgs: [expenseJournalId],
      );

      return expenseJournalId;
    });
  }

  /// Q7: kategori belanja opsional. Bila diisi, validasi seperti dulu;
  /// bila kosong, fallback ke akun expense `Lain-Lain` (cari by code,
  /// pulihkan bila terarsip, buat bila belum ada).
  Future<int> _resolveSpendCategory(Transaction txn, int? categoryId) async {
    if (categoryId != null) {
      await _assertExpenseCategory(txn, categoryId);
      return categoryId;
    }

    final code = AccountPreset.otherExpense.code;
    final existing = await txn.query(
      accountTable,
      where: '${AccountKey.code} = ? AND ${AccountKey.type} = ?',
      whereArgs: [code, AccountType.expense.value],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      final row = existing.first;
      final id = row[AccountKey.id] as int;
      if ((row[AccountKey.isDeleted] as num?)?.toInt() == 1) {
        await txn.update(
          accountTable,
          {AccountKey.isDeleted: 0},
          where: '${AccountKey.id} = ?',
          whereArgs: [id],
        );
      }
      return id;
    }

    return txn.insert(accountTable, {
      AccountKey.code: code,
      AccountKey.name: AccountPreset.otherExpense.value,
      AccountKey.iconCode: AccountPreset.otherExpense.icon.codePoint,
      AccountKey.normalBalance: AccountType.expense.balanceType.value,
      AccountKey.type: AccountType.expense.value,
      AccountKey.isLiquid: 0,
      AccountKey.isSystem: 0,
    });
  }

  /// Menghapus pocket sekaligus mengembalikan seluruh sisa ke dompet cair
  /// dalam satu transaksi atomik.
  ///
  /// Tanpa ini sisa saldo terkunci selamanya di pocket non-liquid yang
  /// ter-soft-delete (tak terlihat di daftar maupun Total Uang).
  /// Mengembalikan `null` jika saldo sudah 0 (langsung hapus tanpa jurnal).
  Future<int?> deleteWithWithdraw({
    required int accountId,
    required int assetId,
    String? note,
    DateTime? date,
  }) async {
    final db = await _dbService.database;

    return db.transaction((txn) async {
      await _assertActivePocket(txn, accountId);
      await _assertLiquidAsset(txn, assetId);

      final balance = await _balanceOf(txn, accountId);

      int? journalId;
      if (balance > 0) {
        journalId = await _recordWithdraw(
          txn,
          pocketId: accountId,
          assetId: assetId,
          amount: balance,
          note: note,
          date: date ?? DateTime.now(),
        );
      }

      await txn.update(
        savingPlanTable,
        {SavingPlanKey.isDeleted: 1},
        where:
            '${SavingPlanKey.accountId} = ? AND ${SavingPlanKey.status} = ? AND ${SavingPlanKey.isDeleted} = 0',
        whereArgs: [accountId, SavingStatus.active.value],
      );

      await txn.update(
        accountTable,
        {AccountKey.isDeleted: 1},
        where: '${AccountKey.id} = ?',
        whereArgs: [accountId],
      );

      return journalId;
    });
  }

  Future<void> delete(int accountId) async {
    final db = await _dbService.database;

    await db.transaction((txn) async {
      await txn.update(
        savingPlanTable,
        {SavingPlanKey.isDeleted: 1},
        where: '${SavingPlanKey.accountId} = ?',
        whereArgs: [accountId],
      );

      await txn.update(
        accountTable,
        {AccountKey.isDeleted: 1},
        where: '${AccountKey.id} = ?',
        whereArgs: [accountId],
      );
    });
  }

  Future<int> _recordTopup(
    Transaction txn, {
    required int pocketId,
    required int assetId,
    required int amount,
    String? note,
    required DateTime date,
  }) async {
    final journalEntryId = await txn.rawInsert(
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
        note,
        date.secondsSinceEpoch,
        JournalSource.saving.value,
        JournalStatus.draft.name,
        jsonEncode({
          'saving_tx': SavingTxType.topup.value,
          'pocket_id': pocketId,
        }),
      ],
    );

    await txn.rawInsert(
      '''
      INSERT INTO $journalLineTable (
        ${JournalLineKey.accountId},
        ${JournalLineKey.creditAmount},
        ${JournalLineKey.debitAmount},
        ${JournalLineKey.journalEntryId},
        ${JournalLineKey.lineOrder},
        ${JournalLineKey.note}
      ) VALUES (?,?,?,?,?,?), (?,?,?,?,?,?)
    ''',
      [
        assetId,
        amount,
        0,
        journalEntryId,
        0,
        note,
        pocketId,
        0,
        amount,
        journalEntryId,
        1,
        note,
      ],
    );

    await txn.update(
      journalEntryTable,
      {JournalEntryKey.status: JournalStatus.posted.name},
      where: '${JournalEntryKey.id} = ?',
      whereArgs: [journalEntryId],
    );

    return journalEntryId;
  }

  Future<int> _recordWithdraw(
    Transaction txn, {
    required int pocketId,
    required int assetId,
    required int amount,
    String? note,
    required DateTime date,
  }) async {
    final journalEntryId = await txn.rawInsert(
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
        note,
        date.secondsSinceEpoch,
        JournalSource.saving.value,
        JournalStatus.draft.name,
        jsonEncode({
          'saving_tx': SavingTxType.withdraw.value,
          'pocket_id': pocketId,
        }),
      ],
    );

    await txn.rawInsert(
      '''
      INSERT INTO $journalLineTable (
        ${JournalLineKey.accountId},
        ${JournalLineKey.creditAmount},
        ${JournalLineKey.debitAmount},
        ${JournalLineKey.journalEntryId},
        ${JournalLineKey.lineOrder},
        ${JournalLineKey.note}
      ) VALUES (?,?,?,?,?,?), (?,?,?,?,?,?)
    ''',
      [
        pocketId,
        amount,
        0,
        journalEntryId,
        0,
        note,
        assetId,
        0,
        amount,
        journalEntryId,
        1,
        note,
      ],
    );

    await txn.update(
      journalEntryTable,
      {JournalEntryKey.status: JournalStatus.posted.name},
      where: '${JournalEntryKey.id} = ?',
      whereArgs: [journalEntryId],
    );

    return journalEntryId;
  }

  Future<void> _assertActivePocket(Transaction txn, int pocketId) async {
    final rows = await txn.query(
      savingPlanTable,
      where:
          '${SavingPlanKey.accountId} = ? AND ${SavingPlanKey.isDeleted} = 0 AND ${SavingPlanKey.status} = ?',
      whereArgs: [pocketId, SavingStatus.active.value],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw Exception('Target tidak ditemukan atau sudah ditutup');
    }
  }

  Future<void> _assertLiquidAsset(Transaction txn, int assetId) async {
    final rows = await txn.query(
      accountTable,
      where:
          '${AccountKey.id} = ? AND ${AccountKey.isDeleted} = 0 AND ${AccountKey.type} = ? AND ${AccountKey.isLiquid} = 1',
      whereArgs: [assetId, AccountType.asset.value],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }
  }

  Future<void> _assertExpenseCategory(Transaction txn, int categoryId) async {
    final rows = await txn.query(
      accountTable,
      where:
          '${AccountKey.id} = ? AND ${AccountKey.isDeleted} = 0 AND ${AccountKey.type} = ?',
      whereArgs: [categoryId, AccountType.expense.value],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }
  }

  Future<void> _assertSufficientBalance(
    Transaction txn,
    int accountId,
    int amount,
  ) async {
    final balance = await _balanceOf(txn, accountId);
    if (balance < amount) {
      throw Exception('Saldo tidak mencukupi');
    }
  }

  Future<int> _balanceOf(Transaction txn, int accountId) async {
    final rows = await txn.rawQuery(
      '''
      SELECT ${AccountKey.balance}
      FROM $accountBalanceView
      WHERE ${AccountKey.id} = ?
      LIMIT 1
    ''',
      [accountId],
    );
    if (rows.isEmpty) {
      throw Exception('Terjadi kesalahan data pada aplikasi');
    }
    return (rows.first[AccountKey.balance] as num?)?.toInt() ?? 0;
  }

  /// Kode child berikutnya yang deterministik: max suffix numerik + 1.
  ///
  /// Tidak memakai `created_at` (resolusi 1 detik — seri saat insert cepat
  /// beruntun sehingga `latest` salah tebak → kode duplikat → UNIQUE gagal).
  /// Baris ter-soft-delete tetap dihitung agar kode monotonik naik dan
  /// tidak pernah dipakai ulang.
  Future<String> _generateCode(Transaction txn, {required String code}) async {
    final rows = await txn.query(
      accountTable,
      columns: [AccountKey.code],
      where: '${AccountKey.code} LIKE ?',
      whereArgs: ['$code.%'],
    );

    var maxIndex = 0;
    for (final row in rows) {
      final rowCode = row[AccountKey.code] as String?;
      if (rowCode == null) continue;
      final parts = rowCode.split('.');
      if (parts.isEmpty) continue;
      final index = int.tryParse(parts.last);
      if (index == null) continue;
      final prefix = rowCode.substring(
        0,
        rowCode.length - parts.last.length - 1,
      );
      if (prefix != code) continue;
      if (index > maxIndex) maxIndex = index;
    }

    final nextIndex = (maxIndex + 1).toString().padLeft(4, '0');
    return '$code.$nextIndex';
  }
}
