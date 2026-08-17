import 'package:dompet_app/core/widgets/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Calculator chained operations', () {
    test('100 + 100 + 100 + 100 = 400', () {
      final calc = Calculator();
      for (final v in ['1', '0', '0', '+', '1', '0', '0', '+', '1', '0', '0', '+', '1', '0', '0', '=']) {
        calc.input(v);
      }
      expect(calc.display, '400');
      expect(calc.canApply, isTrue);
    });

    test('100 × 2 + 50 = 250', () {
      final calc = Calculator();
      for (final v in ['1', '0', '0', '×', '2', '+', '5', '0', '=']) {
        calc.input(v);
      }
      expect(calc.display, '250');
    });

    test('100 + 200 × 5 = 1500 (kiri ke kanan)', () {
      final calc = Calculator();
      for (final v in ['1', '0', '0', '+', '2', '0', '0', '×', '5', '=']) {
        calc.input(v);
      }
      expect(calc.display, '1.500');
    });

    test('100 ÷ 4 ÷ 5 = 5', () {
      final calc = Calculator();
      for (final v in ['1', '0', '0', '÷', '4', '÷', '5', '=']) {
        calc.input(v);
      }
      expect(calc.display, '5');
    });

    test('decimal percentage 10.000.000 × 2,5% = 250.000', () {
      final calc = Calculator();
      for (final v in ['1', '0', '0', '0', '0', '0', '0', '0', '×', '2', ',', '5', '%', '=']) {
        calc.input(v);
      }
      expect(calc.display, '250.000');
      expect(calc.canApply, isTrue);
    });
  });

  group('Terapkan state', () {
    test('disable after operator, enable after =', () {
      final calc = Calculator();
      calc.input('2');
      calc.input('0');
      calc.input('0');
      calc.input('0');
      expect(calc.canApply, isTrue);

      calc.input('+');
      expect(calc.canApply, isFalse);

      calc.input('2');
      calc.input('0');
      expect(calc.canApply, isFalse);

      calc.input('=');
      expect(calc.canApply, isTrue);
      expect(calc.display, '2.020');
    });

    test('disable for zero and negative', () {
      final calc = Calculator();
      expect(calc.canApply, isFalse);
      calc.input('0');
      expect(calc.canApply, isFalse);
      calc.input('5');
      calc.input('-');
      calc.input('5');
      expect(calc.canApply, isFalse);
      calc.input('=');
      expect(calc.canApply, isFalse);
    });

    test('200 × 15% = 30 (button disabled until =)', () {
      final calc = Calculator();
      calc.input('2');
      calc.input('0');
      calc.input('0');
      calc.input('×');
      calc.input('1');
      calc.input('5');
      calc.input('%');
      expect(calc.canApply, isFalse);
      expect(calc.display, '15%');
      calc.input('=');
      expect(calc.canApply, isTrue);
      expect(calc.display, '30');
    });

    test('200.000 + 2,5% = 205.000 (persen dari base)', () {
      final calc = Calculator();
      for (final v in ['2', '0', '0', '0', '0', '0', '+', '2', ',', '5', '%', '=']) {
        calc.input(v);
      }
      expect(calc.display, '205.000');
    });
  });

  group('Hasil berantai (intermediate result)', () {
    test('hasil muncul saat operator ke-2 ditekan', () {
      final calc = Calculator();
      for (final v in ['1', '0', '0', '+']) {
        calc.input(v);
      }
      expect(calc.display, '100');

      for (final v in ['2', '0', '0', '×']) {
        calc.input(v);
      }
      expect(calc.display, '300');
      expect(calc.canApply, isFalse);

      for (final v in ['5', '=']) {
        calc.input(v);
      }
      expect(calc.display, '1.500');
      expect(calc.canApply, isTrue);
    });

    test('operator setelah = melanjutkan dari hasil', () {
      final calc = Calculator();
      for (final v in ['1', '0', '0', '+', '2', '0', '0', '=']) {
        calc.input(v);
      }
      expect(calc.display, '300');

      for (final v in ['+', '5', '0', '=']) {
        calc.input(v);
      }
      expect(calc.display, '350');
    });

    test('% setelah = tidak mengunci Terapkan', () {
      final calc = Calculator();
      for (final v in ['1', '0', '0', '=']) {
        calc.input(v);
      }
      expect(calc.canApply, isTrue);
      calc.input('%');
      expect(calc.canApply, isTrue);
      expect(calc.display, '100');
    });
  });
}
