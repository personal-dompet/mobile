/// Thrown when a balance adjustment would change nothing
/// (new amount == current balance, FIX-08 repo-guard).
///
/// Callers must not insert a journal for this case; the UI pops back with
/// an info snackbar instead (final styling lands with FIX-15).
class NoOpBalanceAdjustmentException implements Exception {
  const NoOpBalanceAdjustmentException();

  @override
  String toString() => 'Tidak ada perubahan saldo';
}
