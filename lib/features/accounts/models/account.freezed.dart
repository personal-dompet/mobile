// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Account {

@JsonKey(name: AccountKey.id) int get id;@JsonKey(name: AccountKey.code) String get code;@JsonKey(name: AccountKey.name) String get name;@JsonKey(name: AccountKey.type) AccountType get type;@JsonKey(name: AccountKey.isLiquid)@BoolIntConverter() bool get isLiquid;@JsonKey(name: AccountKey.isDeleted)@BoolIntConverter() bool get isDeleted;@JsonKey(name: AccountKey.isSystem)@BoolIntConverter() bool get isSystem;@JsonKey(name: AccountKey.iconCode) int? get iconCode;@JsonKey(name: AccountKey.normalBalance) BalanceType get normalbalance;@JsonKey(name: AccountKey.balance) int get balance;@JsonKey(name: AccountKey.createdAt) int get createdAt;@JsonKey(name: AccountKey.activeBudgetCount) int get activeBudgetCount;@JsonKey(name: AccountKey.activeBudgetPlanCount) int get activeBudgetPlanCount;
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountCopyWith<Account> get copyWith => _$AccountCopyWithImpl<Account>(this as Account, _$identity);

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Account&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isLiquid, isLiquid) || other.isLiquid == isLiquid)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.normalbalance, normalbalance) || other.normalbalance == normalbalance)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.activeBudgetCount, activeBudgetCount) || other.activeBudgetCount == activeBudgetCount)&&(identical(other.activeBudgetPlanCount, activeBudgetPlanCount) || other.activeBudgetPlanCount == activeBudgetPlanCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,type,isLiquid,isDeleted,isSystem,iconCode,normalbalance,balance,createdAt,activeBudgetCount,activeBudgetPlanCount);

@override
String toString() {
  return 'Account(id: $id, code: $code, name: $name, type: $type, isLiquid: $isLiquid, isDeleted: $isDeleted, isSystem: $isSystem, iconCode: $iconCode, normalbalance: $normalbalance, balance: $balance, createdAt: $createdAt, activeBudgetCount: $activeBudgetCount, activeBudgetPlanCount: $activeBudgetPlanCount)';
}


}

/// @nodoc
abstract mixin class $AccountCopyWith<$Res>  {
  factory $AccountCopyWith(Account value, $Res Function(Account) _then) = _$AccountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: AccountKey.id) int id,@JsonKey(name: AccountKey.code) String code,@JsonKey(name: AccountKey.name) String name,@JsonKey(name: AccountKey.type) AccountType type,@JsonKey(name: AccountKey.isLiquid)@BoolIntConverter() bool isLiquid,@JsonKey(name: AccountKey.isDeleted)@BoolIntConverter() bool isDeleted,@JsonKey(name: AccountKey.isSystem)@BoolIntConverter() bool isSystem,@JsonKey(name: AccountKey.iconCode) int? iconCode,@JsonKey(name: AccountKey.normalBalance) BalanceType normalbalance,@JsonKey(name: AccountKey.balance) int balance,@JsonKey(name: AccountKey.createdAt) int createdAt,@JsonKey(name: AccountKey.activeBudgetCount) int activeBudgetCount,@JsonKey(name: AccountKey.activeBudgetPlanCount) int activeBudgetPlanCount
});




}
/// @nodoc
class _$AccountCopyWithImpl<$Res>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._self, this._then);

  final Account _self;
  final $Res Function(Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? type = null,Object? isLiquid = null,Object? isDeleted = null,Object? isSystem = null,Object? iconCode = freezed,Object? normalbalance = null,Object? balance = null,Object? createdAt = null,Object? activeBudgetCount = null,Object? activeBudgetPlanCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,isLiquid: null == isLiquid ? _self.isLiquid : isLiquid // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,iconCode: freezed == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as int?,normalbalance: null == normalbalance ? _self.normalbalance : normalbalance // ignore: cast_nullable_to_non_nullable
as BalanceType,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,activeBudgetCount: null == activeBudgetCount ? _self.activeBudgetCount : activeBudgetCount // ignore: cast_nullable_to_non_nullable
as int,activeBudgetPlanCount: null == activeBudgetPlanCount ? _self.activeBudgetPlanCount : activeBudgetPlanCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Account].
extension AccountPatterns on Account {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Account value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Account value)  $default,){
final _that = this;
switch (_that) {
case _Account():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Account value)?  $default,){
final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: AccountKey.id)  int id, @JsonKey(name: AccountKey.code)  String code, @JsonKey(name: AccountKey.name)  String name, @JsonKey(name: AccountKey.type)  AccountType type, @JsonKey(name: AccountKey.isLiquid)@BoolIntConverter()  bool isLiquid, @JsonKey(name: AccountKey.isDeleted)@BoolIntConverter()  bool isDeleted, @JsonKey(name: AccountKey.isSystem)@BoolIntConverter()  bool isSystem, @JsonKey(name: AccountKey.iconCode)  int? iconCode, @JsonKey(name: AccountKey.normalBalance)  BalanceType normalbalance, @JsonKey(name: AccountKey.balance)  int balance, @JsonKey(name: AccountKey.createdAt)  int createdAt, @JsonKey(name: AccountKey.activeBudgetCount)  int activeBudgetCount, @JsonKey(name: AccountKey.activeBudgetPlanCount)  int activeBudgetPlanCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.type,_that.isLiquid,_that.isDeleted,_that.isSystem,_that.iconCode,_that.normalbalance,_that.balance,_that.createdAt,_that.activeBudgetCount,_that.activeBudgetPlanCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: AccountKey.id)  int id, @JsonKey(name: AccountKey.code)  String code, @JsonKey(name: AccountKey.name)  String name, @JsonKey(name: AccountKey.type)  AccountType type, @JsonKey(name: AccountKey.isLiquid)@BoolIntConverter()  bool isLiquid, @JsonKey(name: AccountKey.isDeleted)@BoolIntConverter()  bool isDeleted, @JsonKey(name: AccountKey.isSystem)@BoolIntConverter()  bool isSystem, @JsonKey(name: AccountKey.iconCode)  int? iconCode, @JsonKey(name: AccountKey.normalBalance)  BalanceType normalbalance, @JsonKey(name: AccountKey.balance)  int balance, @JsonKey(name: AccountKey.createdAt)  int createdAt, @JsonKey(name: AccountKey.activeBudgetCount)  int activeBudgetCount, @JsonKey(name: AccountKey.activeBudgetPlanCount)  int activeBudgetPlanCount)  $default,) {final _that = this;
switch (_that) {
case _Account():
return $default(_that.id,_that.code,_that.name,_that.type,_that.isLiquid,_that.isDeleted,_that.isSystem,_that.iconCode,_that.normalbalance,_that.balance,_that.createdAt,_that.activeBudgetCount,_that.activeBudgetPlanCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: AccountKey.id)  int id, @JsonKey(name: AccountKey.code)  String code, @JsonKey(name: AccountKey.name)  String name, @JsonKey(name: AccountKey.type)  AccountType type, @JsonKey(name: AccountKey.isLiquid)@BoolIntConverter()  bool isLiquid, @JsonKey(name: AccountKey.isDeleted)@BoolIntConverter()  bool isDeleted, @JsonKey(name: AccountKey.isSystem)@BoolIntConverter()  bool isSystem, @JsonKey(name: AccountKey.iconCode)  int? iconCode, @JsonKey(name: AccountKey.normalBalance)  BalanceType normalbalance, @JsonKey(name: AccountKey.balance)  int balance, @JsonKey(name: AccountKey.createdAt)  int createdAt, @JsonKey(name: AccountKey.activeBudgetCount)  int activeBudgetCount, @JsonKey(name: AccountKey.activeBudgetPlanCount)  int activeBudgetPlanCount)?  $default,) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.type,_that.isLiquid,_that.isDeleted,_that.isSystem,_that.iconCode,_that.normalbalance,_that.balance,_that.createdAt,_that.activeBudgetCount,_that.activeBudgetPlanCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Account implements Account {
  const _Account({@JsonKey(name: AccountKey.id) required this.id, @JsonKey(name: AccountKey.code) required this.code, @JsonKey(name: AccountKey.name) required this.name, @JsonKey(name: AccountKey.type) required this.type, @JsonKey(name: AccountKey.isLiquid)@BoolIntConverter() this.isLiquid = false, @JsonKey(name: AccountKey.isDeleted)@BoolIntConverter() this.isDeleted = false, @JsonKey(name: AccountKey.isSystem)@BoolIntConverter() this.isSystem = false, @JsonKey(name: AccountKey.iconCode) this.iconCode, @JsonKey(name: AccountKey.normalBalance) required this.normalbalance, @JsonKey(name: AccountKey.balance) this.balance = 0, @JsonKey(name: AccountKey.createdAt) required this.createdAt, @JsonKey(name: AccountKey.activeBudgetCount) this.activeBudgetCount = 0, @JsonKey(name: AccountKey.activeBudgetPlanCount) this.activeBudgetPlanCount = 0});
  factory _Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

@override@JsonKey(name: AccountKey.id) final  int id;
@override@JsonKey(name: AccountKey.code) final  String code;
@override@JsonKey(name: AccountKey.name) final  String name;
@override@JsonKey(name: AccountKey.type) final  AccountType type;
@override@JsonKey(name: AccountKey.isLiquid)@BoolIntConverter() final  bool isLiquid;
@override@JsonKey(name: AccountKey.isDeleted)@BoolIntConverter() final  bool isDeleted;
@override@JsonKey(name: AccountKey.isSystem)@BoolIntConverter() final  bool isSystem;
@override@JsonKey(name: AccountKey.iconCode) final  int? iconCode;
@override@JsonKey(name: AccountKey.normalBalance) final  BalanceType normalbalance;
@override@JsonKey(name: AccountKey.balance) final  int balance;
@override@JsonKey(name: AccountKey.createdAt) final  int createdAt;
@override@JsonKey(name: AccountKey.activeBudgetCount) final  int activeBudgetCount;
@override@JsonKey(name: AccountKey.activeBudgetPlanCount) final  int activeBudgetPlanCount;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountCopyWith<_Account> get copyWith => __$AccountCopyWithImpl<_Account>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Account&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isLiquid, isLiquid) || other.isLiquid == isLiquid)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.normalbalance, normalbalance) || other.normalbalance == normalbalance)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.activeBudgetCount, activeBudgetCount) || other.activeBudgetCount == activeBudgetCount)&&(identical(other.activeBudgetPlanCount, activeBudgetPlanCount) || other.activeBudgetPlanCount == activeBudgetPlanCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,type,isLiquid,isDeleted,isSystem,iconCode,normalbalance,balance,createdAt,activeBudgetCount,activeBudgetPlanCount);

@override
String toString() {
  return 'Account(id: $id, code: $code, name: $name, type: $type, isLiquid: $isLiquid, isDeleted: $isDeleted, isSystem: $isSystem, iconCode: $iconCode, normalbalance: $normalbalance, balance: $balance, createdAt: $createdAt, activeBudgetCount: $activeBudgetCount, activeBudgetPlanCount: $activeBudgetPlanCount)';
}


}

/// @nodoc
abstract mixin class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) _then) = __$AccountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: AccountKey.id) int id,@JsonKey(name: AccountKey.code) String code,@JsonKey(name: AccountKey.name) String name,@JsonKey(name: AccountKey.type) AccountType type,@JsonKey(name: AccountKey.isLiquid)@BoolIntConverter() bool isLiquid,@JsonKey(name: AccountKey.isDeleted)@BoolIntConverter() bool isDeleted,@JsonKey(name: AccountKey.isSystem)@BoolIntConverter() bool isSystem,@JsonKey(name: AccountKey.iconCode) int? iconCode,@JsonKey(name: AccountKey.normalBalance) BalanceType normalbalance,@JsonKey(name: AccountKey.balance) int balance,@JsonKey(name: AccountKey.createdAt) int createdAt,@JsonKey(name: AccountKey.activeBudgetCount) int activeBudgetCount,@JsonKey(name: AccountKey.activeBudgetPlanCount) int activeBudgetPlanCount
});




}
/// @nodoc
class __$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(this._self, this._then);

  final _Account _self;
  final $Res Function(_Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? type = null,Object? isLiquid = null,Object? isDeleted = null,Object? isSystem = null,Object? iconCode = freezed,Object? normalbalance = null,Object? balance = null,Object? createdAt = null,Object? activeBudgetCount = null,Object? activeBudgetPlanCount = null,}) {
  return _then(_Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,isLiquid: null == isLiquid ? _self.isLiquid : isLiquid // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,iconCode: freezed == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as int?,normalbalance: null == normalbalance ? _self.normalbalance : normalbalance // ignore: cast_nullable_to_non_nullable
as BalanceType,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,activeBudgetCount: null == activeBudgetCount ? _self.activeBudgetCount : activeBudgetCount // ignore: cast_nullable_to_non_nullable
as int,activeBudgetPlanCount: null == activeBudgetPlanCount ? _self.activeBudgetPlanCount : activeBudgetPlanCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
