import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/account/presentation/widgets/account_empty_list.dart';
import 'package:dompet/features/account/presentation/widgets/account_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectAccountPage extends ConsumerWidget {
  final int? selectedAccountId;
  final CreateFrom? createFrom;
  const SelectAccountPage({
    super.key,
    this.selectedAccountId,
    this.createFrom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: accountsAsync.when(
        data: (data) {
          if (data.isEmpty) {
            return AccountEmptyList(
              listType: ListType.option,
              onFormCreated: (account) =>
                  Navigator.of(context).pop<AccountModel>(account),
              createFrom: createFrom,
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
                    listType: ListType.option,
                    createFrom: createFrom,
                    onTap: (account) {
                      Navigator.of(context).pop<AccountModel>(account);
                    },
                    onCreated: (account) {
                      Navigator.of(context).pop<AccountModel>(account);
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
    );
  }
}
