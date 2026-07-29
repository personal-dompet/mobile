enum BudgetFrequency {
  daily('Harian'),
  weekly('Mingguan'),
  monthly('Bulanan'),
  annual('Tahunan');

  final String label;
  const BudgetFrequency(this.label);
}
