import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/fixture.dart';
import 'helpers/test_app.dart';

/// Alur setup dompet awal (TC-ONB-004/005/006): preset bersaldo +
/// tanpa saldo lewat bottom sheet, lalu Lanjutkan ke Beranda.
/// Dipisah ke file sendiri karena pump-nya berat di device.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> enterField(
    WidgetTester tester,
    Key key,
    String value,
  ) async {
    await tester.enterText(
      find.descendant(of: find.byKey(key), matching: find.byType(TextField)),
      value,
    );
    await tester.pump();
  }

  group('TC-ONB-004/005/006 alur setup dompet', () {
    setUp(setupTestApp);
    tearDown(disposeFixture);

    testWidgets('preset bersaldo + tanpa saldo, lalu Lanjutkan', (
      tester,
    ) async {
      await pumpTestApp(tester);
      await settleUntil(tester, find.text('Mulai'));
      await settle(tester, 3);
      await tester.tap(find.text('Mulai'));
      await settleUntil(
        tester,
        find.text('Di mana biasanya kamu menyimpan uang?'),
      );
      await settle(tester, 3);

      // TC-ONB-004: preset Tunai + saldo 500.000.
      await tester.tap(find.text('Tunai').first);
      await settleUntil(tester, find.textContaining('Tambahkan Dompet'));
      await settle(tester, 3);
      await enterField(tester, TestKeys.addAccountName, 'Tunai');
      await enterField(tester, TestKeys.addAccountBalance, '500000');
      await tester.tap(find.byKey(TestKeys.addAccountSave));
      await settleUntil(
        tester,
        find.text('Dompet berhasil ditambahkan.'),
      );

      // Lanjutkan enabled setelah ≥1 dompet.
      var lanjutkan = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Lanjutkan'),
      );
      expect(lanjutkan.onPressed, isNotNull);

      // TC-ONB-005: dompet kedua tanpa saldo awal.
      await tester.tap(find.text('Tambah dompet'));
      await settleUntil(tester, find.byKey(TestKeys.addAccountName));
      await settle(tester, 3);
      await tester.tap(find.byKey(TestKeys.addAccountType));
      await settle(tester, 3);
      await tester.tap(find.text('Rekening Bank').last);
      await settleUntil(tester, find.text('Tambah dompet'));
      await settle(tester, 3);
      await enterField(tester, TestKeys.addAccountName, 'BCA');
      await tester.tap(find.byKey(TestKeys.addAccountSave));
      await settleUntil(
        tester,
        find.text('Dompet berhasil ditambahkan.'),
      );

      // TC-ONB-006: tunggu snackbar hilang lalu Lanjutkan → Beranda.
      await settleGone(tester, find.text('Dompet berhasil ditambahkan.'));
      await tester.tap(find.text('Lanjutkan'));
      await settleUntil(tester, find.text('Total Uang'));
    });
  });

}
