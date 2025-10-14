import 'package:dompet/core/widgets/search_field.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketSearchField extends ConsumerWidget {
  const PocketSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SearchField(
      onSearch: ({keyword}) {
        final filter = ref.read(pocketFilterProvider.notifier);
        filter.setSearchKeyword(keyword);
      },
    );
  }
}
