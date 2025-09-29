import 'package:dompet/features/account/domain/forms/account_filter_form.dart';
import 'package:dompet/features/account/presentation/provider/account_provider.dart';
import 'package:dompet/core/widgets/item_list_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSearchField extends ConsumerWidget {
  const AccountSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(accountFilterFormProvider);

    return ItemListSearchField(
      form: form,
      formControl: form.keyword,
      onSearch: () {
        ref.invalidate(accountProvider);
      },
    );
  }
}
