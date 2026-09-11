import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/schemas/schemas.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_filter.freezed.dart';

@freezed
abstract class BillFilter with _$BillFilter {
  const BillFilter._();
  const factory BillFilter({
    int? billPlanId,
    List<String>? statuses,
    String? planName,
  }) = _BillFilter;

  List<String> get whereClauses {
    final clauses = <String>['${BillKey.isDeleted} = 0'];

    if (billPlanId != null) {
      clauses.add('$billTable.${BillKey.billPlanId} = ?');
    }
    if (statuses != null && statuses!.isNotEmpty) {
      final placeholders = List.filled(statuses!.length, '?').join(',');
      clauses.add('$billTable.${BillKey.status} IN ($placeholders)');
    }
    if (planName != null && planName!.trim().isNotEmpty) {
      clauses.add('''
        EXISTS (
          SELECT 1 FROM $billPlanTable
          WHERE $billPlanTable.${BillPlanKey.id} = $billTable.${BillKey.billPlanId}
            AND $billPlanTable.${BillPlanKey.name} LIKE ?
        )
      ''');
    }
    return clauses;
  }

  List<Object?> get arguments {
    final args = <Object?>[];
    if (billPlanId != null) args.add(billPlanId);
    if (statuses != null && statuses!.isNotEmpty) args.addAll(statuses!);
    if (planName != null && planName!.trim().isNotEmpty) {
      args.add('%${planName!.trim()}%');
    }
    return args;
  }
}
