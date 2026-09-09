import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/transactions/cubits/balance_adjustment_cubit.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/exceptions/no_op_balance_adjustment_exception.dart';
import 'package:dompet_app/features/transactions/forms/balance_adjustment_form.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:dompet_app/features/transactions/repositories/balance_adjustment_repository.dart';
import 'package:dompet_app/features/transactions/repositories/transaction_repository.dart';
import 'package:dompet_app/features/transactions/repositories/transfer_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

/// FIX-01 repo guards + FIX-08 no-op guard, tested against a real
/// in-memory database (never mocked).
void main() {
  late DbService dbService;

  setUp(() async {
    dbService = await createTestDbService();
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  group('FIX-01 repo guards: zero nominal never reaches the journal', () {
    test('recordTransaction rejects 0 (TC-IN-005/TC-OUT-005)', () async {
      final repository = TransactionRepository(dbService);
      final form = TransactionForm();
      form.categories.first.amountControl.updateValue(0);

      await expectLater(
        repository.recordTransaction(
          form: form,
          type: TransactionType.income,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Nominal harus lebih dari 0'),
          ),
        ),
      );
    });

    test('updateTransaction rejects 0 in edit flow', () async {
      final repository = TransactionRepository(dbService);
      final form = TransactionForm();
      form.categories.first.amountControl.updateValue(0);

      await expectLater(
        repository.updateTransaction(
          id: 1,
          form: form,
          type: TransactionType.expense,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Nominal harus lebih dari 0'),
          ),
        ),
      );
    });

    test('transferBalance and updateTransfer reject 0 (TC-TRF-004)', () async {
      final repository = TransferRepository(dbService);
      final form = TransferForm();
      form.amountControl.updateValue(0);

      await expectLater(
        repository.transferBalance(form: form),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Nominal harus lebih dari 0'),
          ),
        ),
      );
      await expectLater(
        repository.updateTransfer(form: form, id: 1),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Nominal harus lebih dari 0'),
          ),
        ),
      );
    });

    test('createBudget and plan upsert reject 0 (TC-BGT-005)', () async {
      final budgets = BudgetRepository(dbService);
      final plans = BudgetPlanRepository(dbService);

      await expectLater(
        budgets.createBudget(
          accountId: 1,
          amount: 0,
          periode: DateTime.now(),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Nominal harus lebih dari 0'),
          ),
        ),
      );
      await expectLater(
        plans.upsert(accountId: 1, amount: 0, note: null),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Nominal harus lebih dari 0'),
          ),
        ),
      );
    });
  });

  group('FIX-08 repo-guard: adjustment with zero difference writes no journal',
      () {
    Future<BalanceAdjustmentForm> noOpForm() async {
      final assets = AssetRepository(dbService);
      final account = await assets.createAsset(
        AssetForm()
          ..nameControl.updateValue('Dompet Tes')
          ..codeControl.updateValue(AccountPreset.cash.code),
      );
      final form = BalanceAdjustmentForm();
      form.accountControl.updateValue(account);
      // Fresh wallet balance is 0; adjusting to 0 changes nothing.
      form.amountControl.updateValue(0);
      return form;
    }

    test('adjustBalance throws NoOp instead of inserting a journal', () async {
      final repository = BalanceAdjustmentRepository(dbService);

      await expectLater(
        repository.adjustBalance(form: await noOpForm()),
        throwsA(isA<NoOpBalanceAdjustmentException>()),
      );
    });

    test('cubit reports a calm success so the page pops back', () async {
      final cubit = BalanceAdjustmentCubit(
        BalanceAdjustmentRepository(dbService),
      );
      addTearDown(cubit.close);

      await cubit.adjustBalance(await noOpForm());

      // Freezed union subtypes are private; assert on the value string.
      expect(
        cubit.state.toString(),
        'ActionState.success(message: Tidak ada perubahan saldo)',
      );
    });

    test('a real difference still adjusts (guard does not over-block)',
        () async {
      final repository = BalanceAdjustmentRepository(dbService);
      final assets = AssetRepository(dbService);
      final account = await assets.createAsset(
        AssetForm()
          ..nameControl.updateValue('Dompet Tes 2')
          ..codeControl.updateValue(AccountPreset.cash.code),
      );
      final form = BalanceAdjustmentForm();
      form.accountControl.updateValue(account);
      form.amountControl.updateValue(50000);

      await repository.adjustBalance(form: form);
    });
  });
}
