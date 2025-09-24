import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/provider/account_provider.dart';
import 'package:dompet/features/account/presentation/widgets/add_account_card_item.dart';
import 'package:dompet/features/account/presentation/widgets/account_card_item.dart';
import 'package:dompet/features/account/presentation/widgets/account_empty_list.dart';
import 'package:dompet/features/account/presentation/widgets/account_search_field.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector.dart';
import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemCount:
                            data.length + 1, // Add 1 for the "Add Account" card
                        itemBuilder: (context, index) {
                          // If this is the last item, show the "Add Account" card
                          if (index == data.length) {
                            return AddAccountCardItem(
                              onTap: () async {
                                final result = await context
                                    .push<AccountType?>('/accounts/types');
                                if (result != null && context.mounted) {
                                  final form =
                                      ref.read(accountCreateFormProvider);
                                  final typeControl = form.typeControl;
                                  typeControl.value = result;
                                  final resultData =
                                      await context.push<AccountCreateForm>(
                                          '/accounts/create');
                                  if (resultData == null) return;

                                  ref
                                      .read(accountProvider.notifier)
                                      .create(resultData);
                                }
                              },
                            );
                          }
                          // Otherwise, show the regular account card
                          final account = data[index];
                          return AccountCardItem(
                            account: account,
                            isSelected: false,
                            onTap: null,
                          );
                        },
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