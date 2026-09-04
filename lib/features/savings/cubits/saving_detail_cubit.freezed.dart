// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saving_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavingDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SavingDetailState()';
}


}

/// @nodoc
class $SavingDetailStateCopyWith<$Res>  {
$SavingDetailStateCopyWith(SavingDetailState _, $Res Function(SavingDetailState) __);
}


/// Adds pattern-matching-related methods to [SavingDetailState].
extension SavingDetailStatePatterns on SavingDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SavingDetailInitial value)?  initial,TResult Function( _SavingDetailLoading value)?  loading,TResult Function( _SavingDetailLoaded value)?  loaded,TResult Function( _SavingDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingDetailInitial() when initial != null:
return initial(_that);case _SavingDetailLoading() when loading != null:
return loading(_that);case _SavingDetailLoaded() when loaded != null:
return loaded(_that);case _SavingDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SavingDetailInitial value)  initial,required TResult Function( _SavingDetailLoading value)  loading,required TResult Function( _SavingDetailLoaded value)  loaded,required TResult Function( _SavingDetailError value)  error,}){
final _that = this;
switch (_that) {
case _SavingDetailInitial():
return initial(_that);case _SavingDetailLoading():
return loading(_that);case _SavingDetailLoaded():
return loaded(_that);case _SavingDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SavingDetailInitial value)?  initial,TResult? Function( _SavingDetailLoading value)?  loading,TResult? Function( _SavingDetailLoaded value)?  loaded,TResult? Function( _SavingDetailError value)?  error,}){
final _that = this;
switch (_that) {
case _SavingDetailInitial() when initial != null:
return initial(_that);case _SavingDetailLoading() when loading != null:
return loading(_that);case _SavingDetailLoaded() when loaded != null:
return loaded(_that);case _SavingDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( SavingPlan? plan)?  loading,TResult Function( SavingDetail detail)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingDetailInitial() when initial != null:
return initial();case _SavingDetailLoading() when loading != null:
return loading(_that.plan);case _SavingDetailLoaded() when loaded != null:
return loaded(_that.detail);case _SavingDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( SavingPlan? plan)  loading,required TResult Function( SavingDetail detail)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _SavingDetailInitial():
return initial();case _SavingDetailLoading():
return loading(_that.plan);case _SavingDetailLoaded():
return loaded(_that.detail);case _SavingDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( SavingPlan? plan)?  loading,TResult? Function( SavingDetail detail)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _SavingDetailInitial() when initial != null:
return initial();case _SavingDetailLoading() when loading != null:
return loading(_that.plan);case _SavingDetailLoaded() when loaded != null:
return loaded(_that.detail);case _SavingDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _SavingDetailInitial implements SavingDetailState {
  const _SavingDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SavingDetailState.initial()';
}


}




/// @nodoc


class _SavingDetailLoading implements SavingDetailState {
  const _SavingDetailLoading({this.plan});
  

 final  SavingPlan? plan;

/// Create a copy of SavingDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingDetailLoadingCopyWith<_SavingDetailLoading> get copyWith => __$SavingDetailLoadingCopyWithImpl<_SavingDetailLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingDetailLoading&&(identical(other.plan, plan) || other.plan == plan));
}


@override
int get hashCode => Object.hash(runtimeType,plan);

@override
String toString() {
  return 'SavingDetailState.loading(plan: $plan)';
}


}

/// @nodoc
abstract mixin class _$SavingDetailLoadingCopyWith<$Res> implements $SavingDetailStateCopyWith<$Res> {
  factory _$SavingDetailLoadingCopyWith(_SavingDetailLoading value, $Res Function(_SavingDetailLoading) _then) = __$SavingDetailLoadingCopyWithImpl;
@useResult
$Res call({
 SavingPlan? plan
});


$SavingPlanCopyWith<$Res>? get plan;

}
/// @nodoc
class __$SavingDetailLoadingCopyWithImpl<$Res>
    implements _$SavingDetailLoadingCopyWith<$Res> {
  __$SavingDetailLoadingCopyWithImpl(this._self, this._then);

  final _SavingDetailLoading _self;
  final $Res Function(_SavingDetailLoading) _then;

/// Create a copy of SavingDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plan = freezed,}) {
  return _then(_SavingDetailLoading(
plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as SavingPlan?,
  ));
}

/// Create a copy of SavingDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SavingPlanCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $SavingPlanCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}

/// @nodoc


class _SavingDetailLoaded implements SavingDetailState {
  const _SavingDetailLoaded({required this.detail});
  

 final  SavingDetail detail;

/// Create a copy of SavingDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingDetailLoadedCopyWith<_SavingDetailLoaded> get copyWith => __$SavingDetailLoadedCopyWithImpl<_SavingDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingDetailLoaded&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,detail);

@override
String toString() {
  return 'SavingDetailState.loaded(detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$SavingDetailLoadedCopyWith<$Res> implements $SavingDetailStateCopyWith<$Res> {
  factory _$SavingDetailLoadedCopyWith(_SavingDetailLoaded value, $Res Function(_SavingDetailLoaded) _then) = __$SavingDetailLoadedCopyWithImpl;
@useResult
$Res call({
 SavingDetail detail
});




}
/// @nodoc
class __$SavingDetailLoadedCopyWithImpl<$Res>
    implements _$SavingDetailLoadedCopyWith<$Res> {
  __$SavingDetailLoadedCopyWithImpl(this._self, this._then);

  final _SavingDetailLoaded _self;
  final $Res Function(_SavingDetailLoaded) _then;

/// Create a copy of SavingDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = null,}) {
  return _then(_SavingDetailLoaded(
detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as SavingDetail,
  ));
}


}

/// @nodoc


class _SavingDetailError implements SavingDetailState {
  const _SavingDetailError({required this.message});
  

 final  String message;

/// Create a copy of SavingDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingDetailErrorCopyWith<_SavingDetailError> get copyWith => __$SavingDetailErrorCopyWithImpl<_SavingDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SavingDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$SavingDetailErrorCopyWith<$Res> implements $SavingDetailStateCopyWith<$Res> {
  factory _$SavingDetailErrorCopyWith(_SavingDetailError value, $Res Function(_SavingDetailError) _then) = __$SavingDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$SavingDetailErrorCopyWithImpl<$Res>
    implements _$SavingDetailErrorCopyWith<$Res> {
  __$SavingDetailErrorCopyWithImpl(this._self, this._then);

  final _SavingDetailError _self;
  final $Res Function(_SavingDetailError) _then;

/// Create a copy of SavingDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_SavingDetailError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
