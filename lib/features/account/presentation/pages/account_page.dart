import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/account/presentation/provider/filtered_account_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_empty_list.dart';
import 'package:dompet/features/account/presentation/widgets/account_grid.dart';
import 'package:dompet/features/account/presentation/widgets/account_search_field.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector.dart';
import 'package:dompet/routes/create_pocket_transfer_route.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(filteredAccountListProvider);
    return Scaffold(
      floatingActionButton: accounts.length >= 2
          ? FloatingActionButton(
              onPressed: () {
                CreatePocketTransferRoute().push(context);
              },
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.backgroundColor,
              tooltip: 'Transfer',
              child: const Icon(Icons.swap_horiz),
            )
          : null,
      body: Padding(
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
            if (accounts.isNotEmpty)
              Expanded(
                child: AccountGrid(
                  data: accounts,
                  listType: ListType.filtered,
                  onTap: (account) {},
                ),
              ),
            if (accounts.isEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: AccountEmptyList(
                    listType: ListType.filtered,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
