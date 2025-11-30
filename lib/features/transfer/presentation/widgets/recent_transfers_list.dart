import 'package:dompet/core/models/financial_entity_model.dart';
import 'package:dompet/core/widgets/animatied_opacity_container.dart';
import 'package:dompet/core/widgets/recent_list_container.dart';
import 'package:dompet/features/transfer/domain/models/transfer_model.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentTransfersList<T extends FinancialEntityModel>
    extends StatelessWidget {
  final AsyncValue<List<TransferModel<FinancialEntityModel>>> recentTransfers;
  const RecentTransfersList({super.key, required this.recentTransfers});

  @override
  Widget build(BuildContext context) {
    return recentTransfers.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return const Center(
            child: Text('No recent pocket transfers'),
          );
        }

        return RecentListContainer(
          length: transfers.length,
          itemBuilder: (context, index) => _RecentTransferItem<T>(
            transfer: transfers[index],
          ),
          title: 'Recent Pocket Transfers',
          onSeeAllPressed: () {
            debugPrint('See all recent pocket transfers pressed');
          },
        );
      },
      loading: () => const Center(
          child: CircularProgressIndicator(
        strokeWidth: 1,
      )),
      error: (error, stack) => Center(
        child: Text('Error loading pocket transfers: $error'),
      ),
    );
  }
}

class _RecentTransferItem<T extends FinancialEntityModel>
    extends StatelessWidget {
  final TransferModel<FinancialEntityModel> transfer;

  const _RecentTransferItem({required this.transfer});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacityContainer(
      isAnimated: transfer.id < 0,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.cardColor,
          child: Icon(
            Icons.swap_horiz,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          transfer.description == null || transfer.description!.isEmpty
              ? 'Pocket Transfer'
              : transfer.description!,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              transfer.source.name,
              style: TextStyle(
                fontSize: 12,
                color: transfer.source.color?.withValues(alpha: 0.8) ??
                    AppTheme.primaryColor,
              ),
            ),
            const Text(
              ' → ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              transfer.destination.name,
              style: TextStyle(
                fontSize: 12,
                color: transfer.destination.color?.withValues(alpha: 0.8) ??
                    AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transfer.formattedAmount,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.primaryColor,
              ),
            ),
            Text(
              transfer.relativeFormattedCreatedAt,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
