import 'package:dompet/core/models/entity_base_type.dart';

class FinancialEntityFilter<T extends EntityBaseType> {
  final String? keyword;
  final T type;

  FinancialEntityFilter({
    required this.type,
    this.keyword,
  });

  FinancialEntityFilter<T> copyWith({
    String? keyword,
    T? type,
  }) {
    return FinancialEntityFilter(
      keyword: keyword ?? this.keyword,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FinancialEntityFilter &&
        other.keyword == keyword &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(keyword, type);
}
