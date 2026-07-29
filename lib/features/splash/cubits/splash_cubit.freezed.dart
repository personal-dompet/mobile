// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SplashState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplashState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState()';
}


}

/// @nodoc
class $SplashStateCopyWith<$Res>  {
$SplashStateCopyWith(SplashState _, $Res Function(SplashState) __);
}


/// Adds pattern-matching-related methods to [SplashState].
extension SplashStatePatterns on SplashState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SplashInitial value)?  initial,TResult Function( _SplashLoading value)?  loading,TResult Function( _SplashError value)?  error,TResult Function( _SplashNeedToBeSet value)?  needToBeSet,TResult Function( _SplashAlreadySet value)?  alreadySet,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SplashInitial() when initial != null:
return initial(_that);case _SplashLoading() when loading != null:
return loading(_that);case _SplashError() when error != null:
return error(_that);case _SplashNeedToBeSet() when needToBeSet != null:
return needToBeSet(_that);case _SplashAlreadySet() when alreadySet != null:
return alreadySet(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SplashInitial value)  initial,required TResult Function( _SplashLoading value)  loading,required TResult Function( _SplashError value)  error,required TResult Function( _SplashNeedToBeSet value)  needToBeSet,required TResult Function( _SplashAlreadySet value)  alreadySet,}){
final _that = this;
switch (_that) {
case _SplashInitial():
return initial(_that);case _SplashLoading():
return loading(_that);case _SplashError():
return error(_that);case _SplashNeedToBeSet():
return needToBeSet(_that);case _SplashAlreadySet():
return alreadySet(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SplashInitial value)?  initial,TResult? Function( _SplashLoading value)?  loading,TResult? Function( _SplashError value)?  error,TResult? Function( _SplashNeedToBeSet value)?  needToBeSet,TResult? Function( _SplashAlreadySet value)?  alreadySet,}){
final _that = this;
switch (_that) {
case _SplashInitial() when initial != null:
return initial(_that);case _SplashLoading() when loading != null:
return loading(_that);case _SplashError() when error != null:
return error(_that);case _SplashNeedToBeSet() when needToBeSet != null:
return needToBeSet(_that);case _SplashAlreadySet() when alreadySet != null:
return alreadySet(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function()?  needToBeSet,TResult Function()?  alreadySet,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SplashInitial() when initial != null:
return initial();case _SplashLoading() when loading != null:
return loading();case _SplashError() when error != null:
return error(_that.message);case _SplashNeedToBeSet() when needToBeSet != null:
return needToBeSet();case _SplashAlreadySet() when alreadySet != null:
return alreadySet();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function()  needToBeSet,required TResult Function()  alreadySet,}) {final _that = this;
switch (_that) {
case _SplashInitial():
return initial();case _SplashLoading():
return loading();case _SplashError():
return error(_that.message);case _SplashNeedToBeSet():
return needToBeSet();case _SplashAlreadySet():
return alreadySet();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function()?  needToBeSet,TResult? Function()?  alreadySet,}) {final _that = this;
switch (_that) {
case _SplashInitial() when initial != null:
return initial();case _SplashLoading() when loading != null:
return loading();case _SplashError() when error != null:
return error(_that.message);case _SplashNeedToBeSet() when needToBeSet != null:
return needToBeSet();case _SplashAlreadySet() when alreadySet != null:
return alreadySet();case _:
  return null;

}
}

}

/// @nodoc


class _SplashInitial implements SplashState {
  const _SplashInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplashInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.initial()';
}


}




/// @nodoc


class _SplashLoading implements SplashState {
  const _SplashLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplashLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.loading()';
}


}




/// @nodoc


class _SplashError implements SplashState {
  const _SplashError({required this.message});
  

 final  String message;

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SplashErrorCopyWith<_SplashError> get copyWith => __$SplashErrorCopyWithImpl<_SplashError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplashError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SplashState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$SplashErrorCopyWith<$Res> implements $SplashStateCopyWith<$Res> {
  factory _$SplashErrorCopyWith(_SplashError value, $Res Function(_SplashError) _then) = __$SplashErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$SplashErrorCopyWithImpl<$Res>
    implements _$SplashErrorCopyWith<$Res> {
  __$SplashErrorCopyWithImpl(this._self, this._then);

  final _SplashError _self;
  final $Res Function(_SplashError) _then;

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_SplashError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SplashNeedToBeSet implements SplashState {
  const _SplashNeedToBeSet();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplashNeedToBeSet);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.needToBeSet()';
}


}




/// @nodoc


class _SplashAlreadySet implements SplashState {
  const _SplashAlreadySet();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplashAlreadySet);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.alreadySet()';
}


}




// dart format on
