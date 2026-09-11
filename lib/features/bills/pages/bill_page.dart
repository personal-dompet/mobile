import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/cubits/account_signal_cubit.dart';
import 'package:dompet_app/features/activities/cubits/activity_signal_cubit.dart';
import 'package:dompet_app/features/bills/cubits/bill_cubit.dart';
import 'package:dompet_app/features/bills/cubits/bill_signal_cubit.dart';
import 'package:dompet_app/features/bills/models/bill.dart';
import 'package:dompet_app/features/bills/widgets/bill_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Daftar bayar: Perlu Dibayar / Mendatang / Selesai.
@RoutePage()
class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  late final BillCubit _cubit;
  final _keywordControl = FormControl<String>();

  StreamSubscription<String?>? _keywordSub;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BillCubit>();
    _refreshAndSignal();
    _keywordSub = _keywordControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _cubit.fetch(keyword: keyword);
      });
    });
  }

  /// Refresh + bila sinkronisasi menyentuh tagihan, segarkan dashboard
  /// (aktivitas terbaru) dan akun. BillSignal tidak di-emit di sini
  /// (halaman ini me-listen-nya → loop).
  Future<void> _refreshAndSignal() async {
    final touched = await _cubit.refresh();
    if (!mounted || touched == 0) return;
    context.read<ActivitySignalCubit>().created();
    context.read<AccountSignalCubit>().created();
  }

  @override
  void dispose() {
    _keywordSub?.cancel();
    _debounce?.cancel();
    _keywordControl.dispose();
    _cubit.close();
    super.dispose();
  }

  void _clearSearch() {
    _debounce?.cancel();
    _keywordControl.reset();
    _cubit.fetch();
  }

  bool get _isSearching {
    final keyword = _keywordControl.value;
    return keyword != null && keyword.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BillSignalCubit, int>(
      listener: (context, state) => _refreshAndSignal(),
      child: BlocProvider.value(
        value: _cubit,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tagihan'),
            actions: [
              IconButton(
                tooltip: 'Tagihan rutin',
                icon: const Icon(Icons.calendar_month_rounded),
                onPressed: () =>
                    context.router.push(const BillPlanListRoute()),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 24),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  DompetTextField(
                    placeholder: 'Cari nama tagihan rutin...',
                    formControl: _keywordControl,
                    textInputAction: .search,
                    clearable: true,
                    onClear: _clearSearch,
                  ),
                  Expanded(
                    child: BlocBuilder<BillCubit, BillState>(
                      bloc: _cubit,
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () => const Padding(
                            padding: EdgeInsets.only(top: 64),
                            child: SpinnerLoading(),
                          ),
                          error: (message) => Center(
                            child: Text(
                              message,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          loaded: (attention, upcoming, recentPaid) {
                            if (attention.isEmpty &&
                                upcoming.isEmpty &&
                                recentPaid.isEmpty) {
                              return Center(
                                child: _isSearching
                                    ? DompetEmptySearch(
                                        subject: 'tagihan',
                                        onReset: _clearSearch,
                                      )
                                    : EmptyMessage(
                                        center: true,
                                        title: 'Belum ada tagihan.',
                                        text:
                                            'Buat tagihan rutin dulu agar tagihan muncul otomatis.',
                                        actionText: 'Kelola Tagihan Rutin',
                                        onAction: () => context.router.push(
                                          const BillPlanListRoute(),
                                        ),
                                      ),
                              );
                            }
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                spacing: 16,
                                children: [
                                  if (attention.isNotEmpty)
                                    _Section(
                                      title: 'Perlu Dibayar',
                                      bills: attention,
                                    ),
                                  if (upcoming.isNotEmpty)
                                    _Section(
                                      title: 'Mendatang',
                                      bills: upcoming,
                                    ),
                                  if (recentPaid.isNotEmpty)
                                    _Section(
                                      title: 'Selesai',
                                      bills: recentPaid,
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Bill> bills;
  const _Section({required this.title, required this.bills});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Column(
          spacing: 12,
          children: [
            for (final bill in bills)
              BillTile(
                bill: bill,
                onTap: () => context.router.push(
                  BillDetailRoute(billId: bill.id),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
