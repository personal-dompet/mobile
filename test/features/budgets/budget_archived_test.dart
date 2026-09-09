import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/budgets/models/budget_filter.dart';
import 'package:dompet_app/features/budgets/repositories/budget_plan_repository.dart';
import 'package:dompet_app/features/budgets/repositories/budget_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/repositories/transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

/// FIX-12 (IMP-8 + IMP-9): anggaran kategori diarsip + list rencana.
///
/// Skenario Hobi: kategori expense + rencana + anggaran aktif, lalu kategori
/// diarsipkan. Anggaran tetap ada dan terhitung, hanya ditandai.
void main() {
  late DbService dbService;

  setUp(() async {
    dbService = await createTestDbService();
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  Future<int> createHobiCategory() async {
    final form = CategoryForm();
    form.nameControl.updateValue('Hobi');
    form.typeControl.updateValue(AccountType.expense);
    final account = await CategoryRepository(
      dbService,
    ).createCategory(form: form);
    return account.id;
  }

  group('FIX-12 anggaran kategori diarsip', () {
    test('budget aktif Hobi tetap ada + flag arsip setelah diarsipkan',
        () async {
      final budgets = BudgetRepository(dbService);
      final plans = BudgetPlanRepository(dbService);
      final accounts = AccountRepository(dbService);

      final hobiId = await createHobiCategory();
      await plans.upsert(accountId: hobiId, amount: 500000, note: null);
      await budgets.createBudget(
        accountId: hobiId,
        amount: 500000,
        periode: DateTime.now(),
      );

      final before = await budgets.getBudgets(const BudgetFilter());
      expect(before.map((b) => b.accountId), contains(hobiId));
      expect(
        before.firstWhere((b) => b.accountId == hobiId).categoryArchived,
        isFalse,
      );

      await accounts.archiveAccount(hobiId);

      final after = await budgets.getBudgets(const BudgetFilter());
      expect(after.map((b) => b.accountId), contains(hobiId));
      expect(
        after.firstWhere((b) => b.accountId == hobiId).categoryArchived,
        isTrue,
      );

      final detail = await budgets.getBudgetById(
        after.firstWhere((b) => b.accountId == hobiId).id,
      );
      expect(detail?.categoryArchived, isTrue);

      final active = await budgets.getActiveBudget(hobiId);
      expect(active, isNotNull);
      expect(active?.categoryArchived, isTrue);
    });

    test('transaksi baru ke kategori arsip ditolak lembut', () async {
      final budgets = BudgetRepository(dbService);
      final accounts = AccountRepository(dbService);
      final transactions = TransactionRepository(dbService);

      final hobiId = await createHobiCategory();
      await budgets.createBudget(
        accountId: hobiId,
        amount: 500000,
        periode: DateTime.now(),
      );
      await accounts.archiveAccount(hobiId);

      final form = TransactionForm();
      form.assetForm.idControl.updateValue(1);
      form.assetForm.nameControl.updateValue('Tunai');
      form.assetForm.balanceControl.updateValue(1000000);
      form.categories.first.categoryIdControl.updateValue(hobiId);
      form.categories.first.amountControl.updateValue(50000);
      form.totalAmountControl.updateValue(50000);
      // Beri jeda agar listener total reactive_forms selesai sinkron.
      await Future.delayed(const Duration(milliseconds: 50));

      await expectLater(
        transactions.recordTransaction(
          form: form,
          type: TransactionType.expense,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('diarsipkan'),
          ),
        ),
      );
    });
  });

  group('FIX-12 list rencana anggaran (IMP-9)', () {
    test('getPlansWithCategories sembunyikan kategori arsip', () async {
      final plans = BudgetPlanRepository(dbService);
      final accounts = AccountRepository(dbService);

      final hobiId = await createHobiCategory();
      await plans.upsert(accountId: hobiId, amount: 300000, note: 'Mainan');

      var items = await plans.getPlansWithCategories();
      expect(items.map((e) => e.category.name), contains('Hobi'));
      expect(
        items.firstWhere((e) => e.category.name == 'Hobi').category.isDeleted,
        isFalse,
      );

      await accounts.archiveAccount(hobiId);

      // TC2-BGT-002: rencana berkategori arsip disembunyikan dari list.
      items = await plans.getPlansWithCategories();
      expect(items.map((e) => e.category.name), isNot(contains('Hobi')));
    });
  });
}
