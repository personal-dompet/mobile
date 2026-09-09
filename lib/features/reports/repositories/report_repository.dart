import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/journals/enums/journal_source.dart';
import 'package:dompet_app/features/journals/enums/journal_status.dart';
import 'package:dompet_app/features/reports/models/category_spending.dart';
import 'package:dompet_app/features/savings/enums/saving_tx_type.dart';
import 'package:dompet_app/features/reports/models/monthly_summary.dart';
import 'package:dompet_app/features/reports/models/period_comparison.dart';
import 'package:dompet_app/features/reports/models/report_period.dart';

/// Mesin agregasi reporting (Tahap 1: ringkasan bulanan).
///
/// Semua angka dihitung di SQL agar cepat dan konsisten dengan
/// [DashboardRepository], tapi digeneralisasi ke [ReportPeriod].
///
/// Aturan sumber jurnal:
/// - Pemasukan/pengeluaran: `source` transaction + saving. Jurnal tabungan
///   tidak pernah menyentuh akun INCOME, dan satu-satunya jurnal tabungan
///   yang menyentuh akun EXPENSE adalah SPEND (belanja langsung dari
///   pocket) — sehingga topup/withdraw otomatis berkontribusi 0.
/// - Transfer/adjustment/setup/bill dikecualikan agar tidak menggelembungkan
///   pemasukan/pengeluaran.
/// - Alokasi target (topup − withdraw − spend) dihitung terpisah sebagai baris
///   "Dialokasikan ke target": BUKAN pengeluaran, tapi penjelas selisih antara
///   net laporan dan perubahan Total Uang di Beranda.
class ReportRepository {
  final DbService _dbService;

  const ReportRepository(this._dbService);

  Future<MonthlySummary> getMonthlySummary(ReportPeriod period) async {
    final db = await _dbService.database;

    final results = await Future.wait([
      db.rawQuery(
        '''
        SELECT
          SUM(CASE WHEN $accountTable.${AccountKey.type} = ? THEN $journalLineTable.${JournalLineKey.creditAmount} ELSE 0 END) AS income,
          SUM(CASE WHEN $accountTable.${AccountKey.type} = ? THEN $journalLineTable.${JournalLineKey.debitAmount} ELSE 0 END) AS expense,
          COUNT(DISTINCT CASE WHEN $journalEntryTable.${JournalEntryKey.source} = ? THEN $journalEntryTable.${JournalEntryKey.id} END) AS transaction_count
        FROM $journalEntryTable
        INNER JOIN $journalLineTable
          ON $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
        INNER JOIN $accountTable
          ON $journalLineTable.${JournalLineKey.accountId} = $accountTable.${AccountKey.id}
        WHERE $journalEntryTable.${JournalEntryKey.source} IN (?, ?)
          AND $journalEntryTable.${JournalEntryKey.status} = ?
          AND ($journalEntryTable.${JournalEntryKey.entryDate} BETWEEN ? AND ?)
        ''',
        [
          AccountType.income.value,
          AccountType.expense.value,
          JournalSource.transaction.value,
          JournalSource.transaction.value,
          JournalSource.saving.value,
          JournalStatus.posted.name,
          period.startEpoch,
          period.endEpoch,
        ],
      ),
      db.rawQuery(
        '''
        SELECT
          SUM(CASE WHEN $journalEntryTable.${JournalEntryKey.metadata} LIKE ? THEN $journalLineTable.${JournalLineKey.debitAmount} ELSE 0 END) AS saving_topup,
          SUM(CASE WHEN $journalEntryTable.${JournalEntryKey.metadata} LIKE ? THEN $journalLineTable.${JournalLineKey.creditAmount} ELSE 0 END) AS saving_withdraw,
          SUM(CASE WHEN $journalEntryTable.${JournalEntryKey.metadata} LIKE ? THEN $journalLineTable.${JournalLineKey.creditAmount} ELSE 0 END) AS saving_spend
        FROM $journalEntryTable
        INNER JOIN $journalLineTable
          ON $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
        INNER JOIN $accountTable
          ON $journalLineTable.${JournalLineKey.accountId} = $accountTable.${AccountKey.id}
        WHERE $journalEntryTable.${JournalEntryKey.source} = ?
          AND $journalEntryTable.${JournalEntryKey.status} = ?
          AND ($journalEntryTable.${JournalEntryKey.entryDate} BETWEEN ? AND ?)
          AND $accountTable.${AccountKey.code} LIKE ?
        ''',
        [
          '%${SavingTxType.topup.value}%',
          '%${SavingTxType.withdraw.value}%',
          '%${SavingTxType.spend.value}%',
          JournalSource.saving.value,
          JournalStatus.posted.name,
          period.startEpoch,
          period.endEpoch,
          '${AccountPreset.savingPocket.code}.%',
        ],
      ),
    ]);

    final row = <String, dynamic>{
      if (results[0].isNotEmpty) ...results[0].first,
      if (results[1].isNotEmpty) ...results[1].first,
    };
    return MonthlySummary.fromJson(row, period);
  }

  Future<PeriodComparison> getComparison(ReportPeriod period) async {
    final results = await Future.wait([
      getMonthlySummary(period),
      getMonthlySummary(period.previous),
    ]);
    return PeriodComparison(current: results[0], previous: results[1]);
  }

  /// Tren [months] bulan terakhir berakhir di [end] (inklusif),
  /// urut tertua → terbaru. Bulan kosong diisi nol.
  ///
  /// Sengaja memanggil [getMonthlySummary] per bulan (bukan GROUP BY di
  /// SQL) agar batas bulan memakai zona waktu lokal yang sama seperti
  /// [ReportPeriod], bukan UTC ala `strftime(..., 'unixepoch')`.
  Future<List<MonthlySummary>> getTrend(
    ReportPeriod end, {
    int months = 6,
  }) async {
    assert(months >= 2);
    final periods = List.generate(months, (i) {
      final base = DateTime(end.year, end.month, 1);
      final shifted = DateTime(base.year, base.month - (months - 1 - i), 1);
      return ReportPeriod(year: shifted.year, month: shifted.month);
    });
    return Future.wait(periods.map(getMonthlySummary));
  }

  /// Pengeluaran per kategori pada [period], urut terbesar dulu.
  ///
  /// Aturan sumber sama seperti expense di [getMonthlySummary]: jurnal
  /// transaction + saving, sehingga belanja dari pocket masuk ke
  /// kategorinya masing-masing (bukan "Lainnya").
  Future<List<CategorySpending>> getExpenseByCategory(
    ReportPeriod period,
  ) async {
    final db = await _dbService.database;

    final rows = await db.rawQuery(
      '''
      SELECT
        $accountTable.${AccountKey.id} AS account_id,
        $accountTable.${AccountKey.name} AS account_name,
        SUM($journalLineTable.${JournalLineKey.debitAmount}) AS amount
      FROM $journalEntryTable
      INNER JOIN $journalLineTable
        ON $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
      INNER JOIN $accountTable
        ON $journalLineTable.${JournalLineKey.accountId} = $accountTable.${AccountKey.id}
      WHERE $journalEntryTable.${JournalEntryKey.source} IN (?, ?)
        AND $journalEntryTable.${JournalEntryKey.status} = ?
        AND ($journalEntryTable.${JournalEntryKey.entryDate} BETWEEN ? AND ?)
        AND $accountTable.${AccountKey.type} = ?
      GROUP BY $accountTable.${AccountKey.id}, $accountTable.${AccountKey.name}
      ORDER BY amount DESC
      ''',
      [
        JournalSource.transaction.value,
        JournalSource.saving.value,
        JournalStatus.posted.name,
        period.startEpoch,
        period.endEpoch,
        AccountType.expense.value,
      ],
    );

    final total = rows.fold<int>(
      0,
      (sum, row) => sum + ((row['amount'] as num?)?.toInt() ?? 0),
    );

    return rows.map((row) {
      final amount = (row['amount'] as num?)?.toInt() ?? 0;
      return CategorySpending(
        accountId: (row['account_id'] as num?)?.toInt() ?? 0,
        name: row['account_name'] as String? ?? '-',
        amount: amount,
        percentage: total == 0 ? 0 : amount / total * 100,
      );
    }).toList();
  }

  /// Pemasukan per kategori pada [period], urut terbesar dulu.
  ///
  /// Cermin [getExpenseByCategory]: jurnal transaction + saving sehingga
  /// konsisten dengan [getMonthlySummary]. Jurnal tabungan tak pernah
  /// menyentuh akun INCOME (topup/withdraw kontribusi 0), dan `setup`
  /// dikecualikan agar saldo awal tak menggelembungkan pemasukan (FIX-06).
  Future<List<CategorySpending>> getIncomeByCategory(
    ReportPeriod period,
  ) async {
    final db = await _dbService.database;

    final rows = await db.rawQuery(
      '''
      SELECT
        $accountTable.${AccountKey.id} AS account_id,
        $accountTable.${AccountKey.name} AS account_name,
        SUM($journalLineTable.${JournalLineKey.creditAmount}) AS amount
      FROM $journalEntryTable
      INNER JOIN $journalLineTable
        ON $journalLineTable.${JournalLineKey.journalEntryId} = $journalEntryTable.${JournalEntryKey.id}
      INNER JOIN $accountTable
        ON $journalLineTable.${JournalLineKey.accountId} = $accountTable.${AccountKey.id}
      WHERE $journalEntryTable.${JournalEntryKey.source} IN (?, ?)
        AND $journalEntryTable.${JournalEntryKey.status} = ?
        AND ($journalEntryTable.${JournalEntryKey.entryDate} BETWEEN ? AND ?)
        AND $accountTable.${AccountKey.type} = ?
      GROUP BY $accountTable.${AccountKey.id}, $accountTable.${AccountKey.name}
      ORDER BY amount DESC
      ''',
      [
        JournalSource.transaction.value,
        JournalSource.saving.value,
        JournalStatus.posted.name,
        period.startEpoch,
        period.endEpoch,
        AccountType.income.value,
      ],
    );

    final total = rows.fold<int>(
      0,
      (sum, row) => sum + ((row['amount'] as num?)?.toInt() ?? 0),
    );

    return rows.map((row) {
      final amount = (row['amount'] as num?)?.toInt() ?? 0;
      return CategorySpending(
        accountId: (row['account_id'] as num?)?.toInt() ?? 0,
        name: row['account_name'] as String? ?? '-',
        amount: amount,
        percentage: total == 0 ? 0 : amount / total * 100,
      );
    }).toList();
  }
}
