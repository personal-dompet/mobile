import 'package:dompet/features/pocket/domain/forms/pocket_filter_form.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_provider.dart';
import 'package:dompet/core/widgets/item_list_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketSearchField extends ConsumerWidget {
  const PocketSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(pocketFilterFormProvider);

    return ItemListSearchField(
      form: form,
      formControl: form.keyword,
      onSearch: () {
        ref.invalidate(filteredPocketProvider);
      },
    );
  }
}
