// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillPlan {

@JsonKey(name: BillPlanKey.id) int get id;@JsonKey(name: BillPlanKey.accountId) int get accountId;@JsonKey(name: BillPlanKey.name) String get name;@JsonKey(name: BillPlanKey.amount) int get amount;@JsonKey(name: BillPlanKey.period) String get period;@JsonKey(name: BillPlanKey.billedSchedule) String get billedSchedule;@JsonKey(name: BillPlanKey.dueDateSchedule) String get dueDateSchedule;@JsonKey(name: BillPlanKey.reminderDays) int? get reminderDays;@JsonKey(name: BillPlanKey.endedAt) int? get endedAt;@JsonKey(name: BillPlanKey.reference) String? get reference;@JsonKey(name: BillPlanKey.note) String? get note;@JsonKey(name: BillPlanKey.isDeleted) int get isDeleted;@JsonKey(name: BillPlanKey.createdAt) int get createdAt;
/// Create a copy of BillPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillPlanCopyWith<BillPlan> get copyWith => _$BillPlanCopyWithImpl<BillPlan>(this as BillPlan, _$identity);

  /// Serializes this BillPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.period, period) || other.period == period)&&(identical(other.billedSchedule, billedSchedule) || other.billedSchedule == billedSchedule)&&(identical(other.dueDateSchedule, dueDateSchedule) || other.dueDateSchedule == dueDateSchedule)&&(identical(other.reminderDays, reminderDays) || other.reminderDays == reminderDays)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.note, note) || other.note == note)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,name,amount,period,billedSchedule,dueDateSchedule,reminderDays,endedAt,reference,note,isDeleted,createdAt);

@override
String toString() {
  return 'BillPlan(id: $id, accountId: $accountId, name: $name, amount: $amount, period: $period, billedSchedule: $billedSchedule, dueDateSchedule: $dueDateSchedule, reminderDays: $reminderDays, endedAt: $endedAt, reference: $reference, note: $note, isDeleted: $isDeleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BillPlanCopyWith<$Res>  {
  factory $BillPlanCopyWith(BillPlan value, $Res Function(BillPlan) _then) = _$BillPlanCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: BillPlanKey.id) int id,@JsonKey(name: BillPlanKey.accountId) int accountId,@JsonKey(name: BillPlanKey.name) String name,@JsonKey(name: BillPlanKey.amount) int amount,@JsonKey(name: BillPlanKey.period) String period,@JsonKey(name: BillPlanKey.billedSchedule) String billedSchedule,@JsonKey(name: BillPlanKey.dueDateSchedule) String dueDateSchedule,@JsonKey(name: BillPlanKey.reminderDays) int? reminderDays,@JsonKey(name: BillPlanKey.endedAt) int? endedAt,@JsonKey(name: BillPlanKey.reference) String? reference,@JsonKey(name: BillPlanKey.note) String? note,@JsonKey(name: BillPlanKey.isDeleted) int isDeleted,@JsonKey(name: BillPlanKey.createdAt) int createdAt
});




}
/// @nodoc
class _$BillPlanCopyWithImpl<$Res>
    implements $BillPlanCopyWith<$Res> {
  _$BillPlanCopyWithImpl(this._self, this._then);

  final BillPlan _self;
  final $Res Function(BillPlan) _then;

/// Create a copy of BillPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? name = null,Object? amount = null,Object? period = null,Object? billedSchedule = null,Object? dueDateSchedule = null,Object? reminderDays = freezed,Object? endedAt = freezed,Object? reference = freezed,Object? note = freezed,Object? isDeleted = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,billedSchedule: null == billedSchedule ? _self.billedSchedule : billedSchedule // ignore: cast_nullable_to_non_nullable
as String,dueDateSchedule: null == dueDateSchedule ? _self.dueDateSchedule : dueDateSchedule // ignore: cast_nullable_to_non_nullable
as String,reminderDays: freezed == reminderDays ? _self.reminderDays : reminderDays // ignore: cast_nullable_to_non_nullable
as int?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as int?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BillPlan].
extension BillPlanPatterns on BillPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillPlan value)  $default,){
final _that = this;
switch (_that) {
case _BillPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillPlan value)?  $default,){
final _that = this;
switch (_that) {
case _BillPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: BillPlanKey.id)  int id, @JsonKey(name: BillPlanKey.accountId)  int accountId, @JsonKey(name: BillPlanKey.name)  String name, @JsonKey(name: BillPlanKey.amount)  int amount, @JsonKey(name: BillPlanKey.period)  String period, @JsonKey(name: BillPlanKey.billedSchedule)  String billedSchedule, @JsonKey(name: BillPlanKey.dueDateSchedule)  String dueDateSchedule, @JsonKey(name: BillPlanKey.reminderDays)  int? reminderDays, @JsonKey(name: BillPlanKey.endedAt)  int? endedAt, @JsonKey(name: BillPlanKey.reference)  String? reference, @JsonKey(name: BillPlanKey.note)  String? note, @JsonKey(name: BillPlanKey.isDeleted)  int isDeleted, @JsonKey(name: BillPlanKey.createdAt)  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillPlan() when $default != null:
return $default(_that.id,_that.accountId,_that.name,_that.amount,_that.period,_that.billedSchedule,_that.dueDateSchedule,_that.reminderDays,_that.endedAt,_that.reference,_that.note,_that.isDeleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: BillPlanKey.id)  int id, @JsonKey(name: BillPlanKey.accountId)  int accountId, @JsonKey(name: BillPlanKey.name)  String name, @JsonKey(name: BillPlanKey.amount)  int amount, @JsonKey(name: BillPlanKey.period)  String period, @JsonKey(name: BillPlanKey.billedSchedule)  String billedSchedule, @JsonKey(name: BillPlanKey.dueDateSchedule)  String dueDateSchedule, @JsonKey(name: BillPlanKey.reminderDays)  int? reminderDays, @JsonKey(name: BillPlanKey.endedAt)  int? endedAt, @JsonKey(name: BillPlanKey.reference)  String? reference, @JsonKey(name: BillPlanKey.note)  String? note, @JsonKey(name: BillPlanKey.isDeleted)  int isDeleted, @JsonKey(name: BillPlanKey.createdAt)  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _BillPlan():
return $default(_that.id,_that.accountId,_that.name,_that.amount,_that.period,_that.billedSchedule,_that.dueDateSchedule,_that.reminderDays,_that.endedAt,_that.reference,_that.note,_that.isDeleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: BillPlanKey.id)  int id, @JsonKey(name: BillPlanKey.accountId)  int accountId, @JsonKey(name: BillPlanKey.name)  String name, @JsonKey(name: BillPlanKey.amount)  int amount, @JsonKey(name: BillPlanKey.period)  String period, @JsonKey(name: BillPlanKey.billedSchedule)  String billedSchedule, @JsonKey(name: BillPlanKey.dueDateSchedule)  String dueDateSchedule, @JsonKey(name: BillPlanKey.reminderDays)  int? reminderDays, @JsonKey(name: BillPlanKey.endedAt)  int? endedAt, @JsonKey(name: BillPlanKey.reference)  String? reference, @JsonKey(name: BillPlanKey.note)  String? note, @JsonKey(name: BillPlanKey.isDeleted)  int isDeleted, @JsonKey(name: BillPlanKey.createdAt)  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BillPlan() when $default != null:
return $default(_that.id,_that.accountId,_that.name,_that.amount,_that.period,_that.billedSchedule,_that.dueDateSchedule,_that.reminderDays,_that.endedAt,_that.reference,_that.note,_that.isDeleted,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillPlan extends BillPlan {
  const _BillPlan({@JsonKey(name: BillPlanKey.id) required this.id, @JsonKey(name: BillPlanKey.accountId) required this.accountId, @JsonKey(name: BillPlanKey.name) required this.name, @JsonKey(name: BillPlanKey.amount) required this.amount, @JsonKey(name: BillPlanKey.period) required this.period, @JsonKey(name: BillPlanKey.billedSchedule) required this.billedSchedule, @JsonKey(name: BillPlanKey.dueDateSchedule) required this.dueDateSchedule, @JsonKey(name: BillPlanKey.reminderDays) this.reminderDays, @JsonKey(name: BillPlanKey.endedAt) this.endedAt, @JsonKey(name: BillPlanKey.reference) this.reference, @JsonKey(name: BillPlanKey.note) this.note, @JsonKey(name: BillPlanKey.isDeleted) this.isDeleted = 0, @JsonKey(name: BillPlanKey.createdAt) this.createdAt = 0}): super._();
  factory _BillPlan.fromJson(Map<String, dynamic> json) => _$BillPlanFromJson(json);

@override@JsonKey(name: BillPlanKey.id) final  int id;
@override@JsonKey(name: BillPlanKey.accountId) final  int accountId;
@override@JsonKey(name: BillPlanKey.name) final  String name;
@override@JsonKey(name: BillPlanKey.amount) final  int amount;
@override@JsonKey(name: BillPlanKey.period) final  String period;
@override@JsonKey(name: BillPlanKey.billedSchedule) final  String billedSchedule;
@override@JsonKey(name: BillPlanKey.dueDateSchedule) final  String dueDateSchedule;
@override@JsonKey(name: BillPlanKey.reminderDays) final  int? reminderDays;
@override@JsonKey(name: BillPlanKey.endedAt) final  int? endedAt;
@override@JsonKey(name: BillPlanKey.reference) final  String? reference;
@override@JsonKey(name: BillPlanKey.note) final  String? note;
@override@JsonKey(name: BillPlanKey.isDeleted) final  int isDeleted;
@override@JsonKey(name: BillPlanKey.createdAt) final  int createdAt;

/// Create a copy of BillPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillPlanCopyWith<_BillPlan> get copyWith => __$BillPlanCopyWithImpl<_BillPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.period, period) || other.period == period)&&(identical(other.billedSchedule, billedSchedule) || other.billedSchedule == billedSchedule)&&(identical(other.dueDateSchedule, dueDateSchedule) || other.dueDateSchedule == dueDateSchedule)&&(identical(other.reminderDays, reminderDays) || other.reminderDays == reminderDays)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.note, note) || other.note == note)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,name,amount,period,billedSchedule,dueDateSchedule,reminderDays,endedAt,reference,note,isDeleted,createdAt);

@override
String toString() {
  return 'BillPlan(id: $id, accountId: $accountId, name: $name, amount: $amount, period: $period, billedSchedule: $billedSchedule, dueDateSchedule: $dueDateSchedule, reminderDays: $reminderDays, endedAt: $endedAt, reference: $reference, note: $note, isDeleted: $isDeleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BillPlanCopyWith<$Res> implements $BillPlanCopyWith<$Res> {
  factory _$BillPlanCopyWith(_BillPlan value, $Res Function(_BillPlan) _then) = __$BillPlanCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: BillPlanKey.id) int id,@JsonKey(name: BillPlanKey.accountId) int accountId,@JsonKey(name: BillPlanKey.name) String name,@JsonKey(name: BillPlanKey.amount) int amount,@JsonKey(name: BillPlanKey.period) String period,@JsonKey(name: BillPlanKey.billedSchedule) String billedSchedule,@JsonKey(name: BillPlanKey.dueDateSchedule) String dueDateSchedule,@JsonKey(name: BillPlanKey.reminderDays) int? reminderDays,@JsonKey(name: BillPlanKey.endedAt) int? endedAt,@JsonKey(name: BillPlanKey.reference) String? reference,@JsonKey(name: BillPlanKey.note) String? note,@JsonKey(name: BillPlanKey.isDeleted) int isDeleted,@JsonKey(name: BillPlanKey.createdAt) int createdAt
});




}
/// @nodoc
class __$BillPlanCopyWithImpl<$Res>
    implements _$BillPlanCopyWith<$Res> {
  __$BillPlanCopyWithImpl(this._self, this._then);

  final _BillPlan _self;
  final $Res Function(_BillPlan) _then;

/// Create a copy of BillPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? name = null,Object? amount = null,Object? period = null,Object? billedSchedule = null,Object? dueDateSchedule = null,Object? reminderDays = freezed,Object? endedAt = freezed,Object? reference = freezed,Object? note = freezed,Object? isDeleted = null,Object? createdAt = null,}) {
  return _then(_BillPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,billedSchedule: null == billedSchedule ? _self.billedSchedule : billedSchedule // ignore: cast_nullable_to_non_nullable
as String,dueDateSchedule: null == dueDateSchedule ? _self.dueDateSchedule : dueDateSchedule // ignore: cast_nullable_to_non_nullable
as String,reminderDays: freezed == reminderDays ? _self.reminderDays : reminderDays // ignore: cast_nullable_to_non_nullable
as int?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as int?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
