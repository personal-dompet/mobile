import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:dompet/features/account/presentation/provider/account_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_empty_list.dart';
import 'package:dompet/features/account/presentation/widgets/account_grid.dart';
import 'package:dompet/features/account/presentation/widgets/account_search_field.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountProvider);
    return Scaffold(
      body: RefreshWrapper(
        onRefresh: () => ref.read(accountProvider.notifier).refresh(),
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
                        onTap: (account) {},
                      ),
                    ),
                  if (data == null || data.isEmpty)
                    Expanded(
                      child: SingleChildScrollView(child: AccountEmptyList()),
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
