import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/model/pocket_model.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_filter_provider.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredPocketListProvider = Provider<List<PocketModel>>((ref) {
  final pocketsAsync = ref.watch(pocketListProvider);
  if (!pocketsAsync.hasValue) return [];
  final filter = ref.watch(pocketFilterProvider);
  final pockets = pocketsAsync.value ?? [];
  return pockets.where((pocket) {
    final keyword = filter.keyword != null ? filter.keyword!.toLowerCase() : '';
    final isNameFound = pocket.name.toLowerCase().contains(keyword);
    if (filter.type == PocketType.all || filter.type == PocketType.wallet) {
      return isNameFound;
    }
    return isNameFound && pocket.type == filter.type;
  }).toList();
});
