// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BillDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BillDetailState()';
}


}

/// @nodoc
class $BillDetailStateCopyWith<$Res>  {
$BillDetailStateCopyWith(BillDetailState _, $Res Function(BillDetailState) __);
}


/// Adds pattern-matching-related methods to [BillDetailState].
extension BillDetailStatePatterns on BillDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _BillDetailInitial value)?  initial,TResult Function( _BillDetailLoading value)?  loading,TResult Function( _BillDetailLoaded value)?  loaded,TResult Function( _BillDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillDetailInitial() when initial != null:
return initial(_that);case _BillDetailLoading() when loading != null:
return loading(_that);case _BillDetailLoaded() when loaded != null:
return loaded(_that);case _BillDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _BillDetailInitial value)  initial,required TResult Function( _BillDetailLoading value)  loading,required TResult Function( _BillDetailLoaded value)  loaded,required TResult Function( _BillDetailError value)  error,}){
final _that = this;
switch (_that) {
case _BillDetailInitial():
return initial(_that);case _BillDetailLoading():
return loading(_that);case _BillDetailLoaded():
return loaded(_that);case _BillDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _BillDetailInitial value)?  initial,TResult? Function( _BillDetailLoading value)?  loading,TResult? Function( _BillDetailLoaded value)?  loaded,TResult? Function( _BillDetailError value)?  error,}){
final _that = this;
switch (_that) {
case _BillDetailInitial() when initial != null:
return initial(_that);case _BillDetailLoading() when loading != null:
return loading(_that);case _BillDetailLoaded() when loaded != null:
return loaded(_that);case _BillDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( BillDetail? detail)?  loading,TResult Function( BillDetail detail)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillDetailInitial() when initial != null:
return initial();case _BillDetailLoading() when loading != null:
return loading(_that.detail);case _BillDetailLoaded() when loaded != null:
return loaded(_that.detail);case _BillDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( BillDetail? detail)  loading,required TResult Function( BillDetail detail)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _BillDetailInitial():
return initial();case _BillDetailLoading():
return loading(_that.detail);case _BillDetailLoaded():
return loaded(_that.detail);case _BillDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( BillDetail? detail)?  loading,TResult? Function( BillDetail detail)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _BillDetailInitial() when initial != null:
return initial();case _BillDetailLoading() when loading != null:
return loading(_that.detail);case _BillDetailLoaded() when loaded != null:
return loaded(_that.detail);case _BillDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _BillDetailInitial implements BillDetailState {
  const _BillDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BillDetailState.initial()';
}


}




/// @nodoc


class _BillDetailLoading implements BillDetailState {
  const _BillDetailLoading({this.detail});
  

 final  BillDetail? detail;

/// Create a copy of BillDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillDetailLoadingCopyWith<_BillDetailLoading> get copyWith => __$BillDetailLoadingCopyWithImpl<_BillDetailLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillDetailLoading&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,detail);

@override
String toString() {
  return 'BillDetailState.loading(detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$BillDetailLoadingCopyWith<$Res> implements $BillDetailStateCopyWith<$Res> {
  factory _$BillDetailLoadingCopyWith(_BillDetailLoading value, $Res Function(_BillDetailLoading) _then) = __$BillDetailLoadingCopyWithImpl;
@useResult
$Res call({
 BillDetail? detail
});




}
/// @nodoc
class __$BillDetailLoadingCopyWithImpl<$Res>
    implements _$BillDetailLoadingCopyWith<$Res> {
  __$BillDetailLoadingCopyWithImpl(this._self, this._then);

  final _BillDetailLoading _self;
  final $Res Function(_BillDetailLoading) _then;

/// Create a copy of BillDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = freezed,}) {
  return _then(_BillDetailLoading(
detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as BillDetail?,
  ));
}


}

/// @nodoc


class _BillDetailLoaded implements BillDetailState {
  const _BillDetailLoaded({required this.detail});
  

 final  BillDetail detail;

/// Create a copy of BillDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillDetailLoadedCopyWith<_BillDetailLoaded> get copyWith => __$BillDetailLoadedCopyWithImpl<_BillDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillDetailLoaded&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,detail);

@override
String toString() {
  return 'BillDetailState.loaded(detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$BillDetailLoadedCopyWith<$Res> implements $BillDetailStateCopyWith<$Res> {
  factory _$BillDetailLoadedCopyWith(_BillDetailLoaded value, $Res Function(_BillDetailLoaded) _then) = __$BillDetailLoadedCopyWithImpl;
@useResult
$Res call({
 BillDetail detail
});




}
/// @nodoc
class __$BillDetailLoadedCopyWithImpl<$Res>
    implements _$BillDetailLoadedCopyWith<$Res> {
  __$BillDetailLoadedCopyWithImpl(this._self, this._then);

  final _BillDetailLoaded _self;
  final $Res Function(_BillDetailLoaded) _then;

/// Create a copy of BillDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = null,}) {
  return _then(_BillDetailLoaded(
detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as BillDetail,
  ));
}


}

/// @nodoc


class _BillDetailError implements BillDetailState {
  const _BillDetailError({required this.message});
  

 final  String message;

/// Create a copy of BillDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillDetailErrorCopyWith<_BillDetailError> get copyWith => __$BillDetailErrorCopyWithImpl<_BillDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BillDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$BillDetailErrorCopyWith<$Res> implements $BillDetailStateCopyWith<$Res> {
  factory _$BillDetailErrorCopyWith(_BillDetailError value, $Res Function(_BillDetailError) _then) = __$BillDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$BillDetailErrorCopyWithImpl<$Res>
    implements _$BillDetailErrorCopyWith<$Res> {
  __$BillDetailErrorCopyWithImpl(this._self, this._then);

  final _BillDetailError _self;
  final $Res Function(_BillDetailError) _then;

/// Create a copy of BillDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_BillDetailError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
