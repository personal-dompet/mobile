import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/assets/cubits/asset_cubit.dart';
import 'package:dompet_app/features/assets/widgets/asset_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// FIX-14 (IMP-2): grid dompet arsip, mirror grid aktif (2 kolom).
/// Tap → detail (read-only + tombol Pulihkan di menu). Pulihkan lewat
/// detail agar konsisten satu pintu. Entry via ikon arsip di [AssetPage].
@RoutePage()
class AssetArchivedPage extends StatelessWidget {
  const AssetArchivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssetCubit>()..fetchArchived(),
      child: _AssetArchivedBody(),
    );
  }
}

class _AssetArchivedBody extends StatefulWidget {
  const _AssetArchivedBody();

  @override
  State<_AssetArchivedBody> createState() => _AssetArchivedBodyState();
}

class _AssetArchivedBodyState extends State<_AssetArchivedBody> {
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

  @override
  void dispose() {
    _debounce?.cancel();
    _keywordControl.dispose();
    super.dispose();
  }

  void _fetch(String? keyword) {
    final filter = AccountFilter(name: keyword);
    context.read<AssetCubit>().fetchArchived(filter: filter);
  }

  void _clearSearch() {
    _debounce?.cancel();
    _fetch(null);
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
        appBar: AppBar(title: Text('Dompet Diarsipkan')),
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
                          onClear: _clearSearch,
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
                    loaded: (assets) => assets.isEmpty
                        ? SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Belum ada dompet yang diarsipkan.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          )
                        : SliverPadding(
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
