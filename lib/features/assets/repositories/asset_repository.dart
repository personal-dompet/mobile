import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/extensions/date.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:sqflite/sqflite.dart';

class AssetRepository {
  final DbService _dbService;

  const AssetRepository(this._dbService);

  Future<Account> createAsset(AssetForm form) async {
    final db = await _dbService.database;

    if (form.invalid) {
      throw Exception('Kesalahan syntax, data tidak valid. Hubungi developer.');
    }

    final result = await db.transaction((txn) async {
      final nextCode = await _generateCode(txn, code: form.code!);

      final presetAccountResult = await txn.query(
        accountTable,
        where: '${AccountKey.code} = ? AND ${AccountKey.isSystem} = 1',
        whereArgs: [form.code],
        limit: 1,
      );

      final presetAccount = Account.fromJson(presetAccountResult.first);

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
          form.name,
          presetAccount.isLiquid ? 1 : 0,
          presetAccount.type.value,
          presetAccount.normalbalance.value,
          form.iconCode ?? presetAccount.iconCode,
          0,
        ],
      );

      final newAccountResult = await txn.rawQuery(
        '''
        SELECT *
        FROM $accountTable
        WHERE $accountTable.${AccountKey.id} = ?
      ''',
        [newAccountId],
      );

      if (newAccountResult.isEmpty) {
        throw Exception('Gagal membuat akun baru');
      }

      final newAccount = Account.fromJson(newAccountResult.first);

      if (form.balance != null && form.balance! > 0) {
        final result = await txn.rawQuery(
          '''
          SELECT ${AccountKey.id} FROM $accountTable
          WHERE ${AccountKey.code} = ?
          LIMIT 1
        ''',
          [AccountPreset.intialBalance.code],
        );

        final int? initialBalanceAccountId = Sqflite.firstIntValue(result);

        if (initialBalanceAccountId != null) {
          final newJournalEntryId = await txn.insert(journalEntryTable, {
            JournalEntryKey.description: 'Konfigurasi saldo awal',
            JournalEntryKey.entryDate: DateTime.now().secondsSinceEpoch,
            JournalEntryKey.source: JournalSource.setup.value,
            JournalEntryKey.status: JournalStatus.posted.name,
          });

          await txn.rawInsert(
            '''
            INSERT INTO $journalLineTable (
              ${JournalLineKey.accountId},
              ${JournalLineKey.creditAmount},
              ${JournalLineKey.debitAmount},
              ${JournalLineKey.journalEntryId},
              ${JournalLineKey.lineOrder}
            ) VALUES (?,?,?,?,?), (?,?,?,?,?)
          ''',
            [
              // Asset Account
              newAccount.id,
              0,
              form.balance,
              newJournalEntryId,
              0,

              // Liability Account
              initialBalanceAccountId,
              form.balance,
              0,
              newJournalEntryId,
              1,
            ],
          );
        }
      }

      return newAccount;
    });

    return result;
  }

  Future<void> updateAsset({required AssetForm form, required int id}) async {
    final db = await _dbService.database;

    if (form.invalid) {
      throw Exception('Kesalahan syntax, data tidak valid. Hubungi developer.');
    }

    await db.transaction((txn) async {
      final parentAccountResult = await txn.query(
        accountTable,
        where: '${AccountKey.code} = ? AND ${AccountKey.isSystem} = 1',
        whereArgs: [form.code],
        limit: 1,
      );

      final parentAccount = Account.fromJson(parentAccountResult.first);

      final currentAccountResult = await txn.query(
        accountTable,
        where: '${AccountKey.id} = ?',
        whereArgs: [id],
        limit: 1,
      );

      final currentAccount = Account.fromJson(currentAccountResult.first);

      Map<String, dynamic> values = {
        AccountKey.name: form.name,
        AccountKey.iconCode: parentAccount.iconCode,
        AccountKey.normalBalance: parentAccount.normalbalance.value,
      };

      if (!currentAccount.code.startsWith(form.code!)) {
        final newCode = await _generateCode(txn, code: form.code!);
        values.putIfAbsent(AccountKey.code, () => newCode);
      }

      await txn.update(
        accountTable,
        values,
        where: '${AccountKey.id} = ?',
        whereArgs: [id],
      );
    });
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
