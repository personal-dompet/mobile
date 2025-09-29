import 'package:dompet/core/widgets/item_list_empty_widget.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/presentation/provider/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountEmptyList extends ConsumerWidget {
  const AccountEmptyList({super.key});

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
        final result = await context.push<AccountType?>('/accounts/types');
        if (result != null && context.mounted) {
          final formProvider = ref.read(accountCreateFormProvider);
          final typeControl = formProvider.typeControl;
          typeControl.value = result;
          final resultData =
              await context.push<AccountCreateForm>('/accounts/create');
          if (resultData == null) return;

          ref.read(accountProvider.notifier).create(resultData);
        }
      },
    );
  }
}
