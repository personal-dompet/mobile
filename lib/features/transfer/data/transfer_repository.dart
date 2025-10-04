import 'package:dompet/features/transfer/data/transfer_source.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_filter_form.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/domain/models/pocket_transfer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferRepository {
  final TransferSource _source;

  TransferRepository(this._source);

  Future<List<PocketTransferModel>> pocketTransfers(
      PocketTransferFilterForm form) async {
    final data = await _source.pocketTransfers(form);
    return PocketTransferModel.fromJsonList(data);
  }

  Future<PocketTransferModel> pocketTransfer(PocketTransferForm request) async {
    final data = await _source.pocketTransfer(request);
    return PocketTransferModel.fromJson(data);
  }
}

final transferRepositoryProvider =
    Provider.autoDispose<TransferRepository>((ref) {
  final source = ref.watch(transferSourceProvider);
  return TransferRepository(source);
});
