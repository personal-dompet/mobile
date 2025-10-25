import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/item_list_empty_widget.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_flow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountEmptyList extends ConsumerWidget {
  final ListType listType;
  final ValueChanged<AccountModel>? onFormCreated;

  const AccountEmptyList({
    super.key,
    this.listType = ListType.filtered,
    this.onFormCreated,
  });

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
        await ref.read(accountFlowProvider(listType)).beginCreate(context,
            onFormCreated: (accountForm) {
          onFormCreated?.call(accountForm.toAccountModel());
        });
      },
    );
  }
}
