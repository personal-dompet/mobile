// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivityDetailState()';
}


}

/// @nodoc
class $ActivityDetailStateCopyWith<$Res>  {
$ActivityDetailStateCopyWith(ActivityDetailState _, $Res Function(ActivityDetailState) __);
}


/// Adds pattern-matching-related methods to [ActivityDetailState].
extension ActivityDetailStatePatterns on ActivityDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ActivityDetailInitial value)?  initial,TResult Function( _ActivityDetailLoading value)?  loading,TResult Function( _ActivityDetailActionLoading value)?  actionLoading,TResult Function( _ActivityDetailLoaded value)?  loaded,TResult Function( _ActivityDetailActionSuccess value)?  actionSuccess,TResult Function( _ActivityDetailError value)?  error,TResult Function( _ActivityDetailActionError value)?  actionError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityDetailInitial() when initial != null:
return initial(_that);case _ActivityDetailLoading() when loading != null:
return loading(_that);case _ActivityDetailActionLoading() when actionLoading != null:
return actionLoading(_that);case _ActivityDetailLoaded() when loaded != null:
return loaded(_that);case _ActivityDetailActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _ActivityDetailError() when error != null:
return error(_that);case _ActivityDetailActionError() when actionError != null:
return actionError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ActivityDetailInitial value)  initial,required TResult Function( _ActivityDetailLoading value)  loading,required TResult Function( _ActivityDetailActionLoading value)  actionLoading,required TResult Function( _ActivityDetailLoaded value)  loaded,required TResult Function( _ActivityDetailActionSuccess value)  actionSuccess,required TResult Function( _ActivityDetailError value)  error,required TResult Function( _ActivityDetailActionError value)  actionError,}){
final _that = this;
switch (_that) {
case _ActivityDetailInitial():
return initial(_that);case _ActivityDetailLoading():
return loading(_that);case _ActivityDetailActionLoading():
return actionLoading(_that);case _ActivityDetailLoaded():
return loaded(_that);case _ActivityDetailActionSuccess():
return actionSuccess(_that);case _ActivityDetailError():
return error(_that);case _ActivityDetailActionError():
return actionError(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ActivityDetailInitial value)?  initial,TResult? Function( _ActivityDetailLoading value)?  loading,TResult? Function( _ActivityDetailActionLoading value)?  actionLoading,TResult? Function( _ActivityDetailLoaded value)?  loaded,TResult? Function( _ActivityDetailActionSuccess value)?  actionSuccess,TResult? Function( _ActivityDetailError value)?  error,TResult? Function( _ActivityDetailActionError value)?  actionError,}){
final _that = this;
switch (_that) {
case _ActivityDetailInitial() when initial != null:
return initial(_that);case _ActivityDetailLoading() when loading != null:
return loading(_that);case _ActivityDetailActionLoading() when actionLoading != null:
return actionLoading(_that);case _ActivityDetailLoaded() when loaded != null:
return loaded(_that);case _ActivityDetailActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _ActivityDetailError() when error != null:
return error(_that);case _ActivityDetailActionError() when actionError != null:
return actionError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( JournalEntry? activity)?  actionLoading,TResult Function( JournalEntry activity)?  loaded,TResult Function( JournalEntry? activity)?  actionSuccess,TResult Function( String message)?  error,TResult Function( JournalEntry? activity,  String message)?  actionError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityDetailInitial() when initial != null:
return initial();case _ActivityDetailLoading() when loading != null:
return loading();case _ActivityDetailActionLoading() when actionLoading != null:
return actionLoading(_that.activity);case _ActivityDetailLoaded() when loaded != null:
return loaded(_that.activity);case _ActivityDetailActionSuccess() when actionSuccess != null:
return actionSuccess(_that.activity);case _ActivityDetailError() when error != null:
return error(_that.message);case _ActivityDetailActionError() when actionError != null:
return actionError(_that.activity,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( JournalEntry? activity)  actionLoading,required TResult Function( JournalEntry activity)  loaded,required TResult Function( JournalEntry? activity)  actionSuccess,required TResult Function( String message)  error,required TResult Function( JournalEntry? activity,  String message)  actionError,}) {final _that = this;
switch (_that) {
case _ActivityDetailInitial():
return initial();case _ActivityDetailLoading():
return loading();case _ActivityDetailActionLoading():
return actionLoading(_that.activity);case _ActivityDetailLoaded():
return loaded(_that.activity);case _ActivityDetailActionSuccess():
return actionSuccess(_that.activity);case _ActivityDetailError():
return error(_that.message);case _ActivityDetailActionError():
return actionError(_that.activity,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( JournalEntry? activity)?  actionLoading,TResult? Function( JournalEntry activity)?  loaded,TResult? Function( JournalEntry? activity)?  actionSuccess,TResult? Function( String message)?  error,TResult? Function( JournalEntry? activity,  String message)?  actionError,}) {final _that = this;
switch (_that) {
case _ActivityDetailInitial() when initial != null:
return initial();case _ActivityDetailLoading() when loading != null:
return loading();case _ActivityDetailActionLoading() when actionLoading != null:
return actionLoading(_that.activity);case _ActivityDetailLoaded() when loaded != null:
return loaded(_that.activity);case _ActivityDetailActionSuccess() when actionSuccess != null:
return actionSuccess(_that.activity);case _ActivityDetailError() when error != null:
return error(_that.message);case _ActivityDetailActionError() when actionError != null:
return actionError(_that.activity,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityDetailInitial implements ActivityDetailState {
  const _ActivityDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivityDetailState.initial()';
}


}




/// @nodoc


class _ActivityDetailLoading implements ActivityDetailState {
  const _ActivityDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivityDetailState.loading()';
}


}




/// @nodoc


class _ActivityDetailActionLoading implements ActivityDetailState {
  const _ActivityDetailActionLoading({this.activity});
  

 final  JournalEntry? activity;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDetailActionLoadingCopyWith<_ActivityDetailActionLoading> get copyWith => __$ActivityDetailActionLoadingCopyWithImpl<_ActivityDetailActionLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDetailActionLoading&&(identical(other.activity, activity) || other.activity == activity));
}


@override
int get hashCode => Object.hash(runtimeType,activity);

@override
String toString() {
  return 'ActivityDetailState.actionLoading(activity: $activity)';
}


}

/// @nodoc
abstract mixin class _$ActivityDetailActionLoadingCopyWith<$Res> implements $ActivityDetailStateCopyWith<$Res> {
  factory _$ActivityDetailActionLoadingCopyWith(_ActivityDetailActionLoading value, $Res Function(_ActivityDetailActionLoading) _then) = __$ActivityDetailActionLoadingCopyWithImpl;
@useResult
$Res call({
 JournalEntry? activity
});


$JournalEntryCopyWith<$Res>? get activity;

}
/// @nodoc
class __$ActivityDetailActionLoadingCopyWithImpl<$Res>
    implements _$ActivityDetailActionLoadingCopyWith<$Res> {
  __$ActivityDetailActionLoadingCopyWithImpl(this._self, this._then);

  final _ActivityDetailActionLoading _self;
  final $Res Function(_ActivityDetailActionLoading) _then;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activity = freezed,}) {
  return _then(_ActivityDetailActionLoading(
activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as JournalEntry?,
  ));
}

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JournalEntryCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $JournalEntryCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}

/// @nodoc


class _ActivityDetailLoaded implements ActivityDetailState {
  const _ActivityDetailLoaded({required this.activity});
  

 final  JournalEntry activity;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDetailLoadedCopyWith<_ActivityDetailLoaded> get copyWith => __$ActivityDetailLoadedCopyWithImpl<_ActivityDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDetailLoaded&&(identical(other.activity, activity) || other.activity == activity));
}


@override
int get hashCode => Object.hash(runtimeType,activity);

@override
String toString() {
  return 'ActivityDetailState.loaded(activity: $activity)';
}


}

/// @nodoc
abstract mixin class _$ActivityDetailLoadedCopyWith<$Res> implements $ActivityDetailStateCopyWith<$Res> {
  factory _$ActivityDetailLoadedCopyWith(_ActivityDetailLoaded value, $Res Function(_ActivityDetailLoaded) _then) = __$ActivityDetailLoadedCopyWithImpl;
@useResult
$Res call({
 JournalEntry activity
});


$JournalEntryCopyWith<$Res> get activity;

}
/// @nodoc
class __$ActivityDetailLoadedCopyWithImpl<$Res>
    implements _$ActivityDetailLoadedCopyWith<$Res> {
  __$ActivityDetailLoadedCopyWithImpl(this._self, this._then);

  final _ActivityDetailLoaded _self;
  final $Res Function(_ActivityDetailLoaded) _then;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activity = null,}) {
  return _then(_ActivityDetailLoaded(
activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as JournalEntry,
  ));
}

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JournalEntryCopyWith<$Res> get activity {
  
  return $JournalEntryCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}

/// @nodoc


class _ActivityDetailActionSuccess implements ActivityDetailState {
  const _ActivityDetailActionSuccess({this.activity});
  

 final  JournalEntry? activity;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDetailActionSuccessCopyWith<_ActivityDetailActionSuccess> get copyWith => __$ActivityDetailActionSuccessCopyWithImpl<_ActivityDetailActionSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDetailActionSuccess&&(identical(other.activity, activity) || other.activity == activity));
}


@override
int get hashCode => Object.hash(runtimeType,activity);

@override
String toString() {
  return 'ActivityDetailState.actionSuccess(activity: $activity)';
}


}

/// @nodoc
abstract mixin class _$ActivityDetailActionSuccessCopyWith<$Res> implements $ActivityDetailStateCopyWith<$Res> {
  factory _$ActivityDetailActionSuccessCopyWith(_ActivityDetailActionSuccess value, $Res Function(_ActivityDetailActionSuccess) _then) = __$ActivityDetailActionSuccessCopyWithImpl;
@useResult
$Res call({
 JournalEntry? activity
});


$JournalEntryCopyWith<$Res>? get activity;

}
/// @nodoc
class __$ActivityDetailActionSuccessCopyWithImpl<$Res>
    implements _$ActivityDetailActionSuccessCopyWith<$Res> {
  __$ActivityDetailActionSuccessCopyWithImpl(this._self, this._then);

  final _ActivityDetailActionSuccess _self;
  final $Res Function(_ActivityDetailActionSuccess) _then;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activity = freezed,}) {
  return _then(_ActivityDetailActionSuccess(
activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as JournalEntry?,
  ));
}

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JournalEntryCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $JournalEntryCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}

/// @nodoc


class _ActivityDetailError implements ActivityDetailState {
  const _ActivityDetailError({required this.message});
  

 final  String message;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDetailErrorCopyWith<_ActivityDetailError> get copyWith => __$ActivityDetailErrorCopyWithImpl<_ActivityDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ActivityDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActivityDetailErrorCopyWith<$Res> implements $ActivityDetailStateCopyWith<$Res> {
  factory _$ActivityDetailErrorCopyWith(_ActivityDetailError value, $Res Function(_ActivityDetailError) _then) = __$ActivityDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ActivityDetailErrorCopyWithImpl<$Res>
    implements _$ActivityDetailErrorCopyWith<$Res> {
  __$ActivityDetailErrorCopyWithImpl(this._self, this._then);

  final _ActivityDetailError _self;
  final $Res Function(_ActivityDetailError) _then;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ActivityDetailError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ActivityDetailActionError implements ActivityDetailState {
  const _ActivityDetailActionError({this.activity, required this.message});
  

 final  JournalEntry? activity;
 final  String message;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDetailActionErrorCopyWith<_ActivityDetailActionError> get copyWith => __$ActivityDetailActionErrorCopyWithImpl<_ActivityDetailActionError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDetailActionError&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,activity,message);

@override
String toString() {
  return 'ActivityDetailState.actionError(activity: $activity, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActivityDetailActionErrorCopyWith<$Res> implements $ActivityDetailStateCopyWith<$Res> {
  factory _$ActivityDetailActionErrorCopyWith(_ActivityDetailActionError value, $Res Function(_ActivityDetailActionError) _then) = __$ActivityDetailActionErrorCopyWithImpl;
@useResult
$Res call({
 JournalEntry? activity, String message
});


$JournalEntryCopyWith<$Res>? get activity;

}
/// @nodoc
class __$ActivityDetailActionErrorCopyWithImpl<$Res>
    implements _$ActivityDetailActionErrorCopyWith<$Res> {
  __$ActivityDetailActionErrorCopyWithImpl(this._self, this._then);

  final _ActivityDetailActionError _self;
  final $Res Function(_ActivityDetailActionError) _then;

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activity = freezed,Object? message = null,}) {
  return _then(_ActivityDetailActionError(
activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as JournalEntry?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ActivityDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JournalEntryCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $JournalEntryCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}

// dart format on
