import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_account_transfer_provider.dart';
import 'package:dompet/features/transfer/presentation/widgets/recent_transfers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentAccountTransfersList extends ConsumerWidget {
  const RecentAccountTransfersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAccountTransfersAsync =
        ref.watch(recentAccountTransfersProvider);

    return RecentTransfersList<AccountModel>(
      recentTransfers: recentAccountTransfersAsync,
    );
  }
}
