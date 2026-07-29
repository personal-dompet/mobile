import 'package:intl/intl.dart';

extension CurrencyFormat on num {
  String get currency {
    final formatter = NumberFormat.simpleCurrency(
      locale: 'id_ID',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }

  String get compactCurrency {
    final formatter = NumberFormat.compactCurrency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }

  DateTime get dateTime {
    return DateTime.fromMillisecondsSinceEpoch(toInt() * 1000);
  }
}
