// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginationResult<T> {

 List<T> get items; PaginationMeta get meta;
/// Create a copy of PaginationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationResultCopyWith<T, PaginationResult<T>> get copyWith => _$PaginationResultCopyWithImpl<T, PaginationResult<T>>(this as PaginationResult<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationResult<T>&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.meta, meta) || other.meta == meta));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),meta);

@override
String toString() {
  return 'PaginationResult<$T>(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $PaginationResultCopyWith<T,$Res>  {
  factory $PaginationResultCopyWith(PaginationResult<T> value, $Res Function(PaginationResult<T>) _then) = _$PaginationResultCopyWithImpl;
@useResult
$Res call({
 List<T> items, PaginationMeta meta
});


$PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$PaginationResultCopyWithImpl<T,$Res>
    implements $PaginationResultCopyWith<T, $Res> {
  _$PaginationResultCopyWithImpl(this._self, this._then);

  final PaginationResult<T> _self;
  final $Res Function(PaginationResult<T>) _then;

/// Create a copy of PaginationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}
/// Create a copy of PaginationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res> get meta {
  
  return $PaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaginationResult].
extension PaginationResultPatterns<T> on PaginationResult<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginationResult<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginationResult<T> value)  $default,){
final _that = this;
switch (_that) {
case _PaginationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginationResult<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PaginationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> items,  PaginationMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginationResult() when $default != null:
return $default(_that.items,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> items,  PaginationMeta meta)  $default,) {final _that = this;
switch (_that) {
case _PaginationResult():
return $default(_that.items,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> items,  PaginationMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _PaginationResult() when $default != null:
return $default(_that.items,_that.meta);case _:
  return null;

}
}

}

/// @nodoc


class _PaginationResult<T> implements PaginationResult<T> {
   _PaginationResult({final  List<T> items = const [], required this.meta}): _items = items;
  

 final  List<T> _items;
@override@JsonKey() List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  PaginationMeta meta;

/// Create a copy of PaginationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationResultCopyWith<T, _PaginationResult<T>> get copyWith => __$PaginationResultCopyWithImpl<T, _PaginationResult<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginationResult<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta);

@override
String toString() {
  return 'PaginationResult<$T>(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$PaginationResultCopyWith<T,$Res> implements $PaginationResultCopyWith<T, $Res> {
  factory _$PaginationResultCopyWith(_PaginationResult<T> value, $Res Function(_PaginationResult<T>) _then) = __$PaginationResultCopyWithImpl;
@override @useResult
$Res call({
 List<T> items, PaginationMeta meta
});


@override $PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$PaginationResultCopyWithImpl<T,$Res>
    implements _$PaginationResultCopyWith<T, $Res> {
  __$PaginationResultCopyWithImpl(this._self, this._then);

  final _PaginationResult<T> _self;
  final $Res Function(_PaginationResult<T>) _then;

/// Create a copy of PaginationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_PaginationResult<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}

/// Create a copy of PaginationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res> get meta {
  
  return $PaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
