import 'package:dompet_app/core/utils/format_currency.dart';
import 'package:flutter/material.dart';

class Calculator {
  String display = '0';
  final List<String> _expression = []; // Token angka & operator yang ditunda
  bool _shouldResetDisplay = false;
  bool _displayCommitted = false; // Apakah display sudah masuk ke _expression
  bool _operationFinalized = true;

  /// Ekspresi tertunda yang tampil di atas display (mis. "100 +", "300 ×").
  /// Hanya di-set saat tombol operasi (+ - × ÷ =) ditekan.
  String? _expressionDisplay;

  /// Info ekspresi yang sedang/telah dikerjakan di atas display, atau `null`
  /// bila belum ada operasi yang dimulai.
  String? get expressionDisplay => _expressionDisplay;

  Calculator({int? initialValue}) {
    if (initialValue != null && initialValue != 0) {
      display = _formatNumber(initialValue.toString());
    }
  }

  /// Nilai bulat dari display saat ini (hasil desimal dibulatkan).
  int get intValue => double.tryParse(_toNumberString(display))?.round() ?? 0;

  /// Konversi display ke string angka yang bisa di-parse (titik ribuan dihapus, koma desimal diubah ke titik)
  String _toNumberString(String formatted) {
    return formatted.replaceAll('.', '').replaceAll(',', '.');
  }

  /// Format angka dengan separator ribuan (titik) dan desimal (koma)
  String _formatNumber(String numberStr) {
    // Pisahkan bagian bulat dan desimal
    if (!numberStr.contains('.')) {
      // Hanya angka bulat
      return _addThousandsSeparator(numberStr);
    }

    final parts = numberStr.split('.');
    final integerPart = _addThousandsSeparator(parts[0]);
    final decimalPart = parts[1];

    return '$integerPart,$decimalPart';
  }

  /// Check apakah ada operasi yang belum diselesaikan dengan '='
  bool get hasOngoingOperation => !_operationFinalized;

  /// Nilai display dapat diterapkan saat tidak ada operasi yang berjalan
  /// dan display berisi nilai yang valid (bukan nol/negatif/Error).
  bool get canApply {
    if (hasOngoingOperation) return false;
    final value = double.tryParse(_toNumberString(display));
    return value != null && value > 0;
  }

  /// Format hasil perhitungan tanpa pembulatan di tengah proses.
  /// Desimal hanya dibulatkan saat diterapkan (lihat [intValue]).
  String _formatResult(double result) {
    return result == result.toInt()
        ? result.toInt().toString()
        : result
              .toStringAsFixed(8)
              .replaceAll(RegExp(r'0+$'), '')
              .replaceAll(RegExp(r'\.$'), '');
  }

  /// Tambahkan separator titik setiap 3 digit dari kanan
  String _addThousandsSeparator(String numberStr) {
    // Handle negative numbers
    final isNegative = numberStr.startsWith('-');
    String workingStr = isNegative ? numberStr.substring(1) : numberStr;

    // Reverse string untuk lebih mudah menambah separator
    final reversed = workingStr.split('').reversed.join('');
    final withSeparator = reversed.replaceAllMapped(
      RegExp(r'.{1,3}'),
      (match) => '${match.group(0)!}.',
    );

    // Reverse kembali dan hapus separator terakhir
    String result = withSeparator
        .split('')
        .reversed
        .join('')
        .replaceFirst('.', ''); // Hapus titik paling depan

    return isNegative ? '-$result' : result;
  }

  static bool _isOperator(String token) => '+-×÷'.contains(token);

  static bool _isNumber(String token) => double.tryParse(token) != null;

  void _commitDisplay({bool force = false}) {
    if (force || !_displayCommitted) {
      _expression.add(_toNumberString(display));
      _displayCommitted = true;
    }
  }

  /// Apakah ekspresi sudah membentuk operasi lengkap [angka, op, angka(, %)]
  /// yang siap dievaluasi.
  bool _hasPendingOperation() {
    return _expression.length >= 3 &&
        _isNumber(_expression[0]) &&
        _isOperator(_expression[1]) &&
        _isNumber(_expression[2]);
  }

  /// Format token `_expression` menjadi string tampilan info,
  /// mis. ["100", "+"] → "100 +". `%` digabung ke token sebelumnya.
  String _formatExpressionForInfo() {
    final parts = <String>[];
    for (var i = 0; i < _expression.length; i++) {
      final token = _expression[i];
      if (token == '%') {
        if (parts.isNotEmpty && _isNumber(_expression[i - 1])) {
          parts[parts.length - 1] = '${parts.last}%';
        } else {
          parts.add('%');
        }
      } else {
        parts.add(_isNumber(token) ? _formatNumber(token) : token);
      }
    }
    return parts.join(' ');
  }

  /// Apakah `_expression` mengandung operator (+ - × ÷).
  bool _hasOperator() => _expression.any(_isOperator);

  void input(String value) {
    if (value == 'C') {
      display = '0';
      _expression.clear();
      _shouldResetDisplay = false;
      _displayCommitted = false;
      _operationFinalized = true;
      _expressionDisplay = null;
      return;
    }

    if (value == '⌫') {
      if (_shouldResetDisplay) return; // Display sudah dikunci (commit)
      final rawDisplay = _toNumberString(display);
      if (rawDisplay.length > 1) {
        final newRaw = rawDisplay.substring(0, rawDisplay.length - 1);
        display = _formatNumber(newRaw);
      } else {
        display = '0';
      }
      return;
    }

    // Operator (+, -, ×, ÷): menunda operator pertama, lalu mengevaluasi
    // operasi yang sudah lengkap saat operator kedua (dan seterusnya) ditekan.
    if ('+-×÷'.contains(value)) {
      // Pastikan ada operand kiri untuk operator baru.
      if (_expression.isEmpty) {
        // Setelah '=' / 'Error': lanjutkan dari nilai display bila valid.
        if (double.tryParse(_toNumberString(display)) == null) return;
        _commitDisplay(force: true);
      } else {
        _commitDisplay();
      }

      // Operasi [angka, op, angka(, %)] yang tertunda langsung dihitung
      // dan hasilnya ditampilkan.
      if (_hasPendingOperation()) {
        final result = _evaluate(_expression);
        if (result == null) {
          display = 'Error';
          _expression.clear();
          _operationFinalized = true;
          _shouldResetDisplay = true;
          _displayCommitted = true;
          _expressionDisplay = null;
          return;
        }
        display = _formatNumber(_formatResult(result));
        _expression
          ..clear()
          ..add(_toNumberString(display));
        _displayCommitted = true;
      }

      if (_expression.isNotEmpty && _isOperator(_expression.last)) {
        // Ganti operator jika ditekan berurutan
        _expression[_expression.length - 1] = value;
      } else {
        _expression.add(value);
      }
      _expressionDisplay = _formatExpressionForInfo();
      _operationFinalized = false;
      _shouldResetDisplay = true;
      return;
    }

    // % : ditunda, hasilnya baru dihitung saat '=' atau operator berikutnya
    if (value == '%') {
      _commitDisplay();
      if (_expression.isNotEmpty && _isNumber(_expression.last)) {
        _expression.add('%');
        if (!display.endsWith('%')) {
          display = '$display%';
        }
        _operationFinalized = false;
        _shouldResetDisplay = true;
      }
      return;
    }

    if (value == '=') {
      _finalize();
      return;
    }

    if (value == ',') {
      if (_shouldResetDisplay) return; // Display sudah dikunci (commit)
      final rawDisplay = _toNumberString(display);
      if (!rawDisplay.contains('.')) {
        display = _formatNumber('$rawDisplay.');
      }
      _shouldResetDisplay = false;
      return;
    }

    // Input angka normal
    final rawDisplay = _toNumberString(display);
    String newRaw;

    if (_shouldResetDisplay) {
      newRaw = value;
      _shouldResetDisplay = false;
      _displayCommitted = false;
    } else {
      if (rawDisplay == '0') {
        newRaw = value;
      } else {
        newRaw = rawDisplay + value;
      }
    }

    // Format hasil untuk display
    display = _formatNumber(newRaw);
  }

  void _finalize() {
    _commitDisplay();

    // Buang operator menggantung di akhir ekspresi (mis. "100 +")
    while (_expression.isNotEmpty && _isOperator(_expression.last)) {
      _expression.removeLast();
    }

    if (_expression.isEmpty) {
      _operationFinalized = true;
      _shouldResetDisplay = true;
      _displayCommitted = true;
      return;
    }

    final hadOperator = _hasOperator();
    final expressionText = hadOperator ? _formatExpressionForInfo() : null;
    final result = _evaluate(_expression);
    if (result == null) {
      display = 'Error';
      _expressionDisplay = null;
    } else {
      display = _formatNumber(_formatResult(result));
      if (hadOperator) {
        _expressionDisplay = '$expressionText =';
      }
    }

    _expression.clear();
    _operationFinalized = true;
    _shouldResetDisplay = true;
    _displayCommitted = true;
  }

  /// Evaluasi ekspresi dari kiri ke kanan (sesuai urutan penekanan tombol),
  /// mis. 100 + 200 × 5 = (100 + 200) × 5 = 1500.
  /// `%` diartikan: untuk +/− = persen dari operand kiri (a + b% = a + a×b/100),
  /// untuk ×/÷ = sekedar pembagian seratus (a × b% = a × b/100).
  /// Mengembalikan `null` jika terjadi pembagian dengan nol.
  double? _evaluate(List<String> tokens) {
    // Substitusi % sesuai operator yang mendahuluinya
    final expr = <String>[];
    for (final token in tokens) {
      if (token == '%') {
        if (expr.isNotEmpty && _isNumber(expr.last)) {
          if (expr.length >= 3 &&
              _isNumber(expr[expr.length - 3]) &&
              _isOperator(expr[expr.length - 2])) {
            final a = double.parse(expr[expr.length - 3]);
            final b = double.parse(expr.last);
            final op = expr[expr.length - 2];
            final effective = (op == '+' || op == '-')
                ? a * b / 100
                : b / 100;
            expr[expr.length - 1] = effective.toString();
          } else {
            final b = double.parse(expr.last);
            expr[expr.length - 1] = (b / 100).toString();
          }
        }
      } else {
        expr.add(token);
      }
    }

    // Evaluasi kiri ke kanan
    var result = double.parse(expr[0]);
    var i = 1;
    while (i < expr.length) {
      final op = expr[i];
      final right = double.parse(expr[i + 1]);
      if (op == '÷') {
        if (right == 0) return null;
        result = result / right;
      } else if (op == '×') {
        result = result * right;
      } else if (op == '+') {
        result = result + right;
      } else {
        result = result - right;
      }
      i += 2;
    }
    return result;
  }
}

/// Buka kalkulator dalam modal bottom sheet.
///
/// Mengembalikan nilai bulat yang dipilih user saat menekan "Terapkan",
/// atau `null` jika sheet ditutup tanpa menerapkan.
Future<int?> showCalculatorBottomSheet(
  BuildContext context, {
  int? initialValue,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        top: false,
        child: CalculatorScreen(
          initialValue: initialValue,
          onApply: (value) => Navigator.of(context).pop(value),
        ),
      );
    },
  );
}

/// Tombol untuk membuka kalkulator di dalam bottom sheet.
///
/// Letakkan di samping `DompetNumberField`. Saat user menekan "Terapkan",
/// nilai bulat hasil kalkulator dikirim melalui [onValueApplied].
class CalculatorTriggerButton extends StatelessWidget {
  final int? initialValue;
  final ValueChanged<int>? onValueApplied;
  final Color? color;
  final double iconSize;
  final String tooltip;

  const CalculatorTriggerButton({
    super.key,
    this.initialValue,
    this.onValueApplied,
    this.color,
    this.iconSize = 24,
    this.tooltip = 'Buka kalkulator',
  });

  Future<void> _open(BuildContext context) async {
    final value = await showCalculatorBottomSheet(
      context,
      initialValue: initialValue,
    );
    if (value != null) {
      onValueApplied?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _open(context),
      icon: Icon(Icons.calculate_rounded, size: iconSize, color: color),
      tooltip: tooltip,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final int? initialValue;
  final ValueChanged<int>? onApply;

  const CalculatorScreen({
    super.key,
    this.initialValue,
    this.onApply,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late Calculator _calculator;

  @override
  void initState() {
    super.initState();
    _calculator = Calculator(initialValue: widget.initialValue);
  }

  void _onButtonPressed(String value) {
    setState(() {
      _calculator.input(value);
    });
  }

  void _onApplyPressed() {
    widget.onApply?.call(_calculator.intValue);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canApply = _calculator.canApply;
    final previewValue = canApply
        ? FormatCurrency.formatRupiah(_calculator.intValue)
        : '—';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Desimal dibulatkan ke rupiah penuh saat diterapkan',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          // Display
          Card(
            color: colorScheme.surfaceContainer,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Info ekspresi tertunda (mis. "100 +", "300 ×", "100 + 200 =")
                  if (_calculator.expressionDisplay != null) ...[
                    Text(
                      _calculator.expressionDisplay!,
                      textAlign: TextAlign.right,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Main Display
                  Text(
                    _calculator.display,
                    textAlign: TextAlign.right,
                    style: textTheme.displayLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Button Grid
          CalculatorButtonGrid(
            onButtonPressed: _onButtonPressed,
          ),
          const SizedBox(height: 16),

          Text(
            'Nilai: $previewValue',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Tombol Terapkan
          FilledButton(
            onPressed: canApply ? _onApplyPressed : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }
}

class CalculatorButtonGrid extends StatelessWidget {
  final Function(String) onButtonPressed;

  const CalculatorButtonGrid({
    super.key,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final buttons = [
      ['C', '⌫', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      [',', '0', '='],
    ];

    return Column(
      children: buttons.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: row.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;

              final isEqual = value == '=';
              final isClear = value == 'C';
              final isOperator = '+-×÷%⌫'.contains(value);

              return Expanded(
                flex: isEqual ? 2 : 1,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < row.length - 1 ? 12 : 0,
                  ),
                  child: CalculatorButton(
                    value: value,
                    onPressed: () => onButtonPressed(value),
                    backgroundColor: isClear
                        ? colorScheme.error
                        : isOperator
                        ? colorScheme.tertiary
                        : isEqual
                        ? colorScheme.primary
                        : colorScheme.surfaceContainer,
                    foregroundColor: isClear || isEqual || isOperator
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String value;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const CalculatorButton({
    super.key,
    required this.value,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
