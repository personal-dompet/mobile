// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalFilter {

 String? get description; ActivityType? get type; int? get accountId; (DateTime, DateTime)? get dates;
/// Create a copy of JournalFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalFilterCopyWith<JournalFilter> get copyWith => _$JournalFilterCopyWithImpl<JournalFilter>(this as JournalFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalFilter&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.dates, dates) || other.dates == dates));
}


@override
int get hashCode => Object.hash(runtimeType,description,type,accountId,dates);

@override
String toString() {
  return 'JournalFilter(description: $description, type: $type, accountId: $accountId, dates: $dates)';
}


}

/// @nodoc
abstract mixin class $JournalFilterCopyWith<$Res>  {
  factory $JournalFilterCopyWith(JournalFilter value, $Res Function(JournalFilter) _then) = _$JournalFilterCopyWithImpl;
@useResult
$Res call({
 String? description, ActivityType? type, int? accountId, (DateTime, DateTime)? dates
});




}
/// @nodoc
class _$JournalFilterCopyWithImpl<$Res>
    implements $JournalFilterCopyWith<$Res> {
  _$JournalFilterCopyWithImpl(this._self, this._then);

  final JournalFilter _self;
  final $Res Function(JournalFilter) _then;

/// Create a copy of JournalFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? description = freezed,Object? type = freezed,Object? accountId = freezed,Object? dates = freezed,}) {
  return _then(_self.copyWith(
description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,dates: freezed == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as (DateTime, DateTime)?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalFilter].
extension JournalFilterPatterns on JournalFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalFilter value)  $default,){
final _that = this;
switch (_that) {
case _JournalFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalFilter value)?  $default,){
final _that = this;
switch (_that) {
case _JournalFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? description,  ActivityType? type,  int? accountId,  (DateTime, DateTime)? dates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalFilter() when $default != null:
return $default(_that.description,_that.type,_that.accountId,_that.dates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? description,  ActivityType? type,  int? accountId,  (DateTime, DateTime)? dates)  $default,) {final _that = this;
switch (_that) {
case _JournalFilter():
return $default(_that.description,_that.type,_that.accountId,_that.dates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? description,  ActivityType? type,  int? accountId,  (DateTime, DateTime)? dates)?  $default,) {final _that = this;
switch (_that) {
case _JournalFilter() when $default != null:
return $default(_that.description,_that.type,_that.accountId,_that.dates);case _:
  return null;

}
}

}

/// @nodoc


class _JournalFilter extends JournalFilter {
  const _JournalFilter({this.description, this.type, this.accountId, this.dates}): super._();
  

@override final  String? description;
@override final  ActivityType? type;
@override final  int? accountId;
@override final  (DateTime, DateTime)? dates;

/// Create a copy of JournalFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalFilterCopyWith<_JournalFilter> get copyWith => __$JournalFilterCopyWithImpl<_JournalFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalFilter&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.dates, dates) || other.dates == dates));
}


@override
int get hashCode => Object.hash(runtimeType,description,type,accountId,dates);

@override
String toString() {
  return 'JournalFilter(description: $description, type: $type, accountId: $accountId, dates: $dates)';
}


}

/// @nodoc
abstract mixin class _$JournalFilterCopyWith<$Res> implements $JournalFilterCopyWith<$Res> {
  factory _$JournalFilterCopyWith(_JournalFilter value, $Res Function(_JournalFilter) _then) = __$JournalFilterCopyWithImpl;
@override @useResult
$Res call({
 String? description, ActivityType? type, int? accountId, (DateTime, DateTime)? dates
});




}
/// @nodoc
class __$JournalFilterCopyWithImpl<$Res>
    implements _$JournalFilterCopyWith<$Res> {
  __$JournalFilterCopyWithImpl(this._self, this._then);

  final _JournalFilter _self;
  final $Res Function(_JournalFilter) _then;

/// Create a copy of JournalFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = freezed,Object? type = freezed,Object? accountId = freezed,Object? dates = freezed,}) {
  return _then(_JournalFilter(
description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,dates: freezed == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as (DateTime, DateTime)?,
  ));
}


}

// dart format on
