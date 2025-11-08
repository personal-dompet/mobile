enum CreateFrom {
  transaction,
  transferSource,
  transferDestination;

  static CreateFrom? fromName(String name) {
    try {
      return CreateFrom.values.firstWhere(
        (status) => status.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
