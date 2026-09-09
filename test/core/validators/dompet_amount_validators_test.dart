import 'package:dompet_app/features/budgets/forms/budget_plan_form.dart';
import 'package:dompet_app/features/savings/forms/saving_allocation_form.dart';
import 'package:dompet_app/features/savings/forms/saving_plan_form.dart';
import 'package:dompet_app/features/savings/forms/saving_spend_form.dart';
import 'package:dompet_app/features/transactions/forms/balance_adjustment_form.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// FIX-01 (TC-IN-005, TC-OUT-005, TC-TRF-004, TC-BGT-005):
/// every nominal money field rejects 0/null and accepts 1.
void main() {
  group('DompetAmountValidators.min1 applied to all nominal forms', () {
    test('TransactionCategoryForm rejects 0 and null, accepts 1', () {
      final form = TransactionForm();
      final amount = form.categories.first.amountControl;

      amount.updateValue(0);
      expect(amount.invalid, isTrue);
      expect(amount.hasError(ValidationMessage.min), isTrue);

      amount.updateValue(null);
      expect(amount.invalid, isTrue);

      amount.updateValue(1);
      expect(amount.valid, isTrue);
    });

    test('TransferForm rejects 0 and null, accepts 1', () {
      final form = TransferForm();

      form.amountControl.updateValue(0);
      expect(form.amountControl.invalid, isTrue);
      expect(form.amountControl.hasError(ValidationMessage.min), isTrue);

      form.amountControl.updateValue(null);
      expect(form.amountControl.invalid, isTrue);

      form.amountControl.updateValue(1);
      expect(form.amountControl.valid, isTrue);
    });

    test('BudgetPlanForm rejects 0, accepts 1 (TC-BGT-005)', () {
      final form = BudgetPlanForm();

      form.amountControl.updateValue(0);
      expect(form.amountControl.invalid, isTrue);

      form.amountControl.updateValue(1);
      expect(form.amountControl.valid, isTrue);
    });

    test('SavingAllocationForm and SavingSpendForm reject 0, accept 1', () {
      final allocation = SavingAllocationForm();
      allocation.amountControl.updateValue(0);
      expect(allocation.amountControl.invalid, isTrue);
      allocation.amountControl.updateValue(1);
      expect(allocation.amountControl.valid, isTrue);

      final spend = SavingSpendForm();
      spend.amountControl.updateValue(0);
      expect(spend.amountControl.invalid, isTrue);
      spend.amountControl.updateValue(1);
      expect(spend.amountControl.valid, isTrue);
    });

    test('SavingPlanForm target is optional but still min 1 when filled', () {
      final form = SavingPlanForm();

      expect(form.targetAmountControl.valid, isTrue);

      form.targetAmountControl.updateValue(0);
      expect(form.targetAmountControl.invalid, isTrue);

      form.targetAmountControl.updateValue(100000);
      expect(form.targetAmountControl.valid, isTrue);
    });

    test('BalanceAdjustmentForm amount stays exempt (new balance may be 0)',
        () {
      // The new balance is not a nominal: 0 is legitimate.
      // Its no-op guard lives in the repository (FIX-08).
      final form = BalanceAdjustmentForm();
      form.amountControl.updateValue(0);
      expect(form.amountControl.valid, isTrue);
    });
  });
}
