import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:flutter_riverpod/legacy.dart';

class PocketFilter {
  final String? keyword;
  final PocketType type;

  PocketFilter({
    this.keyword,
    this.type = PocketType.all,
  });

  PocketFilter copyWith({
    String? keyword,
    PocketType? type,
  }) {
    return PocketFilter(
      keyword: keyword ?? this.keyword,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PocketFilter &&
        other.keyword == keyword &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(keyword, type);
}

class PocketFilterNotifier extends StateNotifier<PocketFilter> {
  PocketFilterNotifier() : super(PocketFilter());

  void setSearchKeyword(String? keyword) {
    state = state.copyWith(keyword: keyword);
  }

  void setSelectedType(PocketType? type) {
    state = state.copyWith(type: type);
  }

  void clearFilters() {
    state = PocketFilter();
  }
}

final pocketFilterProvider =
    StateNotifierProvider<PocketFilterNotifier, PocketFilter>(
        (ref) => PocketFilterNotifier());
