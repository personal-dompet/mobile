import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/setup/cubits/asset_setup_cubit.dart';
import 'package:dompet_app/features/setup/widgets/wallet_setup_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class WalletSetupPage extends StatelessWidget {
  const WalletSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssetSetupCubit>()..init(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: WalletSetupAsset()),
                Padding(
                  padding: const EdgeInsets.all(16).copyWith(bottom: 24),
                  child: BlocBuilder<AssetSetupCubit, AssetSetupState>(
                    builder: (context, state) {
                      final bool hasAsset = state.maybeWhen(
                        orElse: () => false,
                        ready: (_, _, _) => true,
                      );
                      return FilledButton(
                        onPressed: hasAsset
                            ? () {
                                context.router.replace(DashboardRoute());
                              }
                            : null,
                        child: Text('Lanjutkan'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
