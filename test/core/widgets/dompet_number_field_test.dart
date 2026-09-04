import 'package:dompet_app/core/widgets/dompet_number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  Future<void> pumpField(
    WidgetTester tester,
    FormControl<int> control,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DompetNumberField(formControl: control)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('null awal -> ketik nominal -> control terisi', (tester) async {
    final control = FormControl<int>();
    await pumpField(tester, control);
    expect(control.value, isNull);

    await tester.enterText(find.byType(TextFormField), '10000000');
    await tester.pump();

    expect(control.value, 10000000);
  });

  testWidgets('ada nilai awal -> ubah -> control ikut berubah', (tester) async {
    final control = FormControl<int>(value: 5000000);
    await pumpField(tester, control);

    await tester.enterText(find.byType(TextFormField), '10000000');
    await tester.pump();

    expect(control.value, 10000000);
  });

  testWidgets('hapus semua -> control kembali null', (tester) async {
    final control = FormControl<int>(value: 5000000);
    await pumpField(tester, control);

    await tester.enterText(find.byType(TextFormField), '');
    await tester.pump();

    expect(control.value, isNull);
  });
}
