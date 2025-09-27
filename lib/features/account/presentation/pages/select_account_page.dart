import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:dompet/features/account/domain/provider/account_provider.dart';
import 'package:dompet/features/transaction/domain/forms/top_up_form.dart';
import 'package:dompet/features/account/presentation/widgets/account_card_item.dart';
import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectAccountPage extends ConsumerWidget {
  const SelectAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(allAccountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshWrapper(
        onRefresh: () async => ref.invalidate(allAccountsProvider),
        child: accountsAsync.when(
          data: (data) {
            if (data == null || data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No accounts available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Navigate to account creation page
                        final result = await context.push<AccountType?>('/accounts/types');
                        if (result != null && context.mounted) {
                          final formProvider = ref.read(accountCreateFormProvider);
                          final typeControl = formProvider.typeControl;
                          typeControl.value = result;
                          final resultData = await context.push<AccountCreateForm>('/accounts/create');
                          if (resultData == null) return;

                          await ref.read(accountProvider.notifier).create(resultData);
                          
                          // After creating an account, pop back to this page to update the list
                          if (context.mounted) {
                            // Reload accounts after creation
                            ref.invalidate(allAccountsProvider);
                          }
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Account'),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
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
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final account = data[index];
                        // Check if this account is currently selected in the form
                        final currentForm = ModalRoute.of(context)
                            ?.settings
                            .arguments as TopUpForm?;
                        final isSelected =
                            currentForm?.account?.id == account.id;

                        return AccountCardItem(
                          account: account,
                          isSelected: isSelected,
                          onTap: () {
                            // Navigate back with the selected account
                            Navigator.of(context)
                                .pop<SimpleAccountModel>(account);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading accounts: $error'),
          ),
        ),
      ),
    );
  }
}
