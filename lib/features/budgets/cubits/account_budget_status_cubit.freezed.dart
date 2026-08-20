// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_budget_status_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountBudgetStatusState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountBudgetStatusState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountBudgetStatusState()';
}


}

/// @nodoc
class $AccountBudgetStatusStateCopyWith<$Res>  {
$AccountBudgetStatusStateCopyWith(AccountBudgetStatusState _, $Res Function(AccountBudgetStatusState) __);
}


/// Adds pattern-matching-related methods to [AccountBudgetStatusState].
extension AccountBudgetStatusStatePatterns on AccountBudgetStatusState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AccountBudgetStatusInitial value)?  initial,TResult Function( _AccountBudgetStatusLoading value)?  loading,TResult Function( _AccountBudgetStatusLoaded value)?  loaded,TResult Function( _AccountBudgetStatusError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountBudgetStatusInitial() when initial != null:
return initial(_that);case _AccountBudgetStatusLoading() when loading != null:
return loading(_that);case _AccountBudgetStatusLoaded() when loaded != null:
return loaded(_that);case _AccountBudgetStatusError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AccountBudgetStatusInitial value)  initial,required TResult Function( _AccountBudgetStatusLoading value)  loading,required TResult Function( _AccountBudgetStatusLoaded value)  loaded,required TResult Function( _AccountBudgetStatusError value)  error,}){
final _that = this;
switch (_that) {
case _AccountBudgetStatusInitial():
return initial(_that);case _AccountBudgetStatusLoading():
return loading(_that);case _AccountBudgetStatusLoaded():
return loaded(_that);case _AccountBudgetStatusError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AccountBudgetStatusInitial value)?  initial,TResult? Function( _AccountBudgetStatusLoading value)?  loading,TResult? Function( _AccountBudgetStatusLoaded value)?  loaded,TResult? Function( _AccountBudgetStatusError value)?  error,}){
final _that = this;
switch (_that) {
case _AccountBudgetStatusInitial() when initial != null:
return initial(_that);case _AccountBudgetStatusLoading() when loading != null:
return loading(_that);case _AccountBudgetStatusLoaded() when loaded != null:
return loaded(_that);case _AccountBudgetStatusError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( AccountBudgetStatus status)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountBudgetStatusInitial() when initial != null:
return initial();case _AccountBudgetStatusLoading() when loading != null:
return loading();case _AccountBudgetStatusLoaded() when loaded != null:
return loaded(_that.status);case _AccountBudgetStatusError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( AccountBudgetStatus status)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _AccountBudgetStatusInitial():
return initial();case _AccountBudgetStatusLoading():
return loading();case _AccountBudgetStatusLoaded():
return loaded(_that.status);case _AccountBudgetStatusError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( AccountBudgetStatus status)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _AccountBudgetStatusInitial() when initial != null:
return initial();case _AccountBudgetStatusLoading() when loading != null:
return loading();case _AccountBudgetStatusLoaded() when loaded != null:
return loaded(_that.status);case _AccountBudgetStatusError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _AccountBudgetStatusInitial implements AccountBudgetStatusState {
  const _AccountBudgetStatusInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountBudgetStatusInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountBudgetStatusState.initial()';
}


}




/// @nodoc


class _AccountBudgetStatusLoading implements AccountBudgetStatusState {
  const _AccountBudgetStatusLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountBudgetStatusLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountBudgetStatusState.loading()';
}


}




/// @nodoc


class _AccountBudgetStatusLoaded implements AccountBudgetStatusState {
  const _AccountBudgetStatusLoaded({required this.status});
  

 final  AccountBudgetStatus status;

/// Create a copy of AccountBudgetStatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountBudgetStatusLoadedCopyWith<_AccountBudgetStatusLoaded> get copyWith => __$AccountBudgetStatusLoadedCopyWithImpl<_AccountBudgetStatusLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountBudgetStatusLoaded&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'AccountBudgetStatusState.loaded(status: $status)';
}


}

/// @nodoc
abstract mixin class _$AccountBudgetStatusLoadedCopyWith<$Res> implements $AccountBudgetStatusStateCopyWith<$Res> {
  factory _$AccountBudgetStatusLoadedCopyWith(_AccountBudgetStatusLoaded value, $Res Function(_AccountBudgetStatusLoaded) _then) = __$AccountBudgetStatusLoadedCopyWithImpl;
@useResult
$Res call({
 AccountBudgetStatus status
});




}
/// @nodoc
class __$AccountBudgetStatusLoadedCopyWithImpl<$Res>
    implements _$AccountBudgetStatusLoadedCopyWith<$Res> {
  __$AccountBudgetStatusLoadedCopyWithImpl(this._self, this._then);

  final _AccountBudgetStatusLoaded _self;
  final $Res Function(_AccountBudgetStatusLoaded) _then;

/// Create a copy of AccountBudgetStatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_AccountBudgetStatusLoaded(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountBudgetStatus,
  ));
}


}

/// @nodoc


class _AccountBudgetStatusError implements AccountBudgetStatusState {
  const _AccountBudgetStatusError({required this.message});
  

 final  String message;

/// Create a copy of AccountBudgetStatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountBudgetStatusErrorCopyWith<_AccountBudgetStatusError> get copyWith => __$AccountBudgetStatusErrorCopyWithImpl<_AccountBudgetStatusError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountBudgetStatusError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AccountBudgetStatusState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AccountBudgetStatusErrorCopyWith<$Res> implements $AccountBudgetStatusStateCopyWith<$Res> {
  factory _$AccountBudgetStatusErrorCopyWith(_AccountBudgetStatusError value, $Res Function(_AccountBudgetStatusError) _then) = __$AccountBudgetStatusErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$AccountBudgetStatusErrorCopyWithImpl<$Res>
    implements _$AccountBudgetStatusErrorCopyWith<$Res> {
  __$AccountBudgetStatusErrorCopyWithImpl(this._self, this._then);

  final _AccountBudgetStatusError _self;
  final $Res Function(_AccountBudgetStatusError) _then;

/// Create a copy of AccountBudgetStatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_AccountBudgetStatusError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
