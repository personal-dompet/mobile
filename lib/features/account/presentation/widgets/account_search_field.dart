import 'package:dompet/core/widgets/search_field.dart';
import 'package:dompet/features/account/presentation/provider/account_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSearchField extends ConsumerWidget {
  const AccountSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SearchField(
      onSearch: ({keyword}) {
        final filter = ref.read(accountFilterProvider.notifier);
        filter.setSearchKeyword(keyword);
      },
    );
  }
}
