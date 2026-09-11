import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/bills/cubits/bill_plan_list_cubit.dart';
import 'package:dompet_app/features/bills/cubits/bill_signal_cubit.dart';
import 'package:dompet_app/features/bills/enums/bill_plan_period_enum.dart';
import 'package:dompet_app/features/bills/models/bill_plan.dart';
import 'package:dompet_app/features/bills/utils/bill_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// List semua tagihan rutin untuk pengelolaan.
/// Dibuka via menu Tagihan di drawer.
@RoutePage()
class BillPlanListPage extends StatefulWidget {
  const BillPlanListPage({super.key});

  @override
  State<BillPlanListPage> createState() => _BillPlanListPageState();
}

class _BillPlanListPageState extends State<BillPlanListPage> {
  final _cubit = getIt<BillPlanListCubit>();
  final _keywordControl = FormControl<String>();

  StreamSubscription<String?>? _keywordSub;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _keywordSub = _keywordControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _cubit.fetch(keyword: keyword);
      });
    });
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
    _cubit.fetch();
  }

  bool get _isSearching {
    final keyword = _keywordControl.value;
    return keyword != null && keyword.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BillSignalCubit, int>(
      listener: (context, state) => _cubit.refresh(),
      child: BlocProvider.value(
        value: _cubit..fetch(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Tagihan Rutin')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.router.push(BillPlanFormRoute()),
            child: const Icon(Icons.add_rounded),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 24),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  DompetTextField(
                    placeholder: 'Cari nama tagihan...',
                    formControl: _keywordControl,
                    textInputAction: .search,
                    clearable: true,
                    onClear: _clearSearch,
                  ),
                  Expanded(
                    child: BlocBuilder<BillPlanListCubit, BillPlanListState>(
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
                          loaded: (items) => items.isEmpty
                              ? Center(
                                  child: Text(
                                    _isSearching
                                        ? 'Tidak ada tagihan yang cocok.\nCoba kata kunci lain.'
                                        : 'Belum ada tagihan rutin.\nBuat dari tombol + di halaman ini.',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: items.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _PlanTile(
                                plan: item.plan,
                                categoryName: item.category.name,
                                iconCode: item.category.iconCode,
                                onTap: () => context.router.push(
                                  BillPlanDetailRoute(planId: item.plan.id),
                                ),
                              );
                            },
                                ),
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

class _PlanTile extends StatelessWidget {
  final BillPlan plan;
  final String categoryName;
  final int? iconCode;
  final VoidCallback onTap;
  const _PlanTile({
    required this.plan,
    required this.categoryName,
    required this.iconCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMonthly = plan.period == BillPlanPeriodEnum.monthly.name;
    final ended = plan.endedAt != null &&
        DateTime.fromMillisecondsSinceEpoch(
          plan.endedAt! * 1000,
        ).isBefore(DateTime.now());
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                child: Icon(
                  iconCode == null
                      ? Icons.receipt_rounded
                      : MaterialIconData.fromCode(iconCode!),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      plan.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      plan.amount.currency,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${plan.reference ?? categoryName} • '
                      '${isMonthly ? 'Bulanan' : 'Tahunan'} • '
                      '${BillSchedule.formatShort(plan.period, plan.billedSchedule)} → '
                      '${BillSchedule.formatShort(plan.period, plan.dueDateSchedule)}'
                      '${ended ? ' • Berakhir' : ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
