// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saving_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SavingState()';
}


}

/// @nodoc
class $SavingStateCopyWith<$Res>  {
$SavingStateCopyWith(SavingState _, $Res Function(SavingState) __);
}


/// Adds pattern-matching-related methods to [SavingState].
extension SavingStatePatterns on SavingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SavingInitial value)?  initial,TResult Function( _SavingLoading value)?  loading,TResult Function( _SavingRefreshing value)?  refreshing,TResult Function( _SavingLoaded value)?  loaded,TResult Function( _SavingError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingInitial() when initial != null:
return initial(_that);case _SavingLoading() when loading != null:
return loading(_that);case _SavingRefreshing() when refreshing != null:
return refreshing(_that);case _SavingLoaded() when loaded != null:
return loaded(_that);case _SavingError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SavingInitial value)  initial,required TResult Function( _SavingLoading value)  loading,required TResult Function( _SavingRefreshing value)  refreshing,required TResult Function( _SavingLoaded value)  loaded,required TResult Function( _SavingError value)  error,}){
final _that = this;
switch (_that) {
case _SavingInitial():
return initial(_that);case _SavingLoading():
return loading(_that);case _SavingRefreshing():
return refreshing(_that);case _SavingLoaded():
return loaded(_that);case _SavingError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SavingInitial value)?  initial,TResult? Function( _SavingLoading value)?  loading,TResult? Function( _SavingRefreshing value)?  refreshing,TResult? Function( _SavingLoaded value)?  loaded,TResult? Function( _SavingError value)?  error,}){
final _that = this;
switch (_that) {
case _SavingInitial() when initial != null:
return initial(_that);case _SavingLoading() when loading != null:
return loading(_that);case _SavingRefreshing() when refreshing != null:
return refreshing(_that);case _SavingLoaded() when loaded != null:
return loaded(_that);case _SavingError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<SavingPlan> plans)?  refreshing,TResult Function( List<SavingPlan> plans)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingInitial() when initial != null:
return initial();case _SavingLoading() when loading != null:
return loading();case _SavingRefreshing() when refreshing != null:
return refreshing(_that.plans);case _SavingLoaded() when loaded != null:
return loaded(_that.plans);case _SavingError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<SavingPlan> plans)  refreshing,required TResult Function( List<SavingPlan> plans)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _SavingInitial():
return initial();case _SavingLoading():
return loading();case _SavingRefreshing():
return refreshing(_that.plans);case _SavingLoaded():
return loaded(_that.plans);case _SavingError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<SavingPlan> plans)?  refreshing,TResult? Function( List<SavingPlan> plans)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _SavingInitial() when initial != null:
return initial();case _SavingLoading() when loading != null:
return loading();case _SavingRefreshing() when refreshing != null:
return refreshing(_that.plans);case _SavingLoaded() when loaded != null:
return loaded(_that.plans);case _SavingError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _SavingInitial implements SavingState {
  const _SavingInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SavingState.initial()';
}


}




/// @nodoc


class _SavingLoading implements SavingState {
  const _SavingLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SavingState.loading()';
}


}




/// @nodoc


class _SavingRefreshing implements SavingState {
  const _SavingRefreshing({final  List<SavingPlan> plans = const []}): _plans = plans;
  

 final  List<SavingPlan> _plans;
@JsonKey() List<SavingPlan> get plans {
  if (_plans is EqualUnmodifiableListView) return _plans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plans);
}


/// Create a copy of SavingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingRefreshingCopyWith<_SavingRefreshing> get copyWith => __$SavingRefreshingCopyWithImpl<_SavingRefreshing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingRefreshing&&const DeepCollectionEquality().equals(other._plans, _plans));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_plans));

@override
String toString() {
  return 'SavingState.refreshing(plans: $plans)';
}


}

/// @nodoc
abstract mixin class _$SavingRefreshingCopyWith<$Res> implements $SavingStateCopyWith<$Res> {
  factory _$SavingRefreshingCopyWith(_SavingRefreshing value, $Res Function(_SavingRefreshing) _then) = __$SavingRefreshingCopyWithImpl;
@useResult
$Res call({
 List<SavingPlan> plans
});




}
/// @nodoc
class __$SavingRefreshingCopyWithImpl<$Res>
    implements _$SavingRefreshingCopyWith<$Res> {
  __$SavingRefreshingCopyWithImpl(this._self, this._then);

  final _SavingRefreshing _self;
  final $Res Function(_SavingRefreshing) _then;

/// Create a copy of SavingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plans = null,}) {
  return _then(_SavingRefreshing(
plans: null == plans ? _self._plans : plans // ignore: cast_nullable_to_non_nullable
as List<SavingPlan>,
  ));
}


}

/// @nodoc


class _SavingLoaded implements SavingState {
  const _SavingLoaded({final  List<SavingPlan> plans = const []}): _plans = plans;
  

 final  List<SavingPlan> _plans;
@JsonKey() List<SavingPlan> get plans {
  if (_plans is EqualUnmodifiableListView) return _plans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plans);
}


/// Create a copy of SavingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingLoadedCopyWith<_SavingLoaded> get copyWith => __$SavingLoadedCopyWithImpl<_SavingLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingLoaded&&const DeepCollectionEquality().equals(other._plans, _plans));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_plans));

@override
String toString() {
  return 'SavingState.loaded(plans: $plans)';
}


}

/// @nodoc
abstract mixin class _$SavingLoadedCopyWith<$Res> implements $SavingStateCopyWith<$Res> {
  factory _$SavingLoadedCopyWith(_SavingLoaded value, $Res Function(_SavingLoaded) _then) = __$SavingLoadedCopyWithImpl;
@useResult
$Res call({
 List<SavingPlan> plans
});




}
/// @nodoc
class __$SavingLoadedCopyWithImpl<$Res>
    implements _$SavingLoadedCopyWith<$Res> {
  __$SavingLoadedCopyWithImpl(this._self, this._then);

  final _SavingLoaded _self;
  final $Res Function(_SavingLoaded) _then;

/// Create a copy of SavingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plans = null,}) {
  return _then(_SavingLoaded(
plans: null == plans ? _self._plans : plans // ignore: cast_nullable_to_non_nullable
as List<SavingPlan>,
  ));
}


}

/// @nodoc


class _SavingError implements SavingState {
  const _SavingError({required this.message});
  

 final  String message;

/// Create a copy of SavingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingErrorCopyWith<_SavingError> get copyWith => __$SavingErrorCopyWithImpl<_SavingError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SavingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$SavingErrorCopyWith<$Res> implements $SavingStateCopyWith<$Res> {
  factory _$SavingErrorCopyWith(_SavingError value, $Res Function(_SavingError) _then) = __$SavingErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$SavingErrorCopyWithImpl<$Res>
    implements _$SavingErrorCopyWith<$Res> {
  __$SavingErrorCopyWithImpl(this._self, this._then);

  final _SavingError _self;
  final $Res Function(_SavingError) _then;

/// Create a copy of SavingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_SavingError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
