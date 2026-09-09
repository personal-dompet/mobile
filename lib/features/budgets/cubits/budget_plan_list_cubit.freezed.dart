// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_plan_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetPlanListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetPlanListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetPlanListState()';
}


}

/// @nodoc
class $BudgetPlanListStateCopyWith<$Res>  {
$BudgetPlanListStateCopyWith(BudgetPlanListState _, $Res Function(BudgetPlanListState) __);
}


/// Adds pattern-matching-related methods to [BudgetPlanListState].
extension BudgetPlanListStatePatterns on BudgetPlanListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _BudgetPlanListInitial value)?  initial,TResult Function( _BudgetPlanListLoading value)?  loading,TResult Function( _BudgetPlanListLoaded value)?  loaded,TResult Function( _BudgetPlanListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetPlanListInitial() when initial != null:
return initial(_that);case _BudgetPlanListLoading() when loading != null:
return loading(_that);case _BudgetPlanListLoaded() when loaded != null:
return loaded(_that);case _BudgetPlanListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _BudgetPlanListInitial value)  initial,required TResult Function( _BudgetPlanListLoading value)  loading,required TResult Function( _BudgetPlanListLoaded value)  loaded,required TResult Function( _BudgetPlanListError value)  error,}){
final _that = this;
switch (_that) {
case _BudgetPlanListInitial():
return initial(_that);case _BudgetPlanListLoading():
return loading(_that);case _BudgetPlanListLoaded():
return loaded(_that);case _BudgetPlanListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _BudgetPlanListInitial value)?  initial,TResult? Function( _BudgetPlanListLoading value)?  loading,TResult? Function( _BudgetPlanListLoaded value)?  loaded,TResult? Function( _BudgetPlanListError value)?  error,}){
final _that = this;
switch (_that) {
case _BudgetPlanListInitial() when initial != null:
return initial(_that);case _BudgetPlanListLoading() when loading != null:
return loading(_that);case _BudgetPlanListLoaded() when loaded != null:
return loaded(_that);case _BudgetPlanListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<({BudgetPlan plan, Account category})> items)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetPlanListInitial() when initial != null:
return initial();case _BudgetPlanListLoading() when loading != null:
return loading();case _BudgetPlanListLoaded() when loaded != null:
return loaded(_that.items);case _BudgetPlanListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<({BudgetPlan plan, Account category})> items)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _BudgetPlanListInitial():
return initial();case _BudgetPlanListLoading():
return loading();case _BudgetPlanListLoaded():
return loaded(_that.items);case _BudgetPlanListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<({BudgetPlan plan, Account category})> items)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _BudgetPlanListInitial() when initial != null:
return initial();case _BudgetPlanListLoading() when loading != null:
return loading();case _BudgetPlanListLoaded() when loaded != null:
return loaded(_that.items);case _BudgetPlanListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetPlanListInitial implements BudgetPlanListState {
  const _BudgetPlanListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetPlanListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetPlanListState.initial()';
}


}




/// @nodoc


class _BudgetPlanListLoading implements BudgetPlanListState {
  const _BudgetPlanListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetPlanListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BudgetPlanListState.loading()';
}


}




/// @nodoc


class _BudgetPlanListLoaded implements BudgetPlanListState {
  const _BudgetPlanListLoaded({final  List<({BudgetPlan plan, Account category})> items = const []}): _items = items;
  

 final  List<({BudgetPlan plan, Account category})> _items;
@JsonKey() List<({BudgetPlan plan, Account category})> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of BudgetPlanListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetPlanListLoadedCopyWith<_BudgetPlanListLoaded> get copyWith => __$BudgetPlanListLoadedCopyWithImpl<_BudgetPlanListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetPlanListLoaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'BudgetPlanListState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class _$BudgetPlanListLoadedCopyWith<$Res> implements $BudgetPlanListStateCopyWith<$Res> {
  factory _$BudgetPlanListLoadedCopyWith(_BudgetPlanListLoaded value, $Res Function(_BudgetPlanListLoaded) _then) = __$BudgetPlanListLoadedCopyWithImpl;
@useResult
$Res call({
 List<({BudgetPlan plan, Account category})> items
});




}
/// @nodoc
class __$BudgetPlanListLoadedCopyWithImpl<$Res>
    implements _$BudgetPlanListLoadedCopyWith<$Res> {
  __$BudgetPlanListLoadedCopyWithImpl(this._self, this._then);

  final _BudgetPlanListLoaded _self;
  final $Res Function(_BudgetPlanListLoaded) _then;

/// Create a copy of BudgetPlanListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_BudgetPlanListLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<({BudgetPlan plan, Account category})>,
  ));
}


}

/// @nodoc


class _BudgetPlanListError implements BudgetPlanListState {
  const _BudgetPlanListError({required this.message});
  

 final  String message;

/// Create a copy of BudgetPlanListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetPlanListErrorCopyWith<_BudgetPlanListError> get copyWith => __$BudgetPlanListErrorCopyWithImpl<_BudgetPlanListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetPlanListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BudgetPlanListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$BudgetPlanListErrorCopyWith<$Res> implements $BudgetPlanListStateCopyWith<$Res> {
  factory _$BudgetPlanListErrorCopyWith(_BudgetPlanListError value, $Res Function(_BudgetPlanListError) _then) = __$BudgetPlanListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$BudgetPlanListErrorCopyWithImpl<$Res>
    implements _$BudgetPlanListErrorCopyWith<$Res> {
  __$BudgetPlanListErrorCopyWithImpl(this._self, this._then);

  final _BudgetPlanListError _self;
  final $Res Function(_BudgetPlanListError) _then;

/// Create a copy of BudgetPlanListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_BudgetPlanListError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
