import 'package:dompet_app/core/database/db_service.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:dompet_app/features/assets/repositories/asset_repository.dart';
import 'package:dompet_app/features/categories/forms/category_form.dart';
import 'package:dompet_app/features/categories/repositories/category_repository.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:dompet_app/features/transactions/forms/transaction_form.dart';
import 'package:dompet_app/features/transactions/forms/transfer_form.dart';
import 'package:dompet_app/features/transactions/repositories/transaction_repository.dart';
import 'package:dompet_app/features/transactions/repositories/transfer_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_db.dart';

/// FIX-14 (IMP-2/IMP-3): halaman arsip dompet + kategori.
///
/// Repo berlapis DB asli (tak mock): getArchived/restore + guard
/// tolak dompet arsip di transaksi/transfer.
void main() {
  late DbService dbService;

  setUp(() async {
    dbService = await createTestDbService();
  });

  tearDown(() async {
    await disposeTestDbService(dbService);
  });

  const assetFilter = AccountFilter(
    isSystem: false,
    isLiqid: true,
    type: AccountType.asset,
  );

  Future<int> createAsset(String name) async {
    final form = AssetForm()
      ..nameControl.updateValue(name)
      ..codeControl.updateValue(AccountPreset.cash.code);
    final account = await AssetRepository(dbService).createAsset(form);
    return account.id;
  }

  group('FIX-14 arsip dompet', () {
    test('arsip pindah akun aktif -> arsip, pulihkan kembalikan', () async {
      final accounts = AccountRepository(dbService);
      await createAsset('Dompet Arsip A');

      final activeBefore = await accounts.getAccounts(filter: assetFilter);
      expect(activeBefore, isNotEmpty);
      final archivedBefore = await accounts.getArchivedAccounts(
        filter: assetFilter,
      );
      expect(
        archivedBefore.map((a) => a.id),
        isNot(contains(activeBefore.first.id)),
      );

      await accounts.archiveAccount(activeBefore.first.id);

      final activeAfter = await accounts.getAccounts(filter: assetFilter);
      expect(
        activeAfter.map((a) => a.id),
        isNot(contains(activeBefore.first.id)),
      );
      final archivedAfter = await accounts.getArchivedAccounts(
        filter: assetFilter,
      );
      expect(
        archivedAfter.map((a) => a.id),
        contains(activeBefore.first.id),
      );

      await accounts.unarchiveAccount(activeBefore.first.id);

      final activeRestored = await accounts.getAccounts(filter: assetFilter);
      expect(
        activeRestored.map((a) => a.id),
        contains(activeBefore.first.id),
      );
      final archivedRestored = await accounts.getArchivedAccounts(
        filter: assetFilter,
      );
      expect(
        archivedRestored.map((a) => a.id),
        isNot(contains(activeBefore.first.id)),
      );
    });

    test('transaksi baru ke dompet arsip ditolak', () async {
      final accounts = AccountRepository(dbService);
      final transactions = TransactionRepository(dbService);

      final assetId = await createAsset('Dompet Arsip T');
      await accounts.archiveAccount(assetId);

      final form = TransactionForm();
      form.assetForm.idControl.updateValue(assetId);
      form.assetForm.nameControl.updateValue('Dompet Arsip T');
      form.assetForm.balanceControl.updateValue(1000000);
      form.categories.first.amountControl.updateValue(50000);
      form.totalAmountControl.updateValue(50000);
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

    test('transfer dari dompet arsip ditolak', () async {
      final accounts = AccountRepository(dbService);
      final transfers = TransferRepository(dbService);

      final sourceId = await createAsset('Dompet Arsip S');
      final destId = await createAsset('Dompet Arsip D');
      await accounts.archiveAccount(sourceId);

      final form = TransferForm();
      form.sourceForm.idControl.updateValue(sourceId);
      form.sourceForm.nameControl.updateValue('Dompet Arsip S');
      form.destinationForm.idControl.updateValue(destId);
      form.destinationForm.nameControl.updateValue('Dompet Arsip D');
      form.amountControl.updateValue(10000);

      await expectLater(
        transfers.transferBalance(form: form),
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

  group('FIX-14 arsip kategori per tipe', () {
    Future<int> createCategory(String name, AccountType type) async {
      final form = CategoryForm();
      form.nameControl.updateValue(name);
      form.typeControl.updateValue(type);
      final account = await CategoryRepository(
        dbService,
      ).createCategory(form: form);
      return account.id;
    }

    test('kategori arsip muncul di filter tipenya, tak di tipe lain',
        () async {
      final accounts = AccountRepository(dbService);

      final expenseId = await createCategory('ArsipExp', AccountType.expense);
      final incomeId = await createCategory('ArsipInc', AccountType.income);
      await accounts.archiveAccount(expenseId);

      final archivedExpense = await accounts.getArchivedAccounts(
        filter: const AccountFilter(type: AccountType.expense),
      );
      expect(archivedExpense.map((a) => a.id), contains(expenseId));

      final archivedIncome = await accounts.getArchivedAccounts(
        filter: const AccountFilter(type: AccountType.income),
      );
      expect(archivedIncome.map((a) => a.id), isNot(contains(expenseId)));
      expect(archivedIncome.map((a) => a.id), isNot(contains(incomeId)));

      // List aktif eksklusikan yang diarsip.
      final activeExpense = await accounts.getAccounts(
        filter: const AccountFilter(type: AccountType.expense),
      );
      expect(activeExpense.map((a) => a.id), isNot(contains(expenseId)));
    });
  });
}
