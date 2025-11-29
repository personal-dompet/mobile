import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/widgets/entity_type_selector.dart';
import 'package:dompet/core/widgets/financial_entity_list_section.dart';
import 'package:dompet/core/widgets/financial_entity_page.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/account/presentation/provider/account_filter_provider.dart';
import 'package:dompet/features/account/presentation/provider/filtered_account_provider.dart';
import 'package:dompet/features/account/presentation/provider/account_flow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FinancialEntityPage(
      onSearch: ({keyword}) {
        final ref = ProviderScope.containerOf(context);
        final filterNotifier = ref.read(accountFilterProvider.notifier);
        filterNotifier.setSearchKeyword(keyword);
      },
      typeSelector: const _AccountTypeSelector(),
      child: _AccountListSection(),
    );
  }
}

class _AccountTypeSelector extends ConsumerWidget {
  const _AccountTypeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(accountFilterProvider);
    final filterNotifier = ref.read(accountFilterProvider.notifier);

    return EntityTypeSelector<AccountType>(
      types: const [
        AccountType.all,
        AccountType.bank,
        AccountType.cash,
        AccountType.eWallet,
      ],
      filter: filter,
      onSelect: (type) {
        filterNotifier.setSelectedType(type);
      },
    );
  }
}

class _AccountListSection extends ConsumerWidget {
  const _AccountListSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pockets = ref.watch(filteredAccountListProvider);
    final filter = ref.watch(accountFilterProvider);

    return FinancialEntityListSection(
      filter: filter,
      data: pockets,
      onCreate: () async {
        await ref
            .read(
              accountFlowProvider(ListType.filtered),
            )
            .beginCreate(
              context,
            );
      },
      onTap: (selected) {
        // TODO: To detail page
      },
    );
  }
}
