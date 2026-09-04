// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saving_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingPlan {

@JsonKey(name: SavingPlanKey.id) int get id;@JsonKey(name: SavingPlanKey.accountId) int get accountId;@JsonKey(name: SavingPlanKey.accountCode) String get accountCode;@JsonKey(name: SavingPlanKey.accountName) String get accountName;@JsonKey(name: SavingPlanKey.iconCode) int? get iconCode;@JsonKey(name: SavingPlanKey.targetAmount) int? get targetAmount;@JsonKey(name: SavingPlanKey.targetDate) int? get targetDate;@JsonKey(name: SavingPlanKey.note) String? get note;@JsonKey(name: SavingPlanKey.status) String get status;@JsonKey(name: SavingPlanKey.balance) int get balance;@JsonKey(name: SavingPlanKey.progress) double? get progress;@JsonKey(name: SavingPlanKey.createdAt) int get createdAt;
/// Create a copy of SavingPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingPlanCopyWith<SavingPlan> get copyWith => _$SavingPlanCopyWithImpl<SavingPlan>(this as SavingPlan, _$identity);

  /// Serializes this SavingPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.note, note) || other.note == note)&&(identical(other.status, status) || other.status == status)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountCode,accountName,iconCode,targetAmount,targetDate,note,status,balance,progress,createdAt);

@override
String toString() {
  return 'SavingPlan(id: $id, accountId: $accountId, accountCode: $accountCode, accountName: $accountName, iconCode: $iconCode, targetAmount: $targetAmount, targetDate: $targetDate, note: $note, status: $status, balance: $balance, progress: $progress, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SavingPlanCopyWith<$Res>  {
  factory $SavingPlanCopyWith(SavingPlan value, $Res Function(SavingPlan) _then) = _$SavingPlanCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: SavingPlanKey.id) int id,@JsonKey(name: SavingPlanKey.accountId) int accountId,@JsonKey(name: SavingPlanKey.accountCode) String accountCode,@JsonKey(name: SavingPlanKey.accountName) String accountName,@JsonKey(name: SavingPlanKey.iconCode) int? iconCode,@JsonKey(name: SavingPlanKey.targetAmount) int? targetAmount,@JsonKey(name: SavingPlanKey.targetDate) int? targetDate,@JsonKey(name: SavingPlanKey.note) String? note,@JsonKey(name: SavingPlanKey.status) String status,@JsonKey(name: SavingPlanKey.balance) int balance,@JsonKey(name: SavingPlanKey.progress) double? progress,@JsonKey(name: SavingPlanKey.createdAt) int createdAt
});




}
/// @nodoc
class _$SavingPlanCopyWithImpl<$Res>
    implements $SavingPlanCopyWith<$Res> {
  _$SavingPlanCopyWithImpl(this._self, this._then);

  final SavingPlan _self;
  final $Res Function(SavingPlan) _then;

/// Create a copy of SavingPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? iconCode = freezed,Object? targetAmount = freezed,Object? targetDate = freezed,Object? note = freezed,Object? status = null,Object? balance = null,Object? progress = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,iconCode: freezed == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as int?,targetAmount: freezed == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingPlan].
extension SavingPlanPatterns on SavingPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingPlan value)  $default,){
final _that = this;
switch (_that) {
case _SavingPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingPlan value)?  $default,){
final _that = this;
switch (_that) {
case _SavingPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: SavingPlanKey.id)  int id, @JsonKey(name: SavingPlanKey.accountId)  int accountId, @JsonKey(name: SavingPlanKey.accountCode)  String accountCode, @JsonKey(name: SavingPlanKey.accountName)  String accountName, @JsonKey(name: SavingPlanKey.iconCode)  int? iconCode, @JsonKey(name: SavingPlanKey.targetAmount)  int? targetAmount, @JsonKey(name: SavingPlanKey.targetDate)  int? targetDate, @JsonKey(name: SavingPlanKey.note)  String? note, @JsonKey(name: SavingPlanKey.status)  String status, @JsonKey(name: SavingPlanKey.balance)  int balance, @JsonKey(name: SavingPlanKey.progress)  double? progress, @JsonKey(name: SavingPlanKey.createdAt)  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingPlan() when $default != null:
return $default(_that.id,_that.accountId,_that.accountCode,_that.accountName,_that.iconCode,_that.targetAmount,_that.targetDate,_that.note,_that.status,_that.balance,_that.progress,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: SavingPlanKey.id)  int id, @JsonKey(name: SavingPlanKey.accountId)  int accountId, @JsonKey(name: SavingPlanKey.accountCode)  String accountCode, @JsonKey(name: SavingPlanKey.accountName)  String accountName, @JsonKey(name: SavingPlanKey.iconCode)  int? iconCode, @JsonKey(name: SavingPlanKey.targetAmount)  int? targetAmount, @JsonKey(name: SavingPlanKey.targetDate)  int? targetDate, @JsonKey(name: SavingPlanKey.note)  String? note, @JsonKey(name: SavingPlanKey.status)  String status, @JsonKey(name: SavingPlanKey.balance)  int balance, @JsonKey(name: SavingPlanKey.progress)  double? progress, @JsonKey(name: SavingPlanKey.createdAt)  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _SavingPlan():
return $default(_that.id,_that.accountId,_that.accountCode,_that.accountName,_that.iconCode,_that.targetAmount,_that.targetDate,_that.note,_that.status,_that.balance,_that.progress,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: SavingPlanKey.id)  int id, @JsonKey(name: SavingPlanKey.accountId)  int accountId, @JsonKey(name: SavingPlanKey.accountCode)  String accountCode, @JsonKey(name: SavingPlanKey.accountName)  String accountName, @JsonKey(name: SavingPlanKey.iconCode)  int? iconCode, @JsonKey(name: SavingPlanKey.targetAmount)  int? targetAmount, @JsonKey(name: SavingPlanKey.targetDate)  int? targetDate, @JsonKey(name: SavingPlanKey.note)  String? note, @JsonKey(name: SavingPlanKey.status)  String status, @JsonKey(name: SavingPlanKey.balance)  int balance, @JsonKey(name: SavingPlanKey.progress)  double? progress, @JsonKey(name: SavingPlanKey.createdAt)  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SavingPlan() when $default != null:
return $default(_that.id,_that.accountId,_that.accountCode,_that.accountName,_that.iconCode,_that.targetAmount,_that.targetDate,_that.note,_that.status,_that.balance,_that.progress,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingPlan extends SavingPlan {
  const _SavingPlan({@JsonKey(name: SavingPlanKey.id) required this.id, @JsonKey(name: SavingPlanKey.accountId) required this.accountId, @JsonKey(name: SavingPlanKey.accountCode) required this.accountCode, @JsonKey(name: SavingPlanKey.accountName) required this.accountName, @JsonKey(name: SavingPlanKey.iconCode) this.iconCode, @JsonKey(name: SavingPlanKey.targetAmount) this.targetAmount, @JsonKey(name: SavingPlanKey.targetDate) this.targetDate, @JsonKey(name: SavingPlanKey.note) this.note, @JsonKey(name: SavingPlanKey.status) this.status = 'ACTIVE', @JsonKey(name: SavingPlanKey.balance) this.balance = 0, @JsonKey(name: SavingPlanKey.progress) this.progress, @JsonKey(name: SavingPlanKey.createdAt) this.createdAt = 0}): super._();
  factory _SavingPlan.fromJson(Map<String, dynamic> json) => _$SavingPlanFromJson(json);

@override@JsonKey(name: SavingPlanKey.id) final  int id;
@override@JsonKey(name: SavingPlanKey.accountId) final  int accountId;
@override@JsonKey(name: SavingPlanKey.accountCode) final  String accountCode;
@override@JsonKey(name: SavingPlanKey.accountName) final  String accountName;
@override@JsonKey(name: SavingPlanKey.iconCode) final  int? iconCode;
@override@JsonKey(name: SavingPlanKey.targetAmount) final  int? targetAmount;
@override@JsonKey(name: SavingPlanKey.targetDate) final  int? targetDate;
@override@JsonKey(name: SavingPlanKey.note) final  String? note;
@override@JsonKey(name: SavingPlanKey.status) final  String status;
@override@JsonKey(name: SavingPlanKey.balance) final  int balance;
@override@JsonKey(name: SavingPlanKey.progress) final  double? progress;
@override@JsonKey(name: SavingPlanKey.createdAt) final  int createdAt;

/// Create a copy of SavingPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingPlanCopyWith<_SavingPlan> get copyWith => __$SavingPlanCopyWithImpl<_SavingPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.note, note) || other.note == note)&&(identical(other.status, status) || other.status == status)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountCode,accountName,iconCode,targetAmount,targetDate,note,status,balance,progress,createdAt);

@override
String toString() {
  return 'SavingPlan(id: $id, accountId: $accountId, accountCode: $accountCode, accountName: $accountName, iconCode: $iconCode, targetAmount: $targetAmount, targetDate: $targetDate, note: $note, status: $status, balance: $balance, progress: $progress, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SavingPlanCopyWith<$Res> implements $SavingPlanCopyWith<$Res> {
  factory _$SavingPlanCopyWith(_SavingPlan value, $Res Function(_SavingPlan) _then) = __$SavingPlanCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: SavingPlanKey.id) int id,@JsonKey(name: SavingPlanKey.accountId) int accountId,@JsonKey(name: SavingPlanKey.accountCode) String accountCode,@JsonKey(name: SavingPlanKey.accountName) String accountName,@JsonKey(name: SavingPlanKey.iconCode) int? iconCode,@JsonKey(name: SavingPlanKey.targetAmount) int? targetAmount,@JsonKey(name: SavingPlanKey.targetDate) int? targetDate,@JsonKey(name: SavingPlanKey.note) String? note,@JsonKey(name: SavingPlanKey.status) String status,@JsonKey(name: SavingPlanKey.balance) int balance,@JsonKey(name: SavingPlanKey.progress) double? progress,@JsonKey(name: SavingPlanKey.createdAt) int createdAt
});




}
/// @nodoc
class __$SavingPlanCopyWithImpl<$Res>
    implements _$SavingPlanCopyWith<$Res> {
  __$SavingPlanCopyWithImpl(this._self, this._then);

  final _SavingPlan _self;
  final $Res Function(_SavingPlan) _then;

/// Create a copy of SavingPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? iconCode = freezed,Object? targetAmount = freezed,Object? targetDate = freezed,Object? note = freezed,Object? status = null,Object? balance = null,Object? progress = freezed,Object? createdAt = null,}) {
  return _then(_SavingPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,iconCode: freezed == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as int?,targetAmount: freezed == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
