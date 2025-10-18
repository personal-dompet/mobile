import 'package:dompet/core/enum/transfer_static_subject.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/core/widgets/animatied_opacity_container.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/all_account_provider.dart';
import 'package:dompet/features/account/presentation/provider/filtered_account_provider.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/pages/select_pocket_page.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/transaction/presentation/providers/recent_transaction_providers.dart';
import 'package:dompet/features/transfer/domain/forms/pocket_transfer_form.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_pocket_transfer_provider.dart';
import 'package:dompet/features/transfer/presentation/providers/transfer_provider.dart';
import 'package:dompet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:dompet/routes/routes.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                          color: AppTheme.textColorPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Icon(
                    Icons.account_balance_wallet,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textColorSecondary,
                    ),
              ),
              const SizedBox(height: 4),
              AnimatedOpacityContainer(
                isAnimated: wallet?.isLoading ?? false,
                child: Text(
                  wallet?.formattedTotalBalance ?? '-',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final selectedAccount =
                        await SelectAccountRoute().push<AccountModel>(context);

                    if (selectedAccount == null || !context.mounted) return;

                    final form = ref.read(topUpFormProvider);
                    form.account.value = selectedAccount;

                    final topUpForm =
                        await TopUpRoute().push<TopUpForm>(context);

                    if (topUpForm == null) {
                      form.reset();
                      return;
                    }

                    await ref.read(walletProvider.notifier).topUp(topUpForm);

                    if (!context.mounted) return;
                    ref.invalidate(recentTransactionProvider);
                    ref.invalidate(allAccountProvider);
                    ref.invalidate(filteredAccountProvider);
                    form.reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    // foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                  label: const Text('Top Up'),
                ),
              ),
              if (wallet != null && wallet.balance != 0)
                const SizedBox(height: 20),
              if (wallet != null && wallet.balance != 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
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
                                  color: AppTheme.textColorSecondary,
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AnimatedOpacityContainer(
                        isAnimated: wallet.isLoading,
                        child: Text(
                          wallet.formattedBalance,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.textColorPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final pocket = await SelectPocketRoute(
                                  title: SelectPocketTitle.destination,
                                ).push<PocketModel>(context);
                                if (pocket == null || !context.mounted) return;
                                final transferForm =
                                    ref.read(pocketTransferFormProvider);
                                transferForm.fromPocket.value = wallet;
                                transferForm.toPocket.value = pocket;

                                final form = await CreatePocketTransferRoute(
                                  subject: TransferStaticSubject.source,
                                ).push<PocketTransferForm>(context);
                                if (form == null) return;
                                await ref
                                    .read(transferProvider)
                                    .pocketTransfer(form);
                                ref.invalidate(pocketTransferFormProvider);
                                ref.invalidate(recentPocketTransfersProvider);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
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
                                backgroundColor: AppTheme.secondaryColor,
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
