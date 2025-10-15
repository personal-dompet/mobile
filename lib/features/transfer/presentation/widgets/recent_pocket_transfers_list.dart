import 'package:dompet/core/widgets/recent_list_container.dart';
import 'package:dompet/features/transfer/domain/models/pocket_transfer_model.dart';
import 'package:dompet/features/transfer/presentation/providers/recent_pocket_transfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentPocketTransfersList extends ConsumerWidget {
  const RecentPocketTransfersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentPocketTransfersAsync = ref.watch(recentPocketTransfersProvider);

    return recentPocketTransfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return const Center(
            child: Text('No recent pocket transfers'),
          );
        }

        return RecentListContainer(
          length: transfers.length,
          itemBuilder: (context, index) =>
              _RecentPocketTransferItem(transfer: transfers[index]),
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

class _RecentPocketTransferItem extends StatelessWidget {
  final PocketTransferModel transfer;

  const _RecentPocketTransferItem({required this.transfer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.swap_horiz,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
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
            transfer.sourcePocket.name,
            style: TextStyle(
              fontSize: 12,
              color: transfer.sourcePocket.color?.withValues(alpha: 0.8) ??
                  Theme.of(context).colorScheme.primary,
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
            transfer.destinationPocket.name,
            style: TextStyle(
              fontSize: 12,
              color: transfer.destinationPocket.color?.withValues(alpha: 0.8) ??
                  Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).colorScheme.primary,
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
    );
  }
}
