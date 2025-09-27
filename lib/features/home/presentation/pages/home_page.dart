import 'package:dompet/features/transaction/presentation/widgets/recent_transactions_list.dart';
import 'package:dompet/features/wallet/presentation/widgets/wallet_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const WalletCard(),
          const SizedBox(height: 24.0),
          const Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const RecentTransactionsList(),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
