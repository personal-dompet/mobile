import 'package:dompet_app/features/transactions/effective_balance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('computeEffectiveBalance (DOCUMENT.md: saldo setelah efek transaksi '
      'lama dibalik terlebih dahulu)', () {
    test('not editing returns the current balance', () {
      expect(computeEffectiveBalance(currentBalance: 10000, type: .expense),
          10000);
      expect(
        computeEffectiveBalance(currentBalance: 10000, type: .income),
        10000,
      );
    });

    test('expense edit on the same wallet adds the previous amount back',
        () {
      expect(
        computeEffectiveBalance(
          currentBalance: 0,
          type: .expense,
          previousAmount: 50000,
          previousAssetId: 1,
          currentAssetId: 1,
        ),
        50000,
      );
    });

    test('income edit on the same wallet subtracts the previous amount', () {
      expect(
        computeEffectiveBalance(
          currentBalance: 100000,
          type: .income,
          previousAmount: 30000,
          previousAssetId: 1,
          currentAssetId: 1,
        ),
        70000,
      );
    });

    test('edit on a different wallet ignores the previous amount (no reversal '
        'applies to the newly selected wallet)', () {
      expect(
        computeEffectiveBalance(
          currentBalance: 20000,
          type: .expense,
          previousAmount: 50000,
          previousAssetId: 1,
          currentAssetId: 2,
        ),
        20000,
      );
    });

    test('validates against effective balance, not the naive current balance',
        () {
      // Wallet currently at 60.000; the edited expense was 50.000.
      // Effective balance = 60.000 + 50.000 = 110.000.
      final effective = computeEffectiveBalance(
        currentBalance: 60000,
        type: .expense,
        previousAmount: 50000,
        previousAssetId: 1,
        currentAssetId: 1,
      );

      expect(effective, 110000);

      // New amount 70.000 fits within effective balance (no warning)...
      expect(70000 > effective, isFalse);
      // ...but would exceed the naive current balance (false warning).
      expect(70000 > 60000, isTrue);
    });

    test('an edit that would overdraw is detected on effective balance', () {
      // Wallet at 0 after the old expense of 50.000; editing to 60.000.
      final effective = computeEffectiveBalance(
        currentBalance: 0,
        type: .expense,
        previousAmount: 50000,
        previousAssetId: 1,
        currentAssetId: 1,
      );

      expect(effective, 50000);
      expect(60000 > effective, isTrue,
          reason: 'overdraw against effective balance must be detected');
    });
  });
}
