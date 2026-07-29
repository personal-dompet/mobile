// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityFilter {

 String? get description; ActivityType? get type; (DateTime, DateTime)? get dates; int? get accountId;
/// Create a copy of ActivityFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityFilterCopyWith<ActivityFilter> get copyWith => _$ActivityFilterCopyWithImpl<ActivityFilter>(this as ActivityFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityFilter&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.dates, dates) || other.dates == dates)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}


@override
int get hashCode => Object.hash(runtimeType,description,type,dates,accountId);

@override
String toString() {
  return 'ActivityFilter(description: $description, type: $type, dates: $dates, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class $ActivityFilterCopyWith<$Res>  {
  factory $ActivityFilterCopyWith(ActivityFilter value, $Res Function(ActivityFilter) _then) = _$ActivityFilterCopyWithImpl;
@useResult
$Res call({
 String? description, ActivityType? type, (DateTime, DateTime)? dates, int? accountId
});




}
/// @nodoc
class _$ActivityFilterCopyWithImpl<$Res>
    implements $ActivityFilterCopyWith<$Res> {
  _$ActivityFilterCopyWithImpl(this._self, this._then);

  final ActivityFilter _self;
  final $Res Function(ActivityFilter) _then;

/// Create a copy of ActivityFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? description = freezed,Object? type = freezed,Object? dates = freezed,Object? accountId = freezed,}) {
  return _then(_self.copyWith(
description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType?,dates: freezed == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as (DateTime, DateTime)?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityFilter].
extension ActivityFilterPatterns on ActivityFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityFilter value)  $default,){
final _that = this;
switch (_that) {
case _ActivityFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityFilter value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? description,  ActivityType? type,  (DateTime, DateTime)? dates,  int? accountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityFilter() when $default != null:
return $default(_that.description,_that.type,_that.dates,_that.accountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? description,  ActivityType? type,  (DateTime, DateTime)? dates,  int? accountId)  $default,) {final _that = this;
switch (_that) {
case _ActivityFilter():
return $default(_that.description,_that.type,_that.dates,_that.accountId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? description,  ActivityType? type,  (DateTime, DateTime)? dates,  int? accountId)?  $default,) {final _that = this;
switch (_that) {
case _ActivityFilter() when $default != null:
return $default(_that.description,_that.type,_that.dates,_that.accountId);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityFilter extends ActivityFilter {
  const _ActivityFilter({this.description, this.type, this.dates, this.accountId}): super._();
  

@override final  String? description;
@override final  ActivityType? type;
@override final  (DateTime, DateTime)? dates;
@override final  int? accountId;

/// Create a copy of ActivityFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityFilterCopyWith<_ActivityFilter> get copyWith => __$ActivityFilterCopyWithImpl<_ActivityFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityFilter&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.dates, dates) || other.dates == dates)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}


@override
int get hashCode => Object.hash(runtimeType,description,type,dates,accountId);

@override
String toString() {
  return 'ActivityFilter(description: $description, type: $type, dates: $dates, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class _$ActivityFilterCopyWith<$Res> implements $ActivityFilterCopyWith<$Res> {
  factory _$ActivityFilterCopyWith(_ActivityFilter value, $Res Function(_ActivityFilter) _then) = __$ActivityFilterCopyWithImpl;
@override @useResult
$Res call({
 String? description, ActivityType? type, (DateTime, DateTime)? dates, int? accountId
});




}
/// @nodoc
class __$ActivityFilterCopyWithImpl<$Res>
    implements _$ActivityFilterCopyWith<$Res> {
  __$ActivityFilterCopyWithImpl(this._self, this._then);

  final _ActivityFilter _self;
  final $Res Function(_ActivityFilter) _then;

/// Create a copy of ActivityFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = freezed,Object? type = freezed,Object? dates = freezed,Object? accountId = freezed,}) {
  return _then(_ActivityFilter(
description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType?,dates: freezed == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as (DateTime, DateTime)?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
