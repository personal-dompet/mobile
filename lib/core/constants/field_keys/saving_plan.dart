abstract class SavingPlanKey {
  static const id = 'id';
  static const accountId = 'account_id';
  static const targetAmount = 'target_amount';
  static const targetDate = 'target_date';
  static const note = 'note';
  static const status = 'status';
  static const isDeleted = 'is_deleted';
  static const createdAt = 'created_at';

  // Relasi (dari join accounts + v_account_balances, tidak ada di schema tabel).
  static const accountName = 'account_name';
  static const accountCode = 'account_code';
  static const iconCode = 'icon_code';
  static const balance = 'balance';
  static const progress = 'progress';
}
