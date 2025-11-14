import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_filter_provider.dart';
import 'package:dompet/features/account/presentation/provider/account_flow_provider.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountEmptyList extends ConsumerWidget {
  final ListType listType;
  final ValueChanged<AccountModel>? onFormCreated;
  final CreateFrom? createFrom;
  final bool hideButton;

  const AccountEmptyList({
    super.key,
    this.listType = ListType.filtered,
    this.onFormCreated,
    this.createFrom,
    this.hideButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(accountFilterProvider);

    final keyword = filter.keyword;
    final type = listType == ListType.option ? AccountType.all : filter.type;

    // Determine appropriate title and message based on filters
    String displayTitle = 'No accounts yet';
    String displayMessage =
        'Start organizing your finances by creating your first account';

    if ((keyword != null && keyword.isNotEmpty == true) ||
        (type != AccountType.all)) {
      // Filters are applied
      displayTitle = 'No matching account';
      if (keyword != null &&
          keyword.isNotEmpty == true &&
          type != AccountType.all) {
        displayMessage =
            'We couldn\'t find any ${type.displayName.toLowerCase()} acccounts matching "$keyword". Try a different search term or filter. Or would you like to create a new one?';
      } else if (keyword != null && keyword.isNotEmpty == true) {
        displayMessage =
            'We couldn\'t find any accounts matching "$keyword". Try a different search term. Or would you like to create a new accounts?';
      } else if (type != AccountType.all) {
        displayMessage =
            'You don\'t have any ${type.displayName.toLowerCase()} accounts yet. Would you like to create one?';
      } else {
        displayMessage =
            'We couldn\'t find any accounts matching your filters. Try adjusting your filters. Or would you like to create a new accounts?';
      }
    } else if (!hideButton) {
      // No filters applied
      displayTitle = 'No accounts yet';
      displayMessage =
          'Start organizing your finances by creating your first account';
    } else {
      displayTitle = 'No accounts yet';
      displayMessage =
          'Create your first account in the Account menu and add balance to it to start managing your finances.';
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            type.icon,
            size: 64,
            color: AppTheme.textColorPrimary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            displayTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textColorPrimary,
            ),
          ),
          const SizedBox(height: 24),
          if (!hideButton)
            ElevatedButton.icon(
              onPressed: () async {
                await ref.read(accountFlowProvider(listType)).beginCreate(
                  context,
                  onFormCreated: (accountForm) {
                    onFormCreated?.call(accountForm.toAccountModel());
                  },
                  createFrom: createFrom,
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: Text('Create account'),
            ),
        ],
      ),
    );
  }
}
