import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/model/account_filter.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/assets/cubits/asset_cubit.dart';
import 'package:dompet_app/features/assets/widgets/asset_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class AssetPage extends StatelessWidget {
  const AssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssetCubit>()..fetch(),
      child: _AssetAccountPage(),
    );
  }
}

class _AssetAccountPage extends StatefulWidget {
  const _AssetAccountPage();

  @override
  State<_AssetAccountPage> createState() => _AssetAccountPageState();
}

class _AssetAccountPageState extends State<_AssetAccountPage> {
  final _keywordControl = FormControl<String>();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _keywordControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        _fetch(keyword);
      });
    });
  }

  void _fetch(String? keyword) {
    final filter = AccountFilter(name: keyword);
    context.read<AssetCubit>().fetch(filter: filter);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccountSignalCubit, int>(
          listener: (context, state) {
            _fetch(_keywordControl.value);
          },
        ),
        BlocListener<ActivitySignalCubit, int>(
          listener: (context, state) {
            _fetch(_keywordControl.value);
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dompet'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                onPressed: () {
                  context.router.push(AssetFormRoute());
                },
                icon: Icon(Icons.add_rounded),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<AssetCubit, AssetState>(
            builder: (context, state) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  PinnedHeaderSliver(
                    child: ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16).copyWith(bottom: 0),
                        child: DompetTextField(
                          formControl: _keywordControl,
                          placeholder: 'Cari nama dompet...',
                          textInputAction: .search,
                          clearable: true,
                        ),
                      ),
                    ),
                  ),
                  state.maybeWhen(
                    loading: () => SliverFillRemaining(
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    error: (message) => SliverFillRemaining(
                      child: Center(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ),
                    ),
                    loaded: (assets) => SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3 / 2,
                        ),
                        itemCount: assets.length,
                        itemBuilder: (context, index) {
                          final account = assets[index];

                          return AssetCard(
                            account: account,
                            onTap: () {
                              context.router.push(
                                AssetDetailRoute(id: account.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    orElse: () => SliverToBoxAdapter(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
