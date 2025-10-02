import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';

class PocketTransferModel {
  final int id;
  final String userId;
  final int sourcePocketId;
  final int destinationPocketId;
  final SimplePocketModel sourcePocket;
  final SimplePocketModel destinationPocket;
  final int amount;
  final int date;
  final String? description;

  PocketTransferModel({
    required this.id,
    required this.userId,
    required this.sourcePocketId,
    required this.destinationPocketId,
    required this.sourcePocket,
    required this.destinationPocket,
    required this.amount,
    required this.date,
    required this.description,
  });

  String get formattedAmount => FormatCurrency.formatRupiah(amount);

  factory PocketTransferModel.fromJson(Map<String, dynamic> json) {
    return PocketTransferModel(
      id: json['id'],
      userId: json['userId'],
      sourcePocketId: json['sourcePocketId'],
      destinationPocketId: json['destinationPocketId'],
      sourcePocket: SimplePocketModel.fromJson(json['sourcePocket']),
      destinationPocket: SimplePocketModel.fromJson(json['destinationPocket']),
      amount: json['amount'],
      date: json['date'],
      description: json['description'],
    );
  }

  factory PocketTransferModel.empty() {
    return PocketTransferModel(
      id: -1,
      userId: '',
      sourcePocketId: 0,
      destinationPocketId: 0,
      sourcePocket: SimplePocketModel.empty(),
      destinationPocket: SimplePocketModel.empty(),
      amount: 0,
      date: 0,
      description: '',
    );
  }

  PocketTransferModel copyWith({
    int? amount,
    int? date,
    String? description,
    SimplePocketModel? sourcePocket,
    SimplePocketModel? destinationPocket,
  }) {
    return PocketTransferModel(
      id: id,
      userId: userId,
      sourcePocketId: sourcePocketId,
      destinationPocketId: destinationPocketId,
      sourcePocket: sourcePocket ?? this.sourcePocket,
      destinationPocket: destinationPocket ?? this.destinationPocket,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}
