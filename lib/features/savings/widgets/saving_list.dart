import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/router/router.gr.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';
import 'package:dompet_app/features/savings/widgets/empty_savings.dart';
import 'package:flutter/material.dart';

class SavingList extends StatelessWidget {
  final List<SavingPlan> plans;
  const SavingList({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return Center(child: EmptySavings(center: true));
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        return _SavingCard(plan: plans[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 16);
      },
      itemCount: plans.length,
    );
  }
}

class _SavingCard extends StatelessWidget {
  final SavingPlan plan;
  const _SavingCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final ratio = plan.progressRatio;
    final percent = ratio == null ? null : (ratio * 100).round();

    return Card(
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: () => SavingDetailRoute(accountId: plan.accountId).push(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 8,
            children: [
              Row(
                spacing: 12,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        themeData.colorScheme.primaryContainer,
                    foregroundColor:
                        themeData.colorScheme.onPrimaryContainer,
                    child: Icon(
                      plan.iconCode == null
                          ? Icons.savings_rounded
                          : MaterialIconData.fromCode(plan.iconCode!),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .stretch,
                      spacing: 2,
                      children: [
                        Text(
                          plan.accountName,
                          style: themeData.textTheme.bodyMedium?.copyWith(
                            fontWeight: .w600,
                          ),
                          overflow: .ellipsis,
                        ),
                        Text(
                          plan.hasTarget
                              ? '${plan.balance.currency} dari ${plan.targetAmount!.currency}'
                              : plan.balance.currency,
                          style: themeData.textTheme.bodySmall?.copyWith(
                            color: themeData.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          overflow: .ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    plan.balance.currency,
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      color: themeData.colorScheme.primary,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
              if (ratio != null) ...[
                _UsageBar(ratio: ratio),
                Row(
                  spacing: 4,
                  children: [
                    Expanded(
                      child: Text(
                        'Terkumpul $percent%',
                        style: themeData.textTheme.bodySmall,
                        overflow: .ellipsis,
                      ),
                    ),
                    if (!plan.isTargetReached)
                      Text(
                        '${plan.remaining.currency} lagi',
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Target tercapai',
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.colorScheme.primary,
                          fontWeight: .w600,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _UsageBar extends StatelessWidget {
  final double ratio;
  const _UsageBar({required this.ratio});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final clamped = ratio.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          Container(
            height: 6,
            color: colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          FractionallySizedBox(
            alignment: .centerLeft,
            widthFactor: clamped,
            child: Container(height: 6, color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
