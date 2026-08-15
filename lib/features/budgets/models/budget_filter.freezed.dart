// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetFilter {

 String? get accountName;
/// Create a copy of BudgetFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetFilterCopyWith<BudgetFilter> get copyWith => _$BudgetFilterCopyWithImpl<BudgetFilter>(this as BudgetFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetFilter&&(identical(other.accountName, accountName) || other.accountName == accountName));
}


@override
int get hashCode => Object.hash(runtimeType,accountName);

@override
String toString() {
  return 'BudgetFilter(accountName: $accountName)';
}


}

/// @nodoc
abstract mixin class $BudgetFilterCopyWith<$Res>  {
  factory $BudgetFilterCopyWith(BudgetFilter value, $Res Function(BudgetFilter) _then) = _$BudgetFilterCopyWithImpl;
@useResult
$Res call({
 String? accountName
});




}
/// @nodoc
class _$BudgetFilterCopyWithImpl<$Res>
    implements $BudgetFilterCopyWith<$Res> {
  _$BudgetFilterCopyWithImpl(this._self, this._then);

  final BudgetFilter _self;
  final $Res Function(BudgetFilter) _then;

/// Create a copy of BudgetFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountName = freezed,}) {
  return _then(_self.copyWith(
accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetFilter].
extension BudgetFilterPatterns on BudgetFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetFilter value)  $default,){
final _that = this;
switch (_that) {
case _BudgetFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetFilter value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? accountName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetFilter() when $default != null:
return $default(_that.accountName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? accountName)  $default,) {final _that = this;
switch (_that) {
case _BudgetFilter():
return $default(_that.accountName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? accountName)?  $default,) {final _that = this;
switch (_that) {
case _BudgetFilter() when $default != null:
return $default(_that.accountName);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetFilter extends BudgetFilter {
  const _BudgetFilter({this.accountName}): super._();
  

@override final  String? accountName;

/// Create a copy of BudgetFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetFilterCopyWith<_BudgetFilter> get copyWith => __$BudgetFilterCopyWithImpl<_BudgetFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetFilter&&(identical(other.accountName, accountName) || other.accountName == accountName));
}


@override
int get hashCode => Object.hash(runtimeType,accountName);

@override
String toString() {
  return 'BudgetFilter(accountName: $accountName)';
}


}

/// @nodoc
abstract mixin class _$BudgetFilterCopyWith<$Res> implements $BudgetFilterCopyWith<$Res> {
  factory _$BudgetFilterCopyWith(_BudgetFilter value, $Res Function(_BudgetFilter) _then) = __$BudgetFilterCopyWithImpl;
@override @useResult
$Res call({
 String? accountName
});




}
/// @nodoc
class __$BudgetFilterCopyWithImpl<$Res>
    implements _$BudgetFilterCopyWith<$Res> {
  __$BudgetFilterCopyWithImpl(this._self, this._then);

  final _BudgetFilter _self;
  final $Res Function(_BudgetFilter) _then;

/// Create a copy of BudgetFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountName = freezed,}) {
  return _then(_BudgetFilter(
accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
