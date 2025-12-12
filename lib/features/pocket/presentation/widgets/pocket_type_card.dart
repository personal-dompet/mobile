import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/domain/model/saving_pocket_model.dart';
import 'package:dompet/features/pocket/domain/model/spending_pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/detail_pocket_provider.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PocketTypeCard extends ConsumerWidget {
  final PocketModel pocket;
  const PocketTypeCard({super.key, required this.pocket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketAsync = ref.watch(detailPocketProvider(pocket.id));
    final pocketData = pocketAsync.value;
    final isLoading = pocketAsync.isLoading;

    if (pocketData == null) {}

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: BoxBorder.all(
          color: pocket.color?.iconColor ?? AppTheme.disabledColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Skeletonizer(
        enabled: isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${pocketData.type.displayName} pocket',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textColorSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  pocketData.priority > 0 ? '#${pocketData.priority}' : '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Divider(
              height: 1,
              color: AppTheme.disabledColor,
            ),
            const SizedBox(height: 8),
            if (pocketData.type == PocketType.spending)
              _SpendingInfo(spendingPocket: pocket as SpendingPocketModel),
            if (pocketData.type == PocketType.saving)
              _SavingInfo(savingPocket: pocket as SavingPocketModel),
          ],
        ),
      ),
    );
  }
}

class _SpendingInfo extends StatelessWidget {
  final SpendingPocketModel spendingPocket;
  const _SpendingInfo({required this.spendingPocket});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        _LabelValue(
          label: 'Low balance threshold',
          value: spendingPocket.formattedLowBalanceThreshold,
        ),
        _LabelValue(
          label: 'Low balance reminder',
          customValue: spendingPocket.lowBalanceReminder
              ? Text(
                  'Active',
                  style: TextStyle(
                    color: AppTheme.successColor,
                  ),
                )
              : Text(
                  'Inactive',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                  ),
                ),
        ),
      ],
    );
  }
}

class _SavingInfo extends StatelessWidget {
  final SavingPocketModel savingPocket;
  const _SavingInfo({required this.savingPocket});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        _LabelValue(
          label: 'Saving target',
          customValue: savingPocket.targetAmount != null
              ? Text(savingPocket.formattedTargetAmount)
              : Text(
                  'Not set',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.warningColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
        ),
        _LabelValue(
          label: 'Target date',
          customValue: savingPocket.formattedtargetDate.isEmpty
              ? Text(
                  'Not set',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.warningColor,
                    fontStyle: FontStyle.italic,
                  ),
                )
              : Text(
                  savingPocket.formattedtargetDate,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                  ),
                ),
        ),
        _LabelValue(
          label: 'Description',
          value: savingPocket.targetDescription ?? '-',
          // customValue: savingPocket.formattedtargetDate.isEmpty
          //     ? Text(
          //         'Not set',
          //         style: TextStyle(
          //           fontSize: 12,
          //           color: AppTheme.warningColor,
          //           fontStyle: FontStyle.italic,
          //         ),
          //       )
          //     : Text(
          //         savingPocket.formattedtargetDate,
          //         style: TextStyle(
          //           color: AppTheme.primaryColor,
          //         ),
          //       ),
        ),
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final Widget? customValue;
  final String? value;
  const _LabelValue({
    required this.label,
    this.customValue,
    this.value,
  }) : assert((value == null && customValue != null) ||
            (value != null && customValue == null));

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppTheme.textColorTertiary,
          ),
        ),
        if (customValue != null)
          customValue!
        else
          Expanded(
              child: Text(
            value!,
            softWrap: true,
            // overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ))
      ],
    );
  }
}
