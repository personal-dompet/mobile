// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetState()';
}


}

/// @nodoc
class $BudgetStateCopyWith<$Res>  {
$BudgetStateCopyWith(BudgetState _, $Res Function(BudgetState) __);
}


/// Adds pattern-matching-related methods to [BudgetState].
extension BudgetStatePatterns on BudgetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _BudgetInitial value)?  initial,TResult Function( _BudgetLoading value)?  loading,TResult Function( _BudgetRefreshing value)?  refreshing,TResult Function( _BudgetLoaded value)?  loaded,TResult Function( _BudgetError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetInitial() when initial != null:
return initial(_that);case _BudgetLoading() when loading != null:
return loading(_that);case _BudgetRefreshing() when refreshing != null:
return refreshing(_that);case _BudgetLoaded() when loaded != null:
return loaded(_that);case _BudgetError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _BudgetInitial value)  initial,required TResult Function( _BudgetLoading value)  loading,required TResult Function( _BudgetRefreshing value)  refreshing,required TResult Function( _BudgetLoaded value)  loaded,required TResult Function( _BudgetError value)  error,}){
final _that = this;
switch (_that) {
case _BudgetInitial():
return initial(_that);case _BudgetLoading():
return loading(_that);case _BudgetRefreshing():
return refreshing(_that);case _BudgetLoaded():
return loaded(_that);case _BudgetError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _BudgetInitial value)?  initial,TResult? Function( _BudgetLoading value)?  loading,TResult? Function( _BudgetRefreshing value)?  refreshing,TResult? Function( _BudgetLoaded value)?  loaded,TResult? Function( _BudgetError value)?  error,}){
final _that = this;
switch (_that) {
case _BudgetInitial() when initial != null:
return initial(_that);case _BudgetLoading() when loading != null:
return loading(_that);case _BudgetRefreshing() when refreshing != null:
return refreshing(_that);case _BudgetLoaded() when loaded != null:
return loaded(_that);case _BudgetError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Budget> budgets)?  refreshing,TResult Function( List<Budget> budgets)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetInitial() when initial != null:
return initial();case _BudgetLoading() when loading != null:
return loading();case _BudgetRefreshing() when refreshing != null:
return refreshing(_that.budgets);case _BudgetLoaded() when loaded != null:
return loaded(_that.budgets);case _BudgetError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Budget> budgets)  refreshing,required TResult Function( List<Budget> budgets)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _BudgetInitial():
return initial();case _BudgetLoading():
return loading();case _BudgetRefreshing():
return refreshing(_that.budgets);case _BudgetLoaded():
return loaded(_that.budgets);case _BudgetError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Budget> budgets)?  refreshing,TResult? Function( List<Budget> budgets)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _BudgetInitial() when initial != null:
return initial();case _BudgetLoading() when loading != null:
return loading();case _BudgetRefreshing() when refreshing != null:
return refreshing(_that.budgets);case _BudgetLoaded() when loaded != null:
return loaded(_that.budgets);case _BudgetError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetInitial implements BudgetState {
  const _BudgetInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetState.initial()';
}


}




/// @nodoc


class _BudgetLoading implements BudgetState {
  const _BudgetLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetState.loading()';
}


}




/// @nodoc


class _BudgetRefreshing implements BudgetState {
  const _BudgetRefreshing({final  List<Budget> budgets = const []}): _budgets = budgets;
  

 final  List<Budget> _budgets;
@JsonKey() List<Budget> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
}


/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetRefreshingCopyWith<_BudgetRefreshing> get copyWith => __$BudgetRefreshingCopyWithImpl<_BudgetRefreshing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetRefreshing&&const DeepCollectionEquality().equals(other._budgets, _budgets));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_budgets));

@override
String toString() {
  return 'BudgetState.refreshing(budgets: $budgets)';
}


}

/// @nodoc
abstract mixin class _$BudgetRefreshingCopyWith<$Res> implements $BudgetStateCopyWith<$Res> {
  factory _$BudgetRefreshingCopyWith(_BudgetRefreshing value, $Res Function(_BudgetRefreshing) _then) = __$BudgetRefreshingCopyWithImpl;
@useResult
$Res call({
 List<Budget> budgets
});




}
/// @nodoc
class __$BudgetRefreshingCopyWithImpl<$Res>
    implements _$BudgetRefreshingCopyWith<$Res> {
  __$BudgetRefreshingCopyWithImpl(this._self, this._then);

  final _BudgetRefreshing _self;
  final $Res Function(_BudgetRefreshing) _then;

/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? budgets = null,}) {
  return _then(_BudgetRefreshing(
budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<Budget>,
  ));
}


}

/// @nodoc


class _BudgetLoaded implements BudgetState {
  const _BudgetLoaded({final  List<Budget> budgets = const []}): _budgets = budgets;
  

 final  List<Budget> _budgets;
@JsonKey() List<Budget> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
}


/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetLoadedCopyWith<_BudgetLoaded> get copyWith => __$BudgetLoadedCopyWithImpl<_BudgetLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetLoaded&&const DeepCollectionEquality().equals(other._budgets, _budgets));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_budgets));

@override
String toString() {
  return 'BudgetState.loaded(budgets: $budgets)';
}


}

/// @nodoc
abstract mixin class _$BudgetLoadedCopyWith<$Res> implements $BudgetStateCopyWith<$Res> {
  factory _$BudgetLoadedCopyWith(_BudgetLoaded value, $Res Function(_BudgetLoaded) _then) = __$BudgetLoadedCopyWithImpl;
@useResult
$Res call({
 List<Budget> budgets
});




}
/// @nodoc
class __$BudgetLoadedCopyWithImpl<$Res>
    implements _$BudgetLoadedCopyWith<$Res> {
  __$BudgetLoadedCopyWithImpl(this._self, this._then);

  final _BudgetLoaded _self;
  final $Res Function(_BudgetLoaded) _then;

/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? budgets = null,}) {
  return _then(_BudgetLoaded(
budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<Budget>,
  ));
}


}

/// @nodoc


class _BudgetError implements BudgetState {
  const _BudgetError({required this.message});
  

 final  String message;

/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetErrorCopyWith<_BudgetError> get copyWith => __$BudgetErrorCopyWithImpl<_BudgetError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BudgetState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$BudgetErrorCopyWith<$Res> implements $BudgetStateCopyWith<$Res> {
  factory _$BudgetErrorCopyWith(_BudgetError value, $Res Function(_BudgetError) _then) = __$BudgetErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$BudgetErrorCopyWithImpl<$Res>
    implements _$BudgetErrorCopyWith<$Res> {
  __$BudgetErrorCopyWithImpl(this._self, this._then);

  final _BudgetError _self;
  final $Res Function(_BudgetError) _then;

/// Create a copy of BudgetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_BudgetError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
