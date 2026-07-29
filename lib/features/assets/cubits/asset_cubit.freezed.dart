// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssetState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetState()';
}


}

/// @nodoc
class $AssetStateCopyWith<$Res>  {
$AssetStateCopyWith(AssetState _, $Res Function(AssetState) __);
}


/// Adds pattern-matching-related methods to [AssetState].
extension AssetStatePatterns on AssetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AssetInitial value)?  initial,TResult Function( _AssetLoading value)?  loading,TResult Function( _AssetLoaded value)?  loaded,TResult Function( _AssetError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetInitial() when initial != null:
return initial(_that);case _AssetLoading() when loading != null:
return loading(_that);case _AssetLoaded() when loaded != null:
return loaded(_that);case _AssetError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AssetInitial value)  initial,required TResult Function( _AssetLoading value)  loading,required TResult Function( _AssetLoaded value)  loaded,required TResult Function( _AssetError value)  error,}){
final _that = this;
switch (_that) {
case _AssetInitial():
return initial(_that);case _AssetLoading():
return loading(_that);case _AssetLoaded():
return loaded(_that);case _AssetError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AssetInitial value)?  initial,TResult? Function( _AssetLoading value)?  loading,TResult? Function( _AssetLoaded value)?  loaded,TResult? Function( _AssetError value)?  error,}){
final _that = this;
switch (_that) {
case _AssetInitial() when initial != null:
return initial(_that);case _AssetLoading() when loading != null:
return loading(_that);case _AssetLoaded() when loaded != null:
return loaded(_that);case _AssetError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Account> assets)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetInitial() when initial != null:
return initial();case _AssetLoading() when loading != null:
return loading();case _AssetLoaded() when loaded != null:
return loaded(_that.assets);case _AssetError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Account> assets)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _AssetInitial():
return initial();case _AssetLoading():
return loading();case _AssetLoaded():
return loaded(_that.assets);case _AssetError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Account> assets)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _AssetInitial() when initial != null:
return initial();case _AssetLoading() when loading != null:
return loading();case _AssetLoaded() when loaded != null:
return loaded(_that.assets);case _AssetError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _AssetInitial implements AssetState {
  const _AssetInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetState.initial()';
}


}




/// @nodoc


class _AssetLoading implements AssetState {
  const _AssetLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetState.loading()';
}


}




/// @nodoc


class _AssetLoaded implements AssetState {
  const _AssetLoaded({final  List<Account> assets = const []}): _assets = assets;
  

 final  List<Account> _assets;
@JsonKey() List<Account> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}


/// Create a copy of AssetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetLoadedCopyWith<_AssetLoaded> get copyWith => __$AssetLoadedCopyWithImpl<_AssetLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetLoaded&&const DeepCollectionEquality().equals(other._assets, _assets));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_assets));

@override
String toString() {
  return 'AssetState.loaded(assets: $assets)';
}


}

/// @nodoc
abstract mixin class _$AssetLoadedCopyWith<$Res> implements $AssetStateCopyWith<$Res> {
  factory _$AssetLoadedCopyWith(_AssetLoaded value, $Res Function(_AssetLoaded) _then) = __$AssetLoadedCopyWithImpl;
@useResult
$Res call({
 List<Account> assets
});




}
/// @nodoc
class __$AssetLoadedCopyWithImpl<$Res>
    implements _$AssetLoadedCopyWith<$Res> {
  __$AssetLoadedCopyWithImpl(this._self, this._then);

  final _AssetLoaded _self;
  final $Res Function(_AssetLoaded) _then;

/// Create a copy of AssetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assets = null,}) {
  return _then(_AssetLoaded(
assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<Account>,
  ));
}


}

/// @nodoc


class _AssetError implements AssetState {
  const _AssetError({required this.message});
  

 final  String message;

/// Create a copy of AssetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetErrorCopyWith<_AssetError> get copyWith => __$AssetErrorCopyWithImpl<_AssetError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AssetState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AssetErrorCopyWith<$Res> implements $AssetStateCopyWith<$Res> {
  factory _$AssetErrorCopyWith(_AssetError value, $Res Function(_AssetError) _then) = __$AssetErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$AssetErrorCopyWithImpl<$Res>
    implements _$AssetErrorCopyWith<$Res> {
  __$AssetErrorCopyWithImpl(this._self, this._then);

  final _AssetError _self;
  final $Res Function(_AssetError) _then;

/// Create a copy of AssetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_AssetError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
