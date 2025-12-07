import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transfer/data/transfer_source.dart';
import 'package:dompet/features/transfer/domain/forms/account_transfer_form.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/domain/forms/transfer_filter_form.dart';
import 'package:dompet/features/transfer/domain/models/transfer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferRepository {
  final TransferSource _source;

  TransferRepository(this._source);

  Future<List<TransferModel<PocketModel>>> pocketTransfers(
      TransferFilterForm form) async {
    final data = await _source.pocketTransfers(form);
    return TransferModel.fromJsonList(data, PocketModel.fromJson);
  }

  Future<List<TransferModel<AccountModel>>> accountTransfers(
      TransferFilterForm form) async {
    final data = await _source.accountTransfers(form);
    return TransferModel.fromJsonList(data, AccountModel.fromJson);
  }

  Future<TransferModel<PocketModel>> pocketTransfer(
    PocketTransferForm request,
  ) async {
    final data = await _source.pocketTransfer(request);
    return TransferModel<PocketModel>.fromJson(data, PocketModel.fromJson);
  }

  Future<TransferModel<AccountModel>> accountTransfer(
    AccountTransferForm request,
  ) async {
    final data = await _source.accountTransfer(request);
    return TransferModel<AccountModel>.fromJson(data, AccountModel.fromJson);
  }
}

final transferRepositoryProvider =
    Provider.autoDispose<TransferRepository>((ref) {
  final source = ref.watch(transferSourceProvider);
  return TransferRepository(source);
});
