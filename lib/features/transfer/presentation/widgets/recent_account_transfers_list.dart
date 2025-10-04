// import 'package:dompet/features/transfer/domain/models/account_transfer_model.dart';
// import 'package:dompet/features/transfer/presentation/providers/transfer_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RecentAccountTransfersList extends ConsumerWidget {
//   const RecentAccountTransfersList({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final recentAccountTransfersAsync = ref.watch(recentAccountTransfersProvider);

//     return recentAccountTransfersAsync.when(
//       data: (transfers) {
//         if (transfers.isEmpty) {
//           return const Center(
//             child: Text('No recent account transfers'),
//           );
//         }

//         return ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: transfers.length,
//           separatorBuilder: (context, index) => Divider(
//             color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
//             height: 1,
//             indent: 72,
//             endIndent: 16,
//           ),
//           itemBuilder: (context, index) {
//             final transfer = transfers[index] as AccountTransferModel;
//             return _RecentAccountTransferItem(transfer: transfer);
//           },
//         );
//       },
//       loading: () => const Center(
//           child: CircularProgressIndicator(
//         strokeWidth: 1,
//       )),
//       error: (error, stack) => Center(
//         child: Text('Error loading account transfers: $error'),
//       ),
//     );
//   }
// }

// class _RecentAccountTransferItem extends StatelessWidget {
//   final AccountTransferModel transfer;

//   const _RecentAccountTransferItem({required this.transfer});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: ListTile(
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
//         leading: CircleAvatar(
//           radius: 20,
//           backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
//           child: Icon(
//             Icons.account_balance,
//             color: Theme.of(context).colorScheme.onSecondaryContainer,
//             size: 20,
//           ),
//         ),
//         title: Text(
//           transfer.description ?? 'Account Transfer',
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//         subtitle: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               transfer.sourceAccount.name,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: transfer.sourceAccount.color?.withValues(alpha: 0.8) ??
//                     Theme.of(context).colorScheme.secondary,
//               ),
//             ),
//             const Text(
//               ' → ',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey,
//               ),
//             ),
//             Text(
//               transfer.destinationAccount.name,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: transfer.destinationAccount.color?.withValues(alpha: 0.8) ??
//                     Theme.of(context).colorScheme.secondary,
//               ),
//             ),
//           ],
//         ),
//         trailing: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               transfer.formattedAmount,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//             ),
//             Text(
//               _formatDate(transfer.createdAt),
//               style: const TextStyle(
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final diff = now.difference(date);
    
//     if (diff.inDays == 0) {
//       return 'Today';
//     } else if (diff.inDays == 1) {
//       return 'Yesterday';
//     } else if (diff.inDays < 7) {
//       return '${diff.inDays} days ago';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
// }
