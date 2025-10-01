import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_provider.dart';
import 'package:dompet/features/pocket/domain/model/simple_pocket_model.dart';
import 'package:dompet/features/pocket/presentation/pages/select_pocket_page.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/transaction/presentation/providers/recent_transaction_providers.dart';
import 'package:dompet/features/transfer/domain/forms/transfer_form.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WalletCard extends ConsumerWidget {
  const WalletCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);
    final wallet = walletAsync.value;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Wallet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                wallet?.formattedBalance ?? '-',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final selectedAccount = await context
                        .push<SimpleAccountModel?>('/accounts/select');

                    if (selectedAccount == null || !context.mounted) return;

                    final form = ref.read(topUpFormProvider);
                    form.accountControl.value = selectedAccount;

                    final topUpForm = await context.push<TopUpForm?>('/top-up');

                    if (topUpForm == null) return;

                    await ref.read(walletProvider.notifier).topUp(topUpForm);

                    if (!context.mounted) return;
                    ref.invalidate(recentTransactionProvider);
                    ref.invalidate(accountListProvider);
                    ref.invalidate(filteredAccountProvider);
                    context.showSuccessSnackbar('Top-up successful!');
                    form.reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                  label: const Text('Top Up'),
                ),
              ),
              if (wallet != null && wallet.availableBalance != 0)
                const SizedBox(height: 20),
              if (wallet != null && wallet.availableBalance != 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: .2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Unallocated Balance',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Ready to allocated',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wallet.formattedAvailableBalance,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final pocket =
                                    await context.pushNamed<SimplePocketModel>(
                                  'SelectPocket',
                                  queryParameters: {
                                    'title':
                                        SelectPocketTitle.destination.value,
                                  },
                                );
                                if (pocket == null || !context.mounted) return;
                                final transferForm =
                                    ref.read(transferFormProvider);
                                transferForm.fromPocketControl.value = wallet;
                                transferForm.toPocketControl.value = pocket;

                                final form = await context
                                    .pushNamed<TransferForm>('CreateTransfer');
                                if (form == null) return;
                                // transferForm.fromPocketControl.value =
                                // context.push('/transfers');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              icon:
                                  const Icon(Icons.swap_vert_rounded, size: 20),
                              label: const Text('Transfer'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO : Implement auto allocate functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Auto allocate feature coming soon!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              icon: const Icon(Icons.auto_fix_high_rounded,
                                  size: 20),
                              label: const Text('Auto Allocate'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
