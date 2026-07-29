import 'package:dompet_app/core/utils/open_add_account_bottom_sheet.dart';
import 'package:dompet_app/core/widgets/grid_tile_add.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/assets/widgets/asset_card.dart';
import 'package:dompet_app/features/setup/cubits/asset_setup_cubit.dart';
import 'package:dompet_app/features/setup/widgets/wallet_setup_hero.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletSetupAsset extends StatelessWidget {
  const WalletSetupAsset({super.key});

  Widget _buildPresetGrid(
    BuildContext context,
    List<Account> accounts, {
    int? selectedAccountId,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 48),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        final themeData = Theme.of(context);
        final isSelected = account.id == selectedAccountId;
        final activeColor = isSelected
            ? themeData.colorScheme.primary
            : themeData.colorScheme.onSurface;

        return AssetCard(
          account: account,
          activeColor: activeColor,
          hideBalance: true,
          onTap: () async {
            final setupCubit = context.read<AssetSetupCubit>();
            setupCubit.selectPreset(account.id);

            final result = await openAddAccountBottomSheet(
              context,
              selectedPresetAccount: account,
            );

            setupCubit.removeSelectedPreset();

            if (result == null) return;

            setupCubit.createNewAssetAccount(result);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WalletSetupHero(
            title: 'Di mana biasanya kamu menyimpan uang?',
            subtitle:
                'Mulai dengan yang paling sering kamu gunakan sehari-hari.',
          ),
          BlocConsumer<AssetSetupCubit, AssetSetupState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                ready: (accounts, _, fromCreate) {
                  if (fromCreate) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      DompetSnackbar(
                        context,
                        message: 'Dompet berhasil ditambahkan.',
                        snackBarType: .success,
                      ),
                    );
                  }
                },
                awaitingSetup: (accounts, fromCreate) {
                  if (fromCreate) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      DompetSnackbar(
                        context,
                        message: 'Dompet belum bisa ditambahkan.',
                        snackBarType: .error,
                      ),
                    );
                  }
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => SizedBox.shrink(),
                loading: () {
                  return Container(
                    width: .infinity,
                    padding: const EdgeInsets.all(16).copyWith(top: 48),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 1),
                    ),
                  );
                },
                ready: (accounts, presetAccounts, _) {
                  return GridView.builder(
                    padding: const EdgeInsets.only(top: 48),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3 / 2,
                        ),
                    itemCount: accounts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == accounts.length) {
                        return GridTileAdd(
                          onTap: () async {
                            final setupCubit = context.read<AssetSetupCubit>();
                            final result = await openAddAccountBottomSheet(
                              context,
                              presetAccounts: presetAccounts,
                            );

                            if (result == null) return;

                            setupCubit.createNewAssetAccount(result);
                          },
                          label: 'Tambah dompet',
                        );
                      }
                      final account = accounts[index];

                      return AssetCard(account: account, hideBalance: true);
                    },
                  );
                },
                awaitingSetup: (accounts, _) {
                  return _buildPresetGrid(context, accounts);
                },
                selectedPreset: (accounts, selectedAccountId) {
                  return _buildPresetGrid(
                    context,
                    accounts,
                    selectedAccountId: selectedAccountId,
                  );
                },
                error: (message) {
                  return Container(
                    width: .infinity,
                    padding: const EdgeInsets.all(16).copyWith(top: 48),
                    child: Center(
                      child: Text(
                        message,
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          color: themeData.colorScheme.error,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
