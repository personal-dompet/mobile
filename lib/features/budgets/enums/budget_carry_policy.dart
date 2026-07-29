enum BudgetCarryPolicy {
  lapse('Ulangi dari awal'),
  carryForward('Lanjutkan');

  final String label;
  const BudgetCarryPolicy(this.label);
}
