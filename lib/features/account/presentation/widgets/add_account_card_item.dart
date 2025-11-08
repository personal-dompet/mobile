import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/add_card_item.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_flow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAccountCardItem extends ConsumerWidget {
  final ListType listType;
  final ValueChanged<AccountModel>? onFormCreated;
  final CreateFrom? createFrom;

  const AddAccountCardItem({
    super.key,
    required this.listType,
    this.onFormCreated,
    this.createFrom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AddCardItem(
      onTap: () async {
        await ref.read(accountFlowProvider(listType)).beginCreate(
          context,
          onFormCreated: (accountForm) {
            onFormCreated?.call(accountForm.toAccountModel());
          },
          createFrom: createFrom,
        );
      },
      label: 'Add Account',
      icon: Icons.add,
    );
  }
}
