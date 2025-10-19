import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pocketOptionProvider = FutureProvider.autoDispose<List<PocketModel>>(
  (ref) async {
    final pockets = await ref.watch(pocketListProvider.future);
    final wallet = await ref.watch(walletProvider.future);

    final options = [...pockets];

    if (wallet != null) {
      options.insert(0, wallet);
    }

    return options;
  },
);
