// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BillFilter {

 int? get billPlanId; List<String>? get statuses; String? get planName;
/// Create a copy of BillFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillFilterCopyWith<BillFilter> get copyWith => _$BillFilterCopyWithImpl<BillFilter>(this as BillFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillFilter&&(identical(other.billPlanId, billPlanId) || other.billPlanId == billPlanId)&&const DeepCollectionEquality().equals(other.statuses, statuses)&&(identical(other.planName, planName) || other.planName == planName));
}


@override
int get hashCode => Object.hash(runtimeType,billPlanId,const DeepCollectionEquality().hash(statuses),planName);

@override
String toString() {
  return 'BillFilter(billPlanId: $billPlanId, statuses: $statuses, planName: $planName)';
}


}

/// @nodoc
abstract mixin class $BillFilterCopyWith<$Res>  {
  factory $BillFilterCopyWith(BillFilter value, $Res Function(BillFilter) _then) = _$BillFilterCopyWithImpl;
@useResult
$Res call({
 int? billPlanId, List<String>? statuses, String? planName
});




}
/// @nodoc
class _$BillFilterCopyWithImpl<$Res>
    implements $BillFilterCopyWith<$Res> {
  _$BillFilterCopyWithImpl(this._self, this._then);

  final BillFilter _self;
  final $Res Function(BillFilter) _then;

/// Create a copy of BillFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? billPlanId = freezed,Object? statuses = freezed,Object? planName = freezed,}) {
  return _then(_self.copyWith(
billPlanId: freezed == billPlanId ? _self.billPlanId : billPlanId // ignore: cast_nullable_to_non_nullable
as int?,statuses: freezed == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<String>?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BillFilter].
extension BillFilterPatterns on BillFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillFilter value)  $default,){
final _that = this;
switch (_that) {
case _BillFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillFilter value)?  $default,){
final _that = this;
switch (_that) {
case _BillFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? billPlanId,  List<String>? statuses,  String? planName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillFilter() when $default != null:
return $default(_that.billPlanId,_that.statuses,_that.planName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? billPlanId,  List<String>? statuses,  String? planName)  $default,) {final _that = this;
switch (_that) {
case _BillFilter():
return $default(_that.billPlanId,_that.statuses,_that.planName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? billPlanId,  List<String>? statuses,  String? planName)?  $default,) {final _that = this;
switch (_that) {
case _BillFilter() when $default != null:
return $default(_that.billPlanId,_that.statuses,_that.planName);case _:
  return null;

}
}

}

/// @nodoc


class _BillFilter extends BillFilter {
  const _BillFilter({this.billPlanId, final  List<String>? statuses, this.planName}): _statuses = statuses,super._();
  

@override final  int? billPlanId;
 final  List<String>? _statuses;
@override List<String>? get statuses {
  final value = _statuses;
  if (value == null) return null;
  if (_statuses is EqualUnmodifiableListView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? planName;

/// Create a copy of BillFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillFilterCopyWith<_BillFilter> get copyWith => __$BillFilterCopyWithImpl<_BillFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillFilter&&(identical(other.billPlanId, billPlanId) || other.billPlanId == billPlanId)&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&(identical(other.planName, planName) || other.planName == planName));
}


@override
int get hashCode => Object.hash(runtimeType,billPlanId,const DeepCollectionEquality().hash(_statuses),planName);

@override
String toString() {
  return 'BillFilter(billPlanId: $billPlanId, statuses: $statuses, planName: $planName)';
}


}

/// @nodoc
abstract mixin class _$BillFilterCopyWith<$Res> implements $BillFilterCopyWith<$Res> {
  factory _$BillFilterCopyWith(_BillFilter value, $Res Function(_BillFilter) _then) = __$BillFilterCopyWithImpl;
@override @useResult
$Res call({
 int? billPlanId, List<String>? statuses, String? planName
});




}
/// @nodoc
class __$BillFilterCopyWithImpl<$Res>
    implements _$BillFilterCopyWith<$Res> {
  __$BillFilterCopyWithImpl(this._self, this._then);

  final _BillFilter _self;
  final $Res Function(_BillFilter) _then;

/// Create a copy of BillFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? billPlanId = freezed,Object? statuses = freezed,Object? planName = freezed,}) {
  return _then(_BillFilter(
billPlanId: freezed == billPlanId ? _self.billPlanId : billPlanId // ignore: cast_nullable_to_non_nullable
as int?,statuses: freezed == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<String>?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
