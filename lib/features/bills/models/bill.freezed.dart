// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bill {

@JsonKey(name: BillKey.id) int get id;@JsonKey(name: BillKey.billPlanId) int get billPlanId;@JsonKey(name: BillKey.amount) int get amount;@JsonKey(name: BillKey.billPeriod) String get billPeriod;@JsonKey(name: BillKey.billedAt) int get billedAt;@JsonKey(name: BillKey.dueDate) int get dueDate;@JsonKey(name: BillKey.remindedAt) int get remindedAt;@JsonKey(name: BillKey.status) String get status;@JsonKey(name: BillKey.isDeleted) int get isDeleted;@JsonKey(name: BillKey.createdAt) int get createdAt;
/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillCopyWith<Bill> get copyWith => _$BillCopyWithImpl<Bill>(this as Bill, _$identity);

  /// Serializes this Bill to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bill&&(identical(other.id, id) || other.id == id)&&(identical(other.billPlanId, billPlanId) || other.billPlanId == billPlanId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.billPeriod, billPeriod) || other.billPeriod == billPeriod)&&(identical(other.billedAt, billedAt) || other.billedAt == billedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.remindedAt, remindedAt) || other.remindedAt == remindedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,billPlanId,amount,billPeriod,billedAt,dueDate,remindedAt,status,isDeleted,createdAt);

@override
String toString() {
  return 'Bill(id: $id, billPlanId: $billPlanId, amount: $amount, billPeriod: $billPeriod, billedAt: $billedAt, dueDate: $dueDate, remindedAt: $remindedAt, status: $status, isDeleted: $isDeleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BillCopyWith<$Res>  {
  factory $BillCopyWith(Bill value, $Res Function(Bill) _then) = _$BillCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: BillKey.id) int id,@JsonKey(name: BillKey.billPlanId) int billPlanId,@JsonKey(name: BillKey.amount) int amount,@JsonKey(name: BillKey.billPeriod) String billPeriod,@JsonKey(name: BillKey.billedAt) int billedAt,@JsonKey(name: BillKey.dueDate) int dueDate,@JsonKey(name: BillKey.remindedAt) int remindedAt,@JsonKey(name: BillKey.status) String status,@JsonKey(name: BillKey.isDeleted) int isDeleted,@JsonKey(name: BillKey.createdAt) int createdAt
});




}
/// @nodoc
class _$BillCopyWithImpl<$Res>
    implements $BillCopyWith<$Res> {
  _$BillCopyWithImpl(this._self, this._then);

  final Bill _self;
  final $Res Function(Bill) _then;

/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? billPlanId = null,Object? amount = null,Object? billPeriod = null,Object? billedAt = null,Object? dueDate = null,Object? remindedAt = null,Object? status = null,Object? isDeleted = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,billPlanId: null == billPlanId ? _self.billPlanId : billPlanId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,billPeriod: null == billPeriod ? _self.billPeriod : billPeriod // ignore: cast_nullable_to_non_nullable
as String,billedAt: null == billedAt ? _self.billedAt : billedAt // ignore: cast_nullable_to_non_nullable
as int,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as int,remindedAt: null == remindedAt ? _self.remindedAt : remindedAt // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Bill].
extension BillPatterns on Bill {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bill value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bill() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bill value)  $default,){
final _that = this;
switch (_that) {
case _Bill():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bill value)?  $default,){
final _that = this;
switch (_that) {
case _Bill() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: BillKey.id)  int id, @JsonKey(name: BillKey.billPlanId)  int billPlanId, @JsonKey(name: BillKey.amount)  int amount, @JsonKey(name: BillKey.billPeriod)  String billPeriod, @JsonKey(name: BillKey.billedAt)  int billedAt, @JsonKey(name: BillKey.dueDate)  int dueDate, @JsonKey(name: BillKey.remindedAt)  int remindedAt, @JsonKey(name: BillKey.status)  String status, @JsonKey(name: BillKey.isDeleted)  int isDeleted, @JsonKey(name: BillKey.createdAt)  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bill() when $default != null:
return $default(_that.id,_that.billPlanId,_that.amount,_that.billPeriod,_that.billedAt,_that.dueDate,_that.remindedAt,_that.status,_that.isDeleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: BillKey.id)  int id, @JsonKey(name: BillKey.billPlanId)  int billPlanId, @JsonKey(name: BillKey.amount)  int amount, @JsonKey(name: BillKey.billPeriod)  String billPeriod, @JsonKey(name: BillKey.billedAt)  int billedAt, @JsonKey(name: BillKey.dueDate)  int dueDate, @JsonKey(name: BillKey.remindedAt)  int remindedAt, @JsonKey(name: BillKey.status)  String status, @JsonKey(name: BillKey.isDeleted)  int isDeleted, @JsonKey(name: BillKey.createdAt)  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _Bill():
return $default(_that.id,_that.billPlanId,_that.amount,_that.billPeriod,_that.billedAt,_that.dueDate,_that.remindedAt,_that.status,_that.isDeleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: BillKey.id)  int id, @JsonKey(name: BillKey.billPlanId)  int billPlanId, @JsonKey(name: BillKey.amount)  int amount, @JsonKey(name: BillKey.billPeriod)  String billPeriod, @JsonKey(name: BillKey.billedAt)  int billedAt, @JsonKey(name: BillKey.dueDate)  int dueDate, @JsonKey(name: BillKey.remindedAt)  int remindedAt, @JsonKey(name: BillKey.status)  String status, @JsonKey(name: BillKey.isDeleted)  int isDeleted, @JsonKey(name: BillKey.createdAt)  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Bill() when $default != null:
return $default(_that.id,_that.billPlanId,_that.amount,_that.billPeriod,_that.billedAt,_that.dueDate,_that.remindedAt,_that.status,_that.isDeleted,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Bill extends Bill {
  const _Bill({@JsonKey(name: BillKey.id) required this.id, @JsonKey(name: BillKey.billPlanId) required this.billPlanId, @JsonKey(name: BillKey.amount) required this.amount, @JsonKey(name: BillKey.billPeriod) required this.billPeriod, @JsonKey(name: BillKey.billedAt) required this.billedAt, @JsonKey(name: BillKey.dueDate) required this.dueDate, @JsonKey(name: BillKey.remindedAt) required this.remindedAt, @JsonKey(name: BillKey.status) required this.status, @JsonKey(name: BillKey.isDeleted) this.isDeleted = 0, @JsonKey(name: BillKey.createdAt) this.createdAt = 0}): super._();
  factory _Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

@override@JsonKey(name: BillKey.id) final  int id;
@override@JsonKey(name: BillKey.billPlanId) final  int billPlanId;
@override@JsonKey(name: BillKey.amount) final  int amount;
@override@JsonKey(name: BillKey.billPeriod) final  String billPeriod;
@override@JsonKey(name: BillKey.billedAt) final  int billedAt;
@override@JsonKey(name: BillKey.dueDate) final  int dueDate;
@override@JsonKey(name: BillKey.remindedAt) final  int remindedAt;
@override@JsonKey(name: BillKey.status) final  String status;
@override@JsonKey(name: BillKey.isDeleted) final  int isDeleted;
@override@JsonKey(name: BillKey.createdAt) final  int createdAt;

/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillCopyWith<_Bill> get copyWith => __$BillCopyWithImpl<_Bill>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bill&&(identical(other.id, id) || other.id == id)&&(identical(other.billPlanId, billPlanId) || other.billPlanId == billPlanId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.billPeriod, billPeriod) || other.billPeriod == billPeriod)&&(identical(other.billedAt, billedAt) || other.billedAt == billedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.remindedAt, remindedAt) || other.remindedAt == remindedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,billPlanId,amount,billPeriod,billedAt,dueDate,remindedAt,status,isDeleted,createdAt);

@override
String toString() {
  return 'Bill(id: $id, billPlanId: $billPlanId, amount: $amount, billPeriod: $billPeriod, billedAt: $billedAt, dueDate: $dueDate, remindedAt: $remindedAt, status: $status, isDeleted: $isDeleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BillCopyWith<$Res> implements $BillCopyWith<$Res> {
  factory _$BillCopyWith(_Bill value, $Res Function(_Bill) _then) = __$BillCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: BillKey.id) int id,@JsonKey(name: BillKey.billPlanId) int billPlanId,@JsonKey(name: BillKey.amount) int amount,@JsonKey(name: BillKey.billPeriod) String billPeriod,@JsonKey(name: BillKey.billedAt) int billedAt,@JsonKey(name: BillKey.dueDate) int dueDate,@JsonKey(name: BillKey.remindedAt) int remindedAt,@JsonKey(name: BillKey.status) String status,@JsonKey(name: BillKey.isDeleted) int isDeleted,@JsonKey(name: BillKey.createdAt) int createdAt
});




}
/// @nodoc
class __$BillCopyWithImpl<$Res>
    implements _$BillCopyWith<$Res> {
  __$BillCopyWithImpl(this._self, this._then);

  final _Bill _self;
  final $Res Function(_Bill) _then;

/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? billPlanId = null,Object? amount = null,Object? billPeriod = null,Object? billedAt = null,Object? dueDate = null,Object? remindedAt = null,Object? status = null,Object? isDeleted = null,Object? createdAt = null,}) {
  return _then(_Bill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,billPlanId: null == billPlanId ? _self.billPlanId : billPlanId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,billPeriod: null == billPeriod ? _self.billPeriod : billPeriod // ignore: cast_nullable_to_non_nullable
as String,billedAt: null == billedAt ? _self.billedAt : billedAt // ignore: cast_nullable_to_non_nullable
as int,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as int,remindedAt: null == remindedAt ? _self.remindedAt : remindedAt // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
