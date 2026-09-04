// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saving_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavingFilter {

 String? get accountName; String? get status;
/// Create a copy of SavingFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingFilterCopyWith<SavingFilter> get copyWith => _$SavingFilterCopyWithImpl<SavingFilter>(this as SavingFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingFilter&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,accountName,status);

@override
String toString() {
  return 'SavingFilter(accountName: $accountName, status: $status)';
}


}

/// @nodoc
abstract mixin class $SavingFilterCopyWith<$Res>  {
  factory $SavingFilterCopyWith(SavingFilter value, $Res Function(SavingFilter) _then) = _$SavingFilterCopyWithImpl;
@useResult
$Res call({
 String? accountName, String? status
});




}
/// @nodoc
class _$SavingFilterCopyWithImpl<$Res>
    implements $SavingFilterCopyWith<$Res> {
  _$SavingFilterCopyWithImpl(this._self, this._then);

  final SavingFilter _self;
  final $Res Function(SavingFilter) _then;

/// Create a copy of SavingFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountName = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingFilter].
extension SavingFilterPatterns on SavingFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingFilter value)  $default,){
final _that = this;
switch (_that) {
case _SavingFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingFilter value)?  $default,){
final _that = this;
switch (_that) {
case _SavingFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? accountName,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingFilter() when $default != null:
return $default(_that.accountName,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? accountName,  String? status)  $default,) {final _that = this;
switch (_that) {
case _SavingFilter():
return $default(_that.accountName,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? accountName,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _SavingFilter() when $default != null:
return $default(_that.accountName,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _SavingFilter extends SavingFilter {
  const _SavingFilter({this.accountName, this.status}): super._();
  

@override final  String? accountName;
@override final  String? status;

/// Create a copy of SavingFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingFilterCopyWith<_SavingFilter> get copyWith => __$SavingFilterCopyWithImpl<_SavingFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingFilter&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,accountName,status);

@override
String toString() {
  return 'SavingFilter(accountName: $accountName, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SavingFilterCopyWith<$Res> implements $SavingFilterCopyWith<$Res> {
  factory _$SavingFilterCopyWith(_SavingFilter value, $Res Function(_SavingFilter) _then) = __$SavingFilterCopyWithImpl;
@override @useResult
$Res call({
 String? accountName, String? status
});




}
/// @nodoc
class __$SavingFilterCopyWithImpl<$Res>
    implements _$SavingFilterCopyWith<$Res> {
  __$SavingFilterCopyWithImpl(this._self, this._then);

  final _SavingFilter _self;
  final $Res Function(_SavingFilter) _then;

/// Create a copy of SavingFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountName = freezed,Object? status = freezed,}) {
  return _then(_SavingFilter(
accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
