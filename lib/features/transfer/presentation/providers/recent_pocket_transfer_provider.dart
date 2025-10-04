import 'package:dompet/features/transfer/data/transfer_repository.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_filter_form.dart';
import 'package:dompet/features/transfer/domain/models/pocket_transfer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recentPocketTransfersProvider =
    FutureProvider<List<PocketTransferModel>>((ref) async {
  final repository = ref.read(transferRepositoryProvider);
  final form = PocketTransferFilterForm()
    ..page.value = 1
    ..limit.value = 5;

  final result = await repository.pocketTransfers(form);
  return result;
});
