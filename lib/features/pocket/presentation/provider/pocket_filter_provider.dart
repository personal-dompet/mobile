import 'package:dompet/core/models/financial_entity_filter.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:flutter_riverpod/legacy.dart';

class PocketFilterNotifier
    extends StateNotifier<FinancialEntityFilter<PocketType>> {
  PocketFilterNotifier()
      : super(FinancialEntityFilter<PocketType>(type: PocketType.all));

  void setSearchKeyword(String? keyword) {
    state = state.copyWith(keyword: keyword);
  }

  void setSelectedType(PocketType? type) {
    state = state.copyWith(type: type);
  }

  void clearFilters() {
    state = FinancialEntityFilter<PocketType>(type: PocketType.all);
  }
}

final pocketFilterProvider = StateNotifierProvider<PocketFilterNotifier,
    FinancialEntityFilter<PocketType>>((ref) => PocketFilterNotifier());
