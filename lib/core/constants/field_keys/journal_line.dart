abstract class JournalLineKey {
  static const id = 'id';
  static const journalEntryId = 'journal_entry_id';
  static const accountId = 'account_id';
  static const debitAmount = 'debit_amount';
  static const creditAmount = 'credit_amount';
  static const note = 'note';
  static const lineOrder = 'line_order';

  /// Relasi ke akun
  static const account = 'account';

  /// Key relasi
  static const accountName = 'account_name';

  /// Key relasi
  static const accountType = 'account_type';

  /// Key relasi
  static const accountBalance = 'account_balance';

  /// Key relasi
  static const accountNormalBalance = 'account_normal_balance';
}
