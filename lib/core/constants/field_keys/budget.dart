abstract class BudgetKey {
  static const id = 'id';
  static const accountId = 'account_id';
  static const periodStart = 'period_start';
  static const periodEnd = 'period_end';
  static const budgetedAmount = 'budgeted_amount';
  static const carryAmount = 'carry_amount';
  static const leftover = 'leftover';
  static const closedAt = 'closed_at';
  static const createdAt = 'created_at';

  // Relasi
  static const accountName = 'account_name';
  static const actualSpend = 'actual_spend';

  /// FIX-12: bukan kolom DB — diisi repo dari accounts.is_deleted agar
  /// badge arsip tampil tanpa migrasi view.
  static const categoryArchived = 'category_archived';
}
