enum TransactionType {
  income('INCOME'),
  expense('EXPENSE');

  final String value;

  const TransactionType(this.value);

  factory TransactionType.fromValue(String value) =>
      TransactionType.values.firstWhere((e) => e.value == value);
}
