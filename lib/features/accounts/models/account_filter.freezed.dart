// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountFilter {

 String? get name; AccountType? get type; bool? get isSystem; bool? get isLiqid;
/// Create a copy of AccountFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountFilterCopyWith<AccountFilter> get copyWith => _$AccountFilterCopyWithImpl<AccountFilter>(this as AccountFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountFilter&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.isLiqid, isLiqid) || other.isLiqid == isLiqid));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,isSystem,isLiqid);

@override
String toString() {
  return 'AccountFilter(name: $name, type: $type, isSystem: $isSystem, isLiqid: $isLiqid)';
}


}

/// @nodoc
abstract mixin class $AccountFilterCopyWith<$Res>  {
  factory $AccountFilterCopyWith(AccountFilter value, $Res Function(AccountFilter) _then) = _$AccountFilterCopyWithImpl;
@useResult
$Res call({
 String? name, AccountType? type, bool? isSystem, bool? isLiqid
});




}
/// @nodoc
class _$AccountFilterCopyWithImpl<$Res>
    implements $AccountFilterCopyWith<$Res> {
  _$AccountFilterCopyWithImpl(this._self, this._then);

  final AccountFilter _self;
  final $Res Function(AccountFilter) _then;

/// Create a copy of AccountFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? type = freezed,Object? isSystem = freezed,Object? isLiqid = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType?,isSystem: freezed == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool?,isLiqid: freezed == isLiqid ? _self.isLiqid : isLiqid // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountFilter].
extension AccountFilterPatterns on AccountFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountFilter value)  $default,){
final _that = this;
switch (_that) {
case _AccountFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountFilter value)?  $default,){
final _that = this;
switch (_that) {
case _AccountFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  AccountType? type,  bool? isSystem,  bool? isLiqid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountFilter() when $default != null:
return $default(_that.name,_that.type,_that.isSystem,_that.isLiqid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  AccountType? type,  bool? isSystem,  bool? isLiqid)  $default,) {final _that = this;
switch (_that) {
case _AccountFilter():
return $default(_that.name,_that.type,_that.isSystem,_that.isLiqid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  AccountType? type,  bool? isSystem,  bool? isLiqid)?  $default,) {final _that = this;
switch (_that) {
case _AccountFilter() when $default != null:
return $default(_that.name,_that.type,_that.isSystem,_that.isLiqid);case _:
  return null;

}
}

}

/// @nodoc


class _AccountFilter extends AccountFilter {
  const _AccountFilter({this.name, this.type, this.isSystem, this.isLiqid}): super._();
  

@override final  String? name;
@override final  AccountType? type;
@override final  bool? isSystem;
@override final  bool? isLiqid;

/// Create a copy of AccountFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountFilterCopyWith<_AccountFilter> get copyWith => __$AccountFilterCopyWithImpl<_AccountFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountFilter&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.isLiqid, isLiqid) || other.isLiqid == isLiqid));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,isSystem,isLiqid);

@override
String toString() {
  return 'AccountFilter(name: $name, type: $type, isSystem: $isSystem, isLiqid: $isLiqid)';
}


}

/// @nodoc
abstract mixin class _$AccountFilterCopyWith<$Res> implements $AccountFilterCopyWith<$Res> {
  factory _$AccountFilterCopyWith(_AccountFilter value, $Res Function(_AccountFilter) _then) = __$AccountFilterCopyWithImpl;
@override @useResult
$Res call({
 String? name, AccountType? type, bool? isSystem, bool? isLiqid
});




}
/// @nodoc
class __$AccountFilterCopyWithImpl<$Res>
    implements _$AccountFilterCopyWith<$Res> {
  __$AccountFilterCopyWithImpl(this._self, this._then);

  final _AccountFilter _self;
  final $Res Function(_AccountFilter) _then;

/// Create a copy of AccountFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? type = freezed,Object? isSystem = freezed,Object? isLiqid = freezed,}) {
  return _then(_AccountFilter(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType?,isSystem: freezed == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool?,isLiqid: freezed == isLiqid ? _self.isLiqid : isLiqid // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
