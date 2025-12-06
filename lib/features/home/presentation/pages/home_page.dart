import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:dompet/features/home/presentation/widgets/quick_actions.dart';
import 'package:dompet/features/transaction/presentation/providers/recent_transaction_providers.dart';
import 'package:dompet/features/transaction/presentation/widgets/recent_transactions_list.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_pocket_transfer_provider.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:dompet/features/wallet/presentation/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshWrapper(
      onRefresh: () async {
        ref.invalidate(walletProvider);
        ref.invalidate(recentPocketTransfersProvider);
        ref.invalidate(recentTransactionProvider);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            spacing: 24,
            children: [
              const WalletCard(),
              QuickActions(),
              SizedBox(
                height: 8,
              ),
              const RecentTransactionsList(),
            ],
          ),
        ),
      ),
    );
  }
}
