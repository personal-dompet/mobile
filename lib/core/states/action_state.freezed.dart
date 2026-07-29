// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActionState()';
}


}

/// @nodoc
class $ActionStateCopyWith<$Res>  {
$ActionStateCopyWith(ActionState _, $Res Function(ActionState) __);
}


/// Adds pattern-matching-related methods to [ActionState].
extension ActionStatePatterns on ActionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ActionInitial value)?  initial,TResult Function( _ActionLoading value)?  loading,TResult Function( _ActionSuccess value)?  success,TResult Function( _ActionError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionInitial() when initial != null:
return initial(_that);case _ActionLoading() when loading != null:
return loading(_that);case _ActionSuccess() when success != null:
return success(_that);case _ActionError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ActionInitial value)  initial,required TResult Function( _ActionLoading value)  loading,required TResult Function( _ActionSuccess value)  success,required TResult Function( _ActionError value)  error,}){
final _that = this;
switch (_that) {
case _ActionInitial():
return initial(_that);case _ActionLoading():
return loading(_that);case _ActionSuccess():
return success(_that);case _ActionError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ActionInitial value)?  initial,TResult? Function( _ActionLoading value)?  loading,TResult? Function( _ActionSuccess value)?  success,TResult? Function( _ActionError value)?  error,}){
final _that = this;
switch (_that) {
case _ActionInitial() when initial != null:
return initial(_that);case _ActionLoading() when loading != null:
return loading(_that);case _ActionSuccess() when success != null:
return success(_that);case _ActionError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionInitial() when initial != null:
return initial();case _ActionLoading() when loading != null:
return loading();case _ActionSuccess() when success != null:
return success(_that.message);case _ActionError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _ActionInitial():
return initial();case _ActionLoading():
return loading();case _ActionSuccess():
return success(_that.message);case _ActionError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _ActionInitial() when initial != null:
return initial();case _ActionLoading() when loading != null:
return loading();case _ActionSuccess() when success != null:
return success(_that.message);case _ActionError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ActionInitial implements ActionState {
  const _ActionInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActionState.initial()';
}


}




/// @nodoc


class _ActionLoading implements ActionState {
  const _ActionLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActionState.loading()';
}


}




/// @nodoc


class _ActionSuccess implements ActionState {
  const _ActionSuccess({required this.message});
  

 final  String message;

/// Create a copy of ActionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionSuccessCopyWith<_ActionSuccess> get copyWith => __$ActionSuccessCopyWithImpl<_ActionSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ActionState.success(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $ActionStateCopyWith<$Res> {
  factory _$ActionSuccessCopyWith(_ActionSuccess value, $Res Function(_ActionSuccess) _then) = __$ActionSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ActionSuccessCopyWithImpl<$Res>
    implements _$ActionSuccessCopyWith<$Res> {
  __$ActionSuccessCopyWithImpl(this._self, this._then);

  final _ActionSuccess _self;
  final $Res Function(_ActionSuccess) _then;

/// Create a copy of ActionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ActionSuccess(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ActionError implements ActionState {
  const _ActionError({required this.message});
  

 final  String message;

/// Create a copy of ActionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionErrorCopyWith<_ActionError> get copyWith => __$ActionErrorCopyWithImpl<_ActionError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ActionState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActionErrorCopyWith<$Res> implements $ActionStateCopyWith<$Res> {
  factory _$ActionErrorCopyWith(_ActionError value, $Res Function(_ActionError) _then) = __$ActionErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ActionErrorCopyWithImpl<$Res>
    implements _$ActionErrorCopyWith<$Res> {
  __$ActionErrorCopyWithImpl(this._self, this._then);

  final _ActionError _self;
  final $Res Function(_ActionError) _then;

/// Create a copy of ActionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ActionError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
