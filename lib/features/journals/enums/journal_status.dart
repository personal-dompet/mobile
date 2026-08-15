enum JournalStatus {
  draft,
  posted,
  voided;

  static List<String> get allValues {
    return JournalStatus.values.map((policy) => policy.name).toList();
  }
}
