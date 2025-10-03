import 'package:dompet/core/utils/helpers/format_currency.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transfer/domain/models/transfer_model.dart';

class PocketTransferModel extends TransferModel {
  final PocketModel sourcePocket;
  final PocketModel destinationPocket;

  PocketTransferModel({
    required super.createdAt,
    required super.updatedAt,
    required super.id,
    required super.amount,
    super.description,
    required this.sourcePocket,
    required this.destinationPocket,
  });

  factory PocketTransferModel.fromJson(Map<String, dynamic> json) {
    final transfer = TransferModel.fromJson(json);
    return PocketTransferModel(
      createdAt: transfer.createdAt,
      updatedAt: transfer.updatedAt,
      id: transfer.id,
      amount: transfer.amount,
      description: transfer.description,
      sourcePocket: PocketModel.fromJson(json['sourcePocket']),
      destinationPocket: PocketModel.fromJson(json['destinationPocket']),
    );
  }

  factory PocketTransferModel.placeholder({
    int? amount,
    String? description,
    PocketModel? sourcePocket,
    PocketModel? destinationPocket,
  }) {
    return PocketTransferModel(
      id: -1,
      sourcePocket: sourcePocket ?? PocketModel.placeholder(),
      destinationPocket: destinationPocket ?? PocketModel.placeholder(),
      amount: amount ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      description: description ?? '',
    );
  }
}
