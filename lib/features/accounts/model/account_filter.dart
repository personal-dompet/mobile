import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_filter.freezed.dart';

@freezed
abstract class AccountFilter with _$AccountFilter {
  const AccountFilter._();
  const factory AccountFilter({
    String? name,
    AccountTypeName? type,
    bool? isSystem,
    bool? isLiqid,
  }) = _AccountFilter;

  List<String> get whereClauses {
    final clauses = <String>[];

    if (name != null && name!.isNotEmpty) {
      clauses.add('${AccountKey.name} LIKE ?');
    }

    if (type != null) {
      clauses.add('${AccountKey.type} = ?');
    }

    if (isSystem != null) {
      clauses.add('${AccountKey.isSystem} = ?');
    }

    if (isLiqid != null) {
      clauses.add('${AccountKey.isLiquid} = ?');
    }

    return clauses;
  }

  List<dynamic> get arguments {
    final args = [];

    if (name != null && name!.isNotEmpty) {
      args.add('%${name!.trim()}%');
    }

    if (type != null) {
      args.add(type!.value);
    }

    if (isSystem != null) {
      args.add(isSystem! ? 1 : 0);
    }

    if (isLiqid != null) {
      args.add(isLiqid == true ? 1 : 0);
    }

    return args;
  }
}
