enum BudgetEndType {
  indefinitely('Tidak ditentukan'),
  onDate('Tanggal tertentu'),
  afterN('Setelah "x" kali periode');

  final String label;
  const BudgetEndType(this.label);
}
