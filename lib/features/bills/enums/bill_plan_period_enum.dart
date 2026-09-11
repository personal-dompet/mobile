enum BillPlanPeriodEnum {
  monthly,
  yearly;

  static List<String> get allValues {
    return BillPlanPeriodEnum.values.map((policy) => policy.name).toList();
  }
}
