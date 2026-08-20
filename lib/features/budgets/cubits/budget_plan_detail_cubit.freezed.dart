// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_plan_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetPlanDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetPlanDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetPlanDetailState()';
}


}

/// @nodoc
class $BudgetPlanDetailStateCopyWith<$Res>  {
$BudgetPlanDetailStateCopyWith(BudgetPlanDetailState _, $Res Function(BudgetPlanDetailState) __);
}


/// Adds pattern-matching-related methods to [BudgetPlanDetailState].
extension BudgetPlanDetailStatePatterns on BudgetPlanDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _BudgetPlanDetailInitial value)?  initial,TResult Function( _BudgetPlanDetailLoading value)?  loading,TResult Function( _BudgetPlanDetailLoaded value)?  loaded,TResult Function( _BudgetPlanDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetPlanDetailInitial() when initial != null:
return initial(_that);case _BudgetPlanDetailLoading() when loading != null:
return loading(_that);case _BudgetPlanDetailLoaded() when loaded != null:
return loaded(_that);case _BudgetPlanDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _BudgetPlanDetailInitial value)  initial,required TResult Function( _BudgetPlanDetailLoading value)  loading,required TResult Function( _BudgetPlanDetailLoaded value)  loaded,required TResult Function( _BudgetPlanDetailError value)  error,}){
final _that = this;
switch (_that) {
case _BudgetPlanDetailInitial():
return initial(_that);case _BudgetPlanDetailLoading():
return loading(_that);case _BudgetPlanDetailLoaded():
return loaded(_that);case _BudgetPlanDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _BudgetPlanDetailInitial value)?  initial,TResult? Function( _BudgetPlanDetailLoading value)?  loading,TResult? Function( _BudgetPlanDetailLoaded value)?  loaded,TResult? Function( _BudgetPlanDetailError value)?  error,}){
final _that = this;
switch (_that) {
case _BudgetPlanDetailInitial() when initial != null:
return initial(_that);case _BudgetPlanDetailLoading() when loading != null:
return loading(_that);case _BudgetPlanDetailLoaded() when loaded != null:
return loaded(_that);case _BudgetPlanDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( BudgetPlan plan,  List<Budget> activeBudgets)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetPlanDetailInitial() when initial != null:
return initial();case _BudgetPlanDetailLoading() when loading != null:
return loading();case _BudgetPlanDetailLoaded() when loaded != null:
return loaded(_that.plan,_that.activeBudgets);case _BudgetPlanDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( BudgetPlan plan,  List<Budget> activeBudgets)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _BudgetPlanDetailInitial():
return initial();case _BudgetPlanDetailLoading():
return loading();case _BudgetPlanDetailLoaded():
return loaded(_that.plan,_that.activeBudgets);case _BudgetPlanDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( BudgetPlan plan,  List<Budget> activeBudgets)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _BudgetPlanDetailInitial() when initial != null:
return initial();case _BudgetPlanDetailLoading() when loading != null:
return loading();case _BudgetPlanDetailLoaded() when loaded != null:
return loaded(_that.plan,_that.activeBudgets);case _BudgetPlanDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetPlanDetailInitial implements BudgetPlanDetailState {
  const _BudgetPlanDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetPlanDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetPlanDetailState.initial()';
}


}




/// @nodoc


class _BudgetPlanDetailLoading implements BudgetPlanDetailState {
  const _BudgetPlanDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetPlanDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetPlanDetailState.loading()';
}


}




/// @nodoc


class _BudgetPlanDetailLoaded implements BudgetPlanDetailState {
  const _BudgetPlanDetailLoaded({required this.plan, required final  List<Budget> activeBudgets}): _activeBudgets = activeBudgets;
  

 final  BudgetPlan plan;
 final  List<Budget> _activeBudgets;
 List<Budget> get activeBudgets {
  if (_activeBudgets is EqualUnmodifiableListView) return _activeBudgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeBudgets);
}


/// Create a copy of BudgetPlanDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetPlanDetailLoadedCopyWith<_BudgetPlanDetailLoaded> get copyWith => __$BudgetPlanDetailLoadedCopyWithImpl<_BudgetPlanDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetPlanDetailLoaded&&(identical(other.plan, plan) || other.plan == plan)&&const DeepCollectionEquality().equals(other._activeBudgets, _activeBudgets));
}


@override
int get hashCode => Object.hash(runtimeType,plan,const DeepCollectionEquality().hash(_activeBudgets));

@override
String toString() {
  return 'BudgetPlanDetailState.loaded(plan: $plan, activeBudgets: $activeBudgets)';
}


}

/// @nodoc
abstract mixin class _$BudgetPlanDetailLoadedCopyWith<$Res> implements $BudgetPlanDetailStateCopyWith<$Res> {
  factory _$BudgetPlanDetailLoadedCopyWith(_BudgetPlanDetailLoaded value, $Res Function(_BudgetPlanDetailLoaded) _then) = __$BudgetPlanDetailLoadedCopyWithImpl;
@useResult
$Res call({
 BudgetPlan plan, List<Budget> activeBudgets
});


$BudgetPlanCopyWith<$Res> get plan;

}
/// @nodoc
class __$BudgetPlanDetailLoadedCopyWithImpl<$Res>
    implements _$BudgetPlanDetailLoadedCopyWith<$Res> {
  __$BudgetPlanDetailLoadedCopyWithImpl(this._self, this._then);

  final _BudgetPlanDetailLoaded _self;
  final $Res Function(_BudgetPlanDetailLoaded) _then;

/// Create a copy of BudgetPlanDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plan = null,Object? activeBudgets = null,}) {
  return _then(_BudgetPlanDetailLoaded(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as BudgetPlan,activeBudgets: null == activeBudgets ? _self._activeBudgets : activeBudgets // ignore: cast_nullable_to_non_nullable
as List<Budget>,
  ));
}

/// Create a copy of BudgetPlanDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetPlanCopyWith<$Res> get plan {
  
  return $BudgetPlanCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}

/// @nodoc


class _BudgetPlanDetailError implements BudgetPlanDetailState {
  const _BudgetPlanDetailError({required this.message});
  

 final  String message;

/// Create a copy of BudgetPlanDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetPlanDetailErrorCopyWith<_BudgetPlanDetailError> get copyWith => __$BudgetPlanDetailErrorCopyWithImpl<_BudgetPlanDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetPlanDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BudgetPlanDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$BudgetPlanDetailErrorCopyWith<$Res> implements $BudgetPlanDetailStateCopyWith<$Res> {
  factory _$BudgetPlanDetailErrorCopyWith(_BudgetPlanDetailError value, $Res Function(_BudgetPlanDetailError) _then) = __$BudgetPlanDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$BudgetPlanDetailErrorCopyWithImpl<$Res>
    implements _$BudgetPlanDetailErrorCopyWith<$Res> {
  __$BudgetPlanDetailErrorCopyWithImpl(this._self, this._then);

  final _BudgetPlanDetailError _self;
  final $Res Function(_BudgetPlanDetailError) _then;

/// Create a copy of BudgetPlanDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_BudgetPlanDetailError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
