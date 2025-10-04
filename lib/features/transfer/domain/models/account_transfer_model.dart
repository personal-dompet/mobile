// import 'package:dompet/features/account/domain/models/account_model.dart';
// import 'package:dompet/features/transfer/domain/models/transfer_model.dart';

// class AccountTransferModel extends TransferModel {
//   final AccountModel sourceAccount;
//   final AccountModel destinationAccount;

//   AccountTransferModel({
//     required super.createdAt,
//     required super.updatedAt,
//     required super.id,
//     required super.amount,
//     super.description,
//     required this.sourceAccount,
//     required this.destinationAccount,
//   });

//   factory AccountTransferModel.fromJson(Map<String, dynamic> json) {
//     final transfer = TransferModel.fromJson(json);
//     return AccountTransferModel(
//       createdAt: transfer.createdAt,
//       updatedAt: transfer.updatedAt,
//       id: transfer.id,
//       amount: transfer.amount,
//       description: transfer.description,
//       sourceAccount: AccountModel.fromJson(json['sourceAccount']),
//       destinationAccount: AccountModel.fromJson(json['destinationAccount']),
//     );
//   }

//   factory AccountTransferModel.placeholder({
//     int? amount,
//     String? description,
//     AccountModel? sourceAccount,
//     AccountModel? destinationAccount,
//   }) {
//     return AccountTransferModel(
//       id: -1,
//       sourceAccount: sourceAccount ?? AccountModel.placeholder(),
//       destinationAccount: destinationAccount ?? AccountModel.placeholder(),
//       amount: amount ?? 0,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       description: description ?? '',
//     );
//   }
// }
