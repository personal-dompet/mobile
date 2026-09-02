// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetDetailState()';
}


}

/// @nodoc
class $BudgetDetailStateCopyWith<$Res>  {
$BudgetDetailStateCopyWith(BudgetDetailState _, $Res Function(BudgetDetailState) __);
}


/// Adds pattern-matching-related methods to [BudgetDetailState].
extension BudgetDetailStatePatterns on BudgetDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _BudgetDetailInitial value)?  initial,TResult Function( _BudgetDetailLoading value)?  loading,TResult Function( _BudgetDetailLoaded value)?  loaded,TResult Function( _BudgetDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetDetailInitial() when initial != null:
return initial(_that);case _BudgetDetailLoading() when loading != null:
return loading(_that);case _BudgetDetailLoaded() when loaded != null:
return loaded(_that);case _BudgetDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _BudgetDetailInitial value)  initial,required TResult Function( _BudgetDetailLoading value)  loading,required TResult Function( _BudgetDetailLoaded value)  loaded,required TResult Function( _BudgetDetailError value)  error,}){
final _that = this;
switch (_that) {
case _BudgetDetailInitial():
return initial(_that);case _BudgetDetailLoading():
return loading(_that);case _BudgetDetailLoaded():
return loaded(_that);case _BudgetDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _BudgetDetailInitial value)?  initial,TResult? Function( _BudgetDetailLoading value)?  loading,TResult? Function( _BudgetDetailLoaded value)?  loaded,TResult? Function( _BudgetDetailError value)?  error,}){
final _that = this;
switch (_that) {
case _BudgetDetailInitial() when initial != null:
return initial(_that);case _BudgetDetailLoading() when loading != null:
return loading(_that);case _BudgetDetailLoaded() when loaded != null:
return loaded(_that);case _BudgetDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( BudgetDetail detail)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetDetailInitial() when initial != null:
return initial();case _BudgetDetailLoading() when loading != null:
return loading();case _BudgetDetailLoaded() when loaded != null:
return loaded(_that.detail);case _BudgetDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( BudgetDetail detail)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _BudgetDetailInitial():
return initial();case _BudgetDetailLoading():
return loading();case _BudgetDetailLoaded():
return loaded(_that.detail);case _BudgetDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( BudgetDetail detail)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _BudgetDetailInitial() when initial != null:
return initial();case _BudgetDetailLoading() when loading != null:
return loading();case _BudgetDetailLoaded() when loaded != null:
return loaded(_that.detail);case _BudgetDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetDetailInitial implements BudgetDetailState {
  const _BudgetDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetDetailState.initial()';
}


}




/// @nodoc


class _BudgetDetailLoading implements BudgetDetailState {
  const _BudgetDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetDetailState.loading()';
}


}




/// @nodoc


class _BudgetDetailLoaded implements BudgetDetailState {
  const _BudgetDetailLoaded({required this.detail});
  

 final  BudgetDetail detail;

/// Create a copy of BudgetDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetDetailLoadedCopyWith<_BudgetDetailLoaded> get copyWith => __$BudgetDetailLoadedCopyWithImpl<_BudgetDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetDetailLoaded&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,detail);

@override
String toString() {
  return 'BudgetDetailState.loaded(detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$BudgetDetailLoadedCopyWith<$Res> implements $BudgetDetailStateCopyWith<$Res> {
  factory _$BudgetDetailLoadedCopyWith(_BudgetDetailLoaded value, $Res Function(_BudgetDetailLoaded) _then) = __$BudgetDetailLoadedCopyWithImpl;
@useResult
$Res call({
 BudgetDetail detail
});




}
/// @nodoc
class __$BudgetDetailLoadedCopyWithImpl<$Res>
    implements _$BudgetDetailLoadedCopyWith<$Res> {
  __$BudgetDetailLoadedCopyWithImpl(this._self, this._then);

  final _BudgetDetailLoaded _self;
  final $Res Function(_BudgetDetailLoaded) _then;

/// Create a copy of BudgetDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = null,}) {
  return _then(_BudgetDetailLoaded(
detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as BudgetDetail,
  ));
}


}

/// @nodoc


class _BudgetDetailError implements BudgetDetailState {
  const _BudgetDetailError({required this.message});
  

 final  String message;

/// Create a copy of BudgetDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetDetailErrorCopyWith<_BudgetDetailError> get copyWith => __$BudgetDetailErrorCopyWithImpl<_BudgetDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BudgetDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$BudgetDetailErrorCopyWith<$Res> implements $BudgetDetailStateCopyWith<$Res> {
  factory _$BudgetDetailErrorCopyWith(_BudgetDetailError value, $Res Function(_BudgetDetailError) _then) = __$BudgetDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$BudgetDetailErrorCopyWithImpl<$Res>
    implements _$BudgetDetailErrorCopyWith<$Res> {
  __$BudgetDetailErrorCopyWithImpl(this._self, this._then);

  final _BudgetDetailError _self;
  final $Res Function(_BudgetDetailError) _then;

/// Create a copy of BudgetDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_BudgetDetailError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
