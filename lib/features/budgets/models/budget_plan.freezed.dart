// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetPlan {

@JsonKey(name: BudgetPlanKey.id) int get id;@JsonKey(name: BudgetPlanKey.accountId) int get accountId;@JsonKey(name: BudgetPlanKey.amount) int get amount;@JsonKey(name: BudgetPlanKey.note) String? get note;@JsonKey(name: BudgetPlanKey.isDeleted) int get isDeleted;@JsonKey(name: BudgetPlanKey.createdAt) int get createdAt;
/// Create a copy of BudgetPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetPlanCopyWith<BudgetPlan> get copyWith => _$BudgetPlanCopyWithImpl<BudgetPlan>(this as BudgetPlan, _$identity);

  /// Serializes this BudgetPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,amount,note,isDeleted,createdAt);

@override
String toString() {
  return 'BudgetPlan(id: $id, accountId: $accountId, amount: $amount, note: $note, isDeleted: $isDeleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BudgetPlanCopyWith<$Res>  {
  factory $BudgetPlanCopyWith(BudgetPlan value, $Res Function(BudgetPlan) _then) = _$BudgetPlanCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: BudgetPlanKey.id) int id,@JsonKey(name: BudgetPlanKey.accountId) int accountId,@JsonKey(name: BudgetPlanKey.amount) int amount,@JsonKey(name: BudgetPlanKey.note) String? note,@JsonKey(name: BudgetPlanKey.isDeleted) int isDeleted,@JsonKey(name: BudgetPlanKey.createdAt) int createdAt
});




}
/// @nodoc
class _$BudgetPlanCopyWithImpl<$Res>
    implements $BudgetPlanCopyWith<$Res> {
  _$BudgetPlanCopyWithImpl(this._self, this._then);

  final BudgetPlan _self;
  final $Res Function(BudgetPlan) _then;

/// Create a copy of BudgetPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? amount = null,Object? note = freezed,Object? isDeleted = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetPlan].
extension BudgetPlanPatterns on BudgetPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetPlan value)  $default,){
final _that = this;
switch (_that) {
case _BudgetPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetPlan value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: BudgetPlanKey.id)  int id, @JsonKey(name: BudgetPlanKey.accountId)  int accountId, @JsonKey(name: BudgetPlanKey.amount)  int amount, @JsonKey(name: BudgetPlanKey.note)  String? note, @JsonKey(name: BudgetPlanKey.isDeleted)  int isDeleted, @JsonKey(name: BudgetPlanKey.createdAt)  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetPlan() when $default != null:
return $default(_that.id,_that.accountId,_that.amount,_that.note,_that.isDeleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: BudgetPlanKey.id)  int id, @JsonKey(name: BudgetPlanKey.accountId)  int accountId, @JsonKey(name: BudgetPlanKey.amount)  int amount, @JsonKey(name: BudgetPlanKey.note)  String? note, @JsonKey(name: BudgetPlanKey.isDeleted)  int isDeleted, @JsonKey(name: BudgetPlanKey.createdAt)  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _BudgetPlan():
return $default(_that.id,_that.accountId,_that.amount,_that.note,_that.isDeleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: BudgetPlanKey.id)  int id, @JsonKey(name: BudgetPlanKey.accountId)  int accountId, @JsonKey(name: BudgetPlanKey.amount)  int amount, @JsonKey(name: BudgetPlanKey.note)  String? note, @JsonKey(name: BudgetPlanKey.isDeleted)  int isDeleted, @JsonKey(name: BudgetPlanKey.createdAt)  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BudgetPlan() when $default != null:
return $default(_that.id,_that.accountId,_that.amount,_that.note,_that.isDeleted,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetPlan extends BudgetPlan {
  const _BudgetPlan({@JsonKey(name: BudgetPlanKey.id) required this.id, @JsonKey(name: BudgetPlanKey.accountId) required this.accountId, @JsonKey(name: BudgetPlanKey.amount) required this.amount, @JsonKey(name: BudgetPlanKey.note) this.note, @JsonKey(name: BudgetPlanKey.isDeleted) this.isDeleted = 0, @JsonKey(name: BudgetPlanKey.createdAt) this.createdAt = 0}): super._();
  factory _BudgetPlan.fromJson(Map<String, dynamic> json) => _$BudgetPlanFromJson(json);

@override@JsonKey(name: BudgetPlanKey.id) final  int id;
@override@JsonKey(name: BudgetPlanKey.accountId) final  int accountId;
@override@JsonKey(name: BudgetPlanKey.amount) final  int amount;
@override@JsonKey(name: BudgetPlanKey.note) final  String? note;
@override@JsonKey(name: BudgetPlanKey.isDeleted) final  int isDeleted;
@override@JsonKey(name: BudgetPlanKey.createdAt) final  int createdAt;

/// Create a copy of BudgetPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetPlanCopyWith<_BudgetPlan> get copyWith => __$BudgetPlanCopyWithImpl<_BudgetPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,amount,note,isDeleted,createdAt);

@override
String toString() {
  return 'BudgetPlan(id: $id, accountId: $accountId, amount: $amount, note: $note, isDeleted: $isDeleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BudgetPlanCopyWith<$Res> implements $BudgetPlanCopyWith<$Res> {
  factory _$BudgetPlanCopyWith(_BudgetPlan value, $Res Function(_BudgetPlan) _then) = __$BudgetPlanCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: BudgetPlanKey.id) int id,@JsonKey(name: BudgetPlanKey.accountId) int accountId,@JsonKey(name: BudgetPlanKey.amount) int amount,@JsonKey(name: BudgetPlanKey.note) String? note,@JsonKey(name: BudgetPlanKey.isDeleted) int isDeleted,@JsonKey(name: BudgetPlanKey.createdAt) int createdAt
});




}
/// @nodoc
class __$BudgetPlanCopyWithImpl<$Res>
    implements _$BudgetPlanCopyWith<$Res> {
  __$BudgetPlanCopyWithImpl(this._self, this._then);

  final _BudgetPlan _self;
  final $Res Function(_BudgetPlan) _then;

/// Create a copy of BudgetPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? amount = null,Object? note = freezed,Object? isDeleted = null,Object? createdAt = null,}) {
  return _then(_BudgetPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
