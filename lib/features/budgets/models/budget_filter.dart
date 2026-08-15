import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_filter.freezed.dart';

@freezed
abstract class BudgetFilter with _$BudgetFilter {
  const BudgetFilter._();
  const factory BudgetFilter({String? accountName}) = _BudgetFilter;

  List<String> get whereClauses {
    final clauses = <String>[];

    if (accountName != null && accountName!.isNotEmpty) {
      clauses.add('${BudgetKey.accountName} LIKE ?');
    }

    return clauses;
  }

  List<dynamic> get arguments {
    final args = [];

    if (accountName != null && accountName!.isNotEmpty) {
      args.add('%${accountName!.trim()}%');
    }

    return args;
  }
}
