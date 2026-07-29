abstract class JournalEntryKey {
  static const id = 'id';
  static const entryDate = 'entry_date';
  static const description = 'description';
  static const reference = 'reference';
  static const source = 'source';
  static const sourceId = 'source_id';
  static const status = 'status';
  static const metadata = 'metadata';
  static const createdAt = 'created_at';

  /// Relasi ke journal line
  static const lines = 'lines';

  /// Untuk relasi, tidak ada di schema db. Menggambarkan nominal debit pada journal line utama.
  static const debitAmount = 'debit_amount';

  /// Untuk relasi, tidak ada di schema db. Menggambarkan nominal debit pada journal line utama.
  static const creditAmount = 'credit_amount';

  /// Untuk relasi, tidak ada di schema db. Menggambarkan nama akun pada journal line utama.
  static const accountName = 'account_name';

  /// Untuk relasi, tidak ada di schema db. Menggambarkan nama akun pada journal line tujuan transfer. Ini khusus untuk jurnal transfer.
  static const accountDestinationName = 'account_destination_name';

  /// Untuk relasi, tidak ada di schema db. Menggambarkan jenis akun pada journal line utama.
  static const accountType = 'account_type';

  /// Untuk relasi, tidak ada di schema db. Menggambarkan banyaknya journal line.
  static const linesCount = 'lines_count';

  /// Untuk relasi, akun asset dalam jurnal ini
  static const assetAccounts = 'asset_accounts';
}
