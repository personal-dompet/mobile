import 'package:auto_route/auto_route.dart';
import 'package:dompet/core/enum/create_from.dart';
import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/financial_entity_empty.dart';
import 'package:dompet/core/widgets/financial_entity_grid.dart';
import 'package:dompet/features/account/domain/model/account_model.dart';
import 'package:dompet/features/account/presentation/provider/account_filter_provider.dart';
import 'package:dompet/features/account/presentation/provider/account_flow_provider.dart';
import 'package:dompet/features/account/presentation/provider/account_list_provider.dart';
import 'package:dompet/features/transfer/domain/forms/account_transfer_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SelectAccountPage extends ConsumerWidget {
  final int? selectedAccountId;
  final CreateFrom? createFrom;
  final SelectAccountTitle title;
  final bool? disableEmpty;
  const SelectAccountPage({
    super.key,
    this.selectedAccountId,
    this.createFrom,
    this.disableEmpty,
    this.title = SelectAccountTitle.general,
  });

  bool get _disableEmpty =>
      (disableEmpty ?? false) || title == SelectAccountTitle.source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountListProvider);
    final transferForm = ref.watch(accountTransferFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title.label),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: accountsAsync.when(
        data: (data) {
          if (data.isEmpty) {
            return FinancialEntityEmpty(
              onCreate: () async {
                await ref
                    .read(accountFlowProvider(ListType.option))
                    .beginCreate(
                  context,
                  onFormCreated: (pocketForm) {
                    Navigator.of(context).pop<AccountModel>(
                      pocketForm.toAccountModel(),
                    );
                  },
                  createFrom: createFrom,
                );
              },
              filter: ref.watch(accountFilterProvider),
              listType: ListType.filtered,
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: FinancialEntityGrid<AccountModel>(
                    data: data,
                    selectedId: selectedAccountId,
                    listType: ListType.option,
                    destination: transferForm.toAccountValue,
                    source: transferForm.fromAccountValue,
                    disableEmpty: _disableEmpty,
                    onCreate: () async {
                      await ref
                          .read(accountFlowProvider(ListType.option))
                          .beginCreate(
                        context,
                        onFormCreated: (pocketForm) {
                          Navigator.of(context).pop<AccountModel>(
                            pocketForm.toAccountModel(),
                          );
                        },
                        createFrom: createFrom,
                      );
                    },
                    onTap: (pocket) {
                      Navigator.of(context).pop<AccountModel>(pocket);
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

enum SelectAccountTitle {
  destination('destination', 'Select Destination Account'),
  source('source', 'Select Source Account'),
  general('general', 'Select Account');

  final String value;
  final String label;

  const SelectAccountTitle(this.value, this.label);

  static SelectAccountTitle? fromValue(String value) {
    try {
      return SelectAccountTitle.values.firstWhere(
        (status) => status.value.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
