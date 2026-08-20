class AccountBudgetStatus {
  const AccountBudgetStatus({
    required this.activeBudgetAccountIds,
    required this.planAccountIds,
  });

  final Set<int> activeBudgetAccountIds;
  final Set<int> planAccountIds;
}