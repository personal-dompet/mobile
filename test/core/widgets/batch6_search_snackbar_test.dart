import 'package:dompet_app/core/widgets/dompet_empty_search.dart';
import 'package:dompet_app/core/widgets/dompet_snackbar.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

// B6 (FIX-13 + FIX-15): search clear global + snackbar atas.
void main() {
  Future<void> pumpSearch(
    WidgetTester tester,
    FormControl<String> control, {
    VoidCallback? onClear,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DompetTextField(
            formControl: control,
            placeholder: 'Cari...',
            textInputAction: .search,
            clearable: true,
            onClear: onClear,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('FIX-13: kosong/null -> tombol clear tidak muncul', (
    tester,
  ) async {
    await pumpSearch(tester, FormControl<String>());
    expect(find.byIcon(Icons.clear), findsNothing);

    await pumpSearch(tester, FormControl<String>(value: ''));
    expect(find.byIcon(Icons.clear), findsNothing);
  });

  testWidgets('FIX-13: >=1 char -> clear muncul, tap reset + onClear', (
    tester,
  ) async {
    // Catatan: `reset()` kembalikan nilai default control. Di produksi
    // semua control search dibuat tanpa nilai awal (null), jadi reset = null.
    final control = FormControl<String>();
    control.updateValue('dom');
    var cleared = false;
    await pumpSearch(tester, control, onClear: () => cleared = true);
    expect(find.byIcon(Icons.clear), findsOneWidget);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    expect(control.value, isNull);
    expect(cleared, isTrue);
    // Tombol hilang lagi setelah reset.
    expect(find.byIcon(Icons.clear), findsNothing);
  });

  testWidgets('FIX-13: ketik lalu hapus semua -> clear hilang live', (
    tester,
  ) async {
    final control = FormControl<String>();
    await pumpSearch(tester, control);

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    expect(find.byIcon(Icons.clear), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    expect(find.byIcon(Icons.clear), findsNothing);
  });

  testWidgets('FIX-13: empty search render judul + reset memanggil onReset', (
    tester,
  ) async {
    var reset = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DompetEmptySearch(
            subject: 'dompet',
            onReset: () => reset = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tidak ada dompet cocok.'), findsOneWidget);
    expect(find.text('Coba kata kunci lain.'), findsOneWidget);

    await tester.tap(find.text('Reset pencarian'));
    await tester.pump();
    expect(reset, isTrue);
  });

  testWidgets('FIX-15: snackbar material standar, warna beda per tipe', (
    tester,
  ) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(home: Builder(builder: (c) => Scaffold(body: Text('x')))),
    );
    await tester.pumpAndSettle();
    // Ambil context di dalam MaterialApp.
    ctx = tester.element(find.text('x'));

    DompetSnackbar build(SnackBarType t) =>
        DompetSnackbar(ctx, message: 'm', snackBarType: t);

    final success = build(.success);
    final error = build(.error);
    final info = build(.info);

    final colors = Theme.of(ctx).colorScheme;
    for (final snack in [success, error, info]) {
      // Material standar: fixed bawah full-width (tanpa margin), jadi
      // tidak pernah memicu assertion "Floating SnackBar presented
      // off screen." di ShellPage. Default behavior = null = fixed.
      expect(snack.behavior ?? SnackBarBehavior.fixed, SnackBarBehavior.fixed);
      expect(snack.margin, isNull);
    }

    // Background netral tunggal untuk semua tipe.
    expect(success.backgroundColor, colors.surfaceContainerHigh);
    expect(error.backgroundColor, colors.surfaceContainerHigh);
    expect(info.backgroundColor, colors.surfaceContainerHigh);

    (Color, Color) contentColors(DompetSnackbar s) {
      final row = s.content as Row;
      final icon = row.children.first as Icon;
      final text = (row.children.last as Expanded).child as Text;
      return (icon.color!, text.style!.color!);
    }

    // Pembeda hanya warna teks + ikon per tipe (seperti versi terbaru).
    expect(contentColors(success), (colors.tertiary, colors.tertiary));
    expect(contentColors(error), (colors.error, colors.error));
    expect(contentColors(info), (colors.primary, colors.primary));
  });
}
