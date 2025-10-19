import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/add_card_item.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/presentation/provider/all_account_provider.dart';
import 'package:dompet/features/account/presentation/provider/filtered_account_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector_bottom_sheet.dart';
import 'package:dompet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAccountCardItem extends ConsumerWidget {
  final ListType listType;

  const AddAccountCardItem({super.key, required this.listType});

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
    if (listType == ListType.option) {
      return await showModalBottomSheet<AccountType>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const AccountTypeSelectorBottomSheet(),
      );
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
    form.type.value = type;

    return await CreateAccountRoute().push<AccountCreateForm>(context);
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
    return AddCardItem(
      onTap: () async {
        await _handleAccountCreation(context);
      },
      label: 'Add Account',
      icon: Icons.add,
    );
  }
}
