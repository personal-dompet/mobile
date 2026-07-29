enum PeriodicTime {
  all('Semua'),
  today('Hari ini'),
  last7Days('7 hari terakhir'),
  last30Days('30 hari terakhir'),
  thisMonth('Bulan ini');

  final String label;
  const PeriodicTime(this.label);

  static List<PeriodicTime> get options => [
    .all,
    .today,
    .last7Days,
    .last30Days,
    .thisMonth,
  ];
}
