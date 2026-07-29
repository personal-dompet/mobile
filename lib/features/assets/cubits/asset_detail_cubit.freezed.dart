// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssetDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetDetailState()';
}


}

/// @nodoc
class $AssetDetailStateCopyWith<$Res>  {
$AssetDetailStateCopyWith(AssetDetailState _, $Res Function(AssetDetailState) __);
}


/// Adds pattern-matching-related methods to [AssetDetailState].
extension AssetDetailStatePatterns on AssetDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AssetDetailInitial value)?  initial,TResult Function( _AssetDetailLoading value)?  loading,TResult Function( _AssetDetailLoaded value)?  loaded,TResult Function( _AssetDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetDetailInitial() when initial != null:
return initial(_that);case _AssetDetailLoading() when loading != null:
return loading(_that);case _AssetDetailLoaded() when loaded != null:
return loaded(_that);case _AssetDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AssetDetailInitial value)  initial,required TResult Function( _AssetDetailLoading value)  loading,required TResult Function( _AssetDetailLoaded value)  loaded,required TResult Function( _AssetDetailError value)  error,}){
final _that = this;
switch (_that) {
case _AssetDetailInitial():
return initial(_that);case _AssetDetailLoading():
return loading(_that);case _AssetDetailLoaded():
return loaded(_that);case _AssetDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AssetDetailInitial value)?  initial,TResult? Function( _AssetDetailLoading value)?  loading,TResult? Function( _AssetDetailLoaded value)?  loaded,TResult? Function( _AssetDetailError value)?  error,}){
final _that = this;
switch (_that) {
case _AssetDetailInitial() when initial != null:
return initial(_that);case _AssetDetailLoading() when loading != null:
return loading(_that);case _AssetDetailLoaded() when loaded != null:
return loaded(_that);case _AssetDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( AssetDetail accountDetail)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetDetailInitial() when initial != null:
return initial();case _AssetDetailLoading() when loading != null:
return loading();case _AssetDetailLoaded() when loaded != null:
return loaded(_that.accountDetail);case _AssetDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( AssetDetail accountDetail)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _AssetDetailInitial():
return initial();case _AssetDetailLoading():
return loading();case _AssetDetailLoaded():
return loaded(_that.accountDetail);case _AssetDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( AssetDetail accountDetail)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _AssetDetailInitial() when initial != null:
return initial();case _AssetDetailLoading() when loading != null:
return loading();case _AssetDetailLoaded() when loaded != null:
return loaded(_that.accountDetail);case _AssetDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _AssetDetailInitial implements AssetDetailState {
  const _AssetDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetDetailState.initial()';
}


}




/// @nodoc


class _AssetDetailLoading implements AssetDetailState {
  const _AssetDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetDetailState.loading()';
}


}




/// @nodoc


class _AssetDetailLoaded implements AssetDetailState {
  const _AssetDetailLoaded({required this.accountDetail});
  

 final  AssetDetail accountDetail;

/// Create a copy of AssetDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetDetailLoadedCopyWith<_AssetDetailLoaded> get copyWith => __$AssetDetailLoadedCopyWithImpl<_AssetDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetDetailLoaded&&(identical(other.accountDetail, accountDetail) || other.accountDetail == accountDetail));
}


@override
int get hashCode => Object.hash(runtimeType,accountDetail);

@override
String toString() {
  return 'AssetDetailState.loaded(accountDetail: $accountDetail)';
}


}

/// @nodoc
abstract mixin class _$AssetDetailLoadedCopyWith<$Res> implements $AssetDetailStateCopyWith<$Res> {
  factory _$AssetDetailLoadedCopyWith(_AssetDetailLoaded value, $Res Function(_AssetDetailLoaded) _then) = __$AssetDetailLoadedCopyWithImpl;
@useResult
$Res call({
 AssetDetail accountDetail
});




}
/// @nodoc
class __$AssetDetailLoadedCopyWithImpl<$Res>
    implements _$AssetDetailLoadedCopyWith<$Res> {
  __$AssetDetailLoadedCopyWithImpl(this._self, this._then);

  final _AssetDetailLoaded _self;
  final $Res Function(_AssetDetailLoaded) _then;

/// Create a copy of AssetDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accountDetail = null,}) {
  return _then(_AssetDetailLoaded(
accountDetail: null == accountDetail ? _self.accountDetail : accountDetail // ignore: cast_nullable_to_non_nullable
as AssetDetail,
  ));
}


}

/// @nodoc


class _AssetDetailError implements AssetDetailState {
  const _AssetDetailError({required this.message});
  

 final  String message;

/// Create a copy of AssetDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetDetailErrorCopyWith<_AssetDetailError> get copyWith => __$AssetDetailErrorCopyWithImpl<_AssetDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AssetDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AssetDetailErrorCopyWith<$Res> implements $AssetDetailStateCopyWith<$Res> {
  factory _$AssetDetailErrorCopyWith(_AssetDetailError value, $Res Function(_AssetDetailError) _then) = __$AssetDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$AssetDetailErrorCopyWithImpl<$Res>
    implements _$AssetDetailErrorCopyWith<$Res> {
  __$AssetDetailErrorCopyWithImpl(this._self, this._then);

  final _AssetDetailError _self;
  final $Res Function(_AssetDetailError) _then;

/// Create a copy of AssetDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_AssetDetailError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
