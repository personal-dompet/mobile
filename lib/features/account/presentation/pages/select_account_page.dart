import 'package:dompet/core/widgets/refresh_wrapper.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_grid.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectAccountPage extends ConsumerWidget {
  final int? selectedAccountId;
  SelectAccountPage({super.key, this.selectedAccountId});

  final filter = AccountFilterForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountProvider(filter));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshWrapper(
        onRefresh: () async => ref.invalidate(accountProvider(filter)),
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
                        // Show account type selection bottom sheet
                        final result = await showModalBottomSheet<AccountType>(
                          context: context,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          builder: (context) => const AccountTypeSelectorBottomSheet(),
                        );
                        if (result != null && context.mounted) {
                          final formProvider =
                              ref.read(accountCreateFormProvider);
                          final typeControl = formProvider.typeControl;
                          typeControl.value = result;
                          final resultData = await context
                              .push<AccountCreateForm>('/accounts/create');
                          if (resultData == null) return;

                          await ref
                              .read(accountProvider(filter).notifier)
                              .create(resultData);

                          // After creating an account, pop back to this page to update the list
                          if (context.mounted) {
                            // Reload accounts after creation
                            ref.invalidate(accountProvider(filter));
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
                    child: AccountGrid(
                        data: data,
                        selectedAccountId: selectedAccountId,
                        onTap: (account) {
                          Navigator.of(context)
                              .pop<SimpleAccountModel>(account);
                        }),
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
