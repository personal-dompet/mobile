import 'package:dompet_app/core/constants/field_keys/field_key.dart';
import 'package:dompet_app/core/converters/bool_int_converter.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({
    @JsonKey(name: AccountKey.id) required int id,
    @JsonKey(name: AccountKey.code) required String code,
    @JsonKey(name: AccountKey.name) required String name,
    @JsonKey(name: AccountKey.type) required AccountTypeName type,

    @JsonKey(name: AccountKey.isLiquid)
    @BoolIntConverter()
    @Default(false)
    bool isLiquid,

    @JsonKey(name: AccountKey.isDeleted)
    @BoolIntConverter()
    @Default(false)
    bool isDeleted,

    @JsonKey(name: AccountKey.isSystem)
    @BoolIntConverter()
    @Default(false)
    bool isSystem,

    @JsonKey(name: AccountKey.iconCode) int? iconCode,

    @JsonKey(name: AccountKey.normalBalance) required BalanceType normalbalance,

    @JsonKey(name: AccountKey.balance) @Default(0) int balance,

    @JsonKey(name: AccountKey.createdAt) required int createdAt,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
