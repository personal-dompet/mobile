import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/database/views/views.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saving_filter.freezed.dart';

@freezed
abstract class SavingFilter with _$SavingFilter {
  const SavingFilter._();
  const factory SavingFilter({String? accountName, String? status}) =
      _SavingFilter;

  List<String> get whereClauses {
    final clauses = <String>[];

    if (accountName != null && accountName!.isNotEmpty) {
      clauses.add('${SavingPlanKey.accountName} LIKE ?');
    }

    if (status != null && status!.isNotEmpty) {
      // Kolom view, bukan tabel: outer query atas view tidak bisa
      // memakai kualifikasi `saving_plans.`.
      clauses.add('$savingTrackerView.${SavingPlanKey.status} = ?');
    }

    return clauses;
  }

  List<dynamic> get arguments {
    final args = [];

    if (accountName != null && accountName!.isNotEmpty) {
      args.add('%${accountName!.trim()}%');
    }

    if (status != null && status!.isNotEmpty) {
      args.add(status);
    }

    return args;
  }
}
