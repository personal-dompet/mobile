import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:dompet/features/account/presentation/provider/filtered_account_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_empty_list.dart';
import 'package:dompet/features/account/presentation/widgets/account_grid.dart';
import 'package:dompet/features/account/presentation/widgets/account_search_field.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector.dart';
import 'package:dompet/routes/create_pocket_transfer_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(filteredAccountProvider);
    return Scaffold(
      floatingActionButton: accountsAsync.when(
        data: (data) {
          // Only show FAB when there are accounts
          if (data != null && data.length >= 2) {
            return FloatingActionButton(
              onPressed: () {
                CreatePocketTransferRoute().push(context);
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              tooltip: 'Transfer',
              child: const Icon(Icons.swap_horiz),
            );
          } else {
            // Return an empty container when no accounts are available
            return Container();
          }
        },
        loading: () => Container(), // Hide FAB while loading
        error: (error, stack) => Container(), // Hide FAB on error
      ),
      body: RefreshWrapper(
        onRefresh: () async => ref.invalidate(filteredAccountProvider),
        child: accountsAsync.when(
          data: (data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AccountSearchField(),
                  ),
                  const SizedBox(height: 16),
                  AccountTypeSelector(),
                  const SizedBox(height: 16),
                  if (data != null && data.isNotEmpty)
                    Expanded(
                      child: AccountGrid(
                        data: data,
                        listType: ListType.filtered,
                        onTap: (account) {},
                      ),
                    ),
                  if (data == null || data.isEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                          child: AccountEmptyList(
                        listType: ListType.filtered,
                      )),
                    ),
                ],
              ),
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(
            strokeWidth: 1,
          )),
          error: (error, stack) => Center(
            child: Text('Error loading accounts: $error'),
          ),
        ),
      ),
    );
  }
}
