import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/budgets/cubits/budget_plan_list_cubit.dart';
import 'package:dompet_app/features/budgets/cubits/budget_signal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// FIX-12 (IMP-9): list semua rencana anggaran untuk pengelolaan.
/// Dibuka via ikon kalender di AppBar halaman anggaran.
@RoutePage()
class BudgetPlanListPage extends StatefulWidget {
  const BudgetPlanListPage({super.key});

  @override
  State<BudgetPlanListPage> createState() => _BudgetPlanListPageState();
}

class _BudgetPlanListPageState extends State<BudgetPlanListPage> {
  final _cubit = getIt<BudgetPlanListCubit>();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetSignalCubit, int>(
      listener: (context, state) => _cubit.refresh(),
      child: BlocProvider.value(
        value: _cubit..fetch(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Rencana Anggaran')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 24),
              child: BlocBuilder<BudgetPlanListCubit, BudgetPlanListState>(
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
                    loaded: (items) =>
                      items.isEmpty
                          ? const Center(
                              child: Text(
                                'Belum ada rencana anggaran.\nBuat dari tombol + di halaman anggaran.',
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
                                  planAmount: item.plan.amount,
                                  categoryName: item.category.name,
                                  iconCode: item.category.iconCode,
                                  onTap: () => context.router.push(
                                    BudgetPlanRoute(category: item.category),
                                  ),
                                );
                              },
                            ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final int planAmount;
  final String categoryName;
  final int? iconCode;
  final VoidCallback onTap;
  const _PlanTile({
    required this.planAmount,
    required this.categoryName,
    required this.iconCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      categoryName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      planAmount.currency,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
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
