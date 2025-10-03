import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/item_list_empty_widget.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/presentation/provider/all_account_provider.dart';
import 'package:dompet/features/account/presentation/provider/filtered_account_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountEmptyList extends ConsumerWidget {
  final ListType listType;

  const AccountEmptyList({
    super.key,
    this.listType = ListType.filtered,
  });

  Future<void> _handleAccountCreation(BuildContext context) async {
    // Determine account type
    final type = await _determineAccountType(context);
    if (type == null) return;

    // Check if context is still valid
    if (!context.mounted) return;

    // Navigate to create account screen
    final resultData = await _navigateToCreateAccount(context, type);
    if (resultData == null || !context.mounted) return;
    // Save the created account
    _saveCreatedAccount(context, resultData);
  }

  Future<AccountType?> _determineAccountType(BuildContext context) async {
    // If viewing all accounts, use all type
    if (listType == ListType.all) {
      return AccountType.all;
    }

    // Get current filter
    final filter =
        ProviderScope.containerOf(context).read(accountFilterFormProvider);

    // If filter is set to 'all', ask user to select specific type
    if (filter.typeValue == AccountType.all) {
      return await showModalBottomSheet<AccountType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const AccountTypeSelectorBottomSheet(),
      );
    }

    // Use the filtered type
    return filter.typeValue;
  }

  Future<AccountCreateForm?> _navigateToCreateAccount(
      BuildContext context, AccountType type) async {
    final form =
        ProviderScope.containerOf(context).read(accountCreateFormProvider);
    form.typeControl.value = type;

    return await context.push<AccountCreateForm>('/accounts/create');
  }

  void _saveCreatedAccount(BuildContext context, AccountCreateForm resultData) {
    if (listType == ListType.filtered) {
      ProviderScope.containerOf(context)
          .read(filteredAccountProvider.notifier)
          .create(resultData);
    } else {
      ProviderScope.containerOf(context)
          .read(allAccountProvider.notifier)
          .create(resultData);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(accountFilterFormProvider);

    return ItemListEmptyWidget<AccountType>(
      title: 'No accounts yet',
      message: 'Start organizing your finances by creating your first account',
      icon: Icons.credit_card_rounded,
      form: form,
      keywordValue: () => form.keywordValue,
      typeValue: () => form.typeValue,
      allTypeValue: AccountType.all,
      displayName: (type) => type.displayName,
      itemType: 'accounts',
      onTypeChanged: (type) {
        // Update type if needed
      },
      onAddPressed: () async {
        await _handleAccountCreation(context);
      },
    );
  }
}
