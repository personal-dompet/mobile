// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginationState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginationState<$T>()';
}


}

/// @nodoc
class $PaginationStateCopyWith<T,$Res>  {
$PaginationStateCopyWith(PaginationState<T> _, $Res Function(PaginationState<T>) __);
}


/// Adds pattern-matching-related methods to [PaginationState].
extension PaginationStatePatterns<T> on PaginationState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaginationInitial<T> value)?  initial,TResult Function( PaginationLoading<T> value)?  loading,TResult Function( PaginationSuccess<T> value)?  success,TResult Function( PaginationLoadingMore<T> value)?  loadingMore,TResult Function( PaginationFailure<T> value)?  failure,TResult Function( PaginationLoadingMoreFailure<T> value)?  loadingMoreFailure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaginationInitial() when initial != null:
return initial(_that);case PaginationLoading() when loading != null:
return loading(_that);case PaginationSuccess() when success != null:
return success(_that);case PaginationLoadingMore() when loadingMore != null:
return loadingMore(_that);case PaginationFailure() when failure != null:
return failure(_that);case PaginationLoadingMoreFailure() when loadingMoreFailure != null:
return loadingMoreFailure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaginationInitial<T> value)  initial,required TResult Function( PaginationLoading<T> value)  loading,required TResult Function( PaginationSuccess<T> value)  success,required TResult Function( PaginationLoadingMore<T> value)  loadingMore,required TResult Function( PaginationFailure<T> value)  failure,required TResult Function( PaginationLoadingMoreFailure<T> value)  loadingMoreFailure,}){
final _that = this;
switch (_that) {
case PaginationInitial():
return initial(_that);case PaginationLoading():
return loading(_that);case PaginationSuccess():
return success(_that);case PaginationLoadingMore():
return loadingMore(_that);case PaginationFailure():
return failure(_that);case PaginationLoadingMoreFailure():
return loadingMoreFailure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaginationInitial<T> value)?  initial,TResult? Function( PaginationLoading<T> value)?  loading,TResult? Function( PaginationSuccess<T> value)?  success,TResult? Function( PaginationLoadingMore<T> value)?  loadingMore,TResult? Function( PaginationFailure<T> value)?  failure,TResult? Function( PaginationLoadingMoreFailure<T> value)?  loadingMoreFailure,}){
final _that = this;
switch (_that) {
case PaginationInitial() when initial != null:
return initial(_that);case PaginationLoading() when loading != null:
return loading(_that);case PaginationSuccess() when success != null:
return success(_that);case PaginationLoadingMore() when loadingMore != null:
return loadingMore(_that);case PaginationFailure() when failure != null:
return failure(_that);case PaginationLoadingMoreFailure() when loadingMoreFailure != null:
return loadingMoreFailure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<T> items,  PaginationMeta meta)?  success,TResult Function( List<T> items,  PaginationMeta meta)?  loadingMore,TResult Function( String message)?  failure,TResult Function( List<T> items,  PaginationMeta meta,  String message)?  loadingMoreFailure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaginationInitial() when initial != null:
return initial();case PaginationLoading() when loading != null:
return loading();case PaginationSuccess() when success != null:
return success(_that.items,_that.meta);case PaginationLoadingMore() when loadingMore != null:
return loadingMore(_that.items,_that.meta);case PaginationFailure() when failure != null:
return failure(_that.message);case PaginationLoadingMoreFailure() when loadingMoreFailure != null:
return loadingMoreFailure(_that.items,_that.meta,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<T> items,  PaginationMeta meta)  success,required TResult Function( List<T> items,  PaginationMeta meta)  loadingMore,required TResult Function( String message)  failure,required TResult Function( List<T> items,  PaginationMeta meta,  String message)  loadingMoreFailure,}) {final _that = this;
switch (_that) {
case PaginationInitial():
return initial();case PaginationLoading():
return loading();case PaginationSuccess():
return success(_that.items,_that.meta);case PaginationLoadingMore():
return loadingMore(_that.items,_that.meta);case PaginationFailure():
return failure(_that.message);case PaginationLoadingMoreFailure():
return loadingMoreFailure(_that.items,_that.meta,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<T> items,  PaginationMeta meta)?  success,TResult? Function( List<T> items,  PaginationMeta meta)?  loadingMore,TResult? Function( String message)?  failure,TResult? Function( List<T> items,  PaginationMeta meta,  String message)?  loadingMoreFailure,}) {final _that = this;
switch (_that) {
case PaginationInitial() when initial != null:
return initial();case PaginationLoading() when loading != null:
return loading();case PaginationSuccess() when success != null:
return success(_that.items,_that.meta);case PaginationLoadingMore() when loadingMore != null:
return loadingMore(_that.items,_that.meta);case PaginationFailure() when failure != null:
return failure(_that.message);case PaginationLoadingMoreFailure() when loadingMoreFailure != null:
return loadingMoreFailure(_that.items,_that.meta,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PaginationInitial<T> implements PaginationState<T> {
  const PaginationInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationInitial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginationState<$T>.initial()';
}


}




/// @nodoc


class PaginationLoading<T> implements PaginationState<T> {
  const PaginationLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginationState<$T>.loading()';
}


}




/// @nodoc


class PaginationSuccess<T> implements PaginationState<T> {
  const PaginationSuccess({required final  List<T> items, required this.meta}): _items = items;
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  PaginationMeta meta;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationSuccessCopyWith<T, PaginationSuccess<T>> get copyWith => _$PaginationSuccessCopyWithImpl<T, PaginationSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationSuccess<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta);

@override
String toString() {
  return 'PaginationState<$T>.success(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $PaginationSuccessCopyWith<T,$Res> implements $PaginationStateCopyWith<T, $Res> {
  factory $PaginationSuccessCopyWith(PaginationSuccess<T> value, $Res Function(PaginationSuccess<T>) _then) = _$PaginationSuccessCopyWithImpl;
@useResult
$Res call({
 List<T> items, PaginationMeta meta
});


$PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$PaginationSuccessCopyWithImpl<T,$Res>
    implements $PaginationSuccessCopyWith<T, $Res> {
  _$PaginationSuccessCopyWithImpl(this._self, this._then);

  final PaginationSuccess<T> _self;
  final $Res Function(PaginationSuccess<T>) _then;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,}) {
  return _then(PaginationSuccess<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res> get meta {
  
  return $PaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class PaginationLoadingMore<T> implements PaginationState<T> {
  const PaginationLoadingMore({required final  List<T> items, required this.meta}): _items = items;
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  PaginationMeta meta;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationLoadingMoreCopyWith<T, PaginationLoadingMore<T>> get copyWith => _$PaginationLoadingMoreCopyWithImpl<T, PaginationLoadingMore<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationLoadingMore<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta);

@override
String toString() {
  return 'PaginationState<$T>.loadingMore(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $PaginationLoadingMoreCopyWith<T,$Res> implements $PaginationStateCopyWith<T, $Res> {
  factory $PaginationLoadingMoreCopyWith(PaginationLoadingMore<T> value, $Res Function(PaginationLoadingMore<T>) _then) = _$PaginationLoadingMoreCopyWithImpl;
@useResult
$Res call({
 List<T> items, PaginationMeta meta
});


$PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$PaginationLoadingMoreCopyWithImpl<T,$Res>
    implements $PaginationLoadingMoreCopyWith<T, $Res> {
  _$PaginationLoadingMoreCopyWithImpl(this._self, this._then);

  final PaginationLoadingMore<T> _self;
  final $Res Function(PaginationLoadingMore<T>) _then;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,}) {
  return _then(PaginationLoadingMore<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res> get meta {
  
  return $PaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class PaginationFailure<T> implements PaginationState<T> {
  const PaginationFailure({required this.message});
  

 final  String message;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationFailureCopyWith<T, PaginationFailure<T>> get copyWith => _$PaginationFailureCopyWithImpl<T, PaginationFailure<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationFailure<T>&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PaginationState<$T>.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $PaginationFailureCopyWith<T,$Res> implements $PaginationStateCopyWith<T, $Res> {
  factory $PaginationFailureCopyWith(PaginationFailure<T> value, $Res Function(PaginationFailure<T>) _then) = _$PaginationFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PaginationFailureCopyWithImpl<T,$Res>
    implements $PaginationFailureCopyWith<T, $Res> {
  _$PaginationFailureCopyWithImpl(this._self, this._then);

  final PaginationFailure<T> _self;
  final $Res Function(PaginationFailure<T>) _then;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PaginationFailure<T>(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PaginationLoadingMoreFailure<T> implements PaginationState<T> {
  const PaginationLoadingMoreFailure({required final  List<T> items, required this.meta, required this.message}): _items = items;
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  PaginationMeta meta;
 final  String message;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationLoadingMoreFailureCopyWith<T, PaginationLoadingMoreFailure<T>> get copyWith => _$PaginationLoadingMoreFailureCopyWithImpl<T, PaginationLoadingMoreFailure<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationLoadingMoreFailure<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta,message);

@override
String toString() {
  return 'PaginationState<$T>.loadingMoreFailure(items: $items, meta: $meta, message: $message)';
}


}

/// @nodoc
abstract mixin class $PaginationLoadingMoreFailureCopyWith<T,$Res> implements $PaginationStateCopyWith<T, $Res> {
  factory $PaginationLoadingMoreFailureCopyWith(PaginationLoadingMoreFailure<T> value, $Res Function(PaginationLoadingMoreFailure<T>) _then) = _$PaginationLoadingMoreFailureCopyWithImpl;
@useResult
$Res call({
 List<T> items, PaginationMeta meta, String message
});


$PaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$PaginationLoadingMoreFailureCopyWithImpl<T,$Res>
    implements $PaginationLoadingMoreFailureCopyWith<T, $Res> {
  _$PaginationLoadingMoreFailureCopyWithImpl(this._self, this._then);

  final PaginationLoadingMoreFailure<T> _self;
  final $Res Function(PaginationLoadingMoreFailure<T>) _then;

/// Create a copy of PaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,Object? message = null,}) {
  return _then(PaginationLoadingMoreFailure<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PaginationState
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
