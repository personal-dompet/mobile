enum TransactionType {
  income('INCOME', 'Income'),
  expense('EXPENSE', 'Expense');

  final String value;
  final String label;

  const TransactionType(this.value, this.label);

  factory TransactionType.fromValue(String value) =>
      TransactionType.values.firstWhere((e) => e.value == value);
}
