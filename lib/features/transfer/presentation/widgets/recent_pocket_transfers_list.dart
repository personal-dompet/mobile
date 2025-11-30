import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_pocket_transfer_provider.dart';
import 'package:dompet/features/transfer/presentation/widgets/recent_transfers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentPocketTransfersList extends ConsumerWidget {
  const RecentPocketTransfersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentPocketTransfersAsync = ref.watch(recentPocketTransfersProvider);

    return RecentTransfersList<PocketModel>(
      recentTransfers: recentPocketTransfersAsync,
    );
  }
}
