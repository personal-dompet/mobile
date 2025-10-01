import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_create_form.dart';
import 'package:dompet/features/account/domain/model/simple_account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_card_item.dart';
import 'package:dompet/features/account/presentation/widgets/account_type_selector_bottom_sheet.dart';
import 'package:dompet/features/account/presentation/widgets/add_account_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountGrid extends ConsumerWidget {
  final List<SimpleAccountModel> data;
  final int? selectedAccountId;
  final void Function(SimpleAccountModel) onTap;
  final ListType listType;

  const AccountGrid({
    super.key,
    this.data = const [],
    this.selectedAccountId,
    required this.onTap,
    this.listType = ListType.filtered,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        // If this is the last item, show the "Add Account" card
        if (index == data.length) {
          return AddAccountCardItem(
            onTap: () async {
              final result = await showModalBottomSheet<AccountType>(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (context) => const AccountTypeSelectorBottomSheet(),
              );
              if (result != null && context.mounted) {
                final form = ref.read(accountCreateFormProvider);
                final typeControl = form.typeControl;
                typeControl.value = result;
                final resultData =
                    await context.push<AccountCreateForm>('/accounts/create');
                if (resultData == null) return;

                if (listType == ListType.filtered) {
                  ref.read(filteredAccountProvider.notifier).create(resultData);
                } else {
                  ref.read(accountListProvider.notifier).create(resultData);
                }
              }
            },
          );
        }
        final account = data[index];
        // Check if this account is currently selected in the form
        final isSelected = account.id == selectedAccountId;
        return AccountCardItem(
          account: account,
          isSelected: isSelected,
          onTap: () => onTap(account),
        );
      },
    );
  }
}
