// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_plan_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BillPlanListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillPlanListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BillPlanListState()';
}


}

/// @nodoc
class $BillPlanListStateCopyWith<$Res>  {
$BillPlanListStateCopyWith(BillPlanListState _, $Res Function(BillPlanListState) __);
}


/// Adds pattern-matching-related methods to [BillPlanListState].
extension BillPlanListStatePatterns on BillPlanListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _BillPlanListInitial value)?  initial,TResult Function( _BillPlanListLoading value)?  loading,TResult Function( _BillPlanListLoaded value)?  loaded,TResult Function( _BillPlanListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillPlanListInitial() when initial != null:
return initial(_that);case _BillPlanListLoading() when loading != null:
return loading(_that);case _BillPlanListLoaded() when loaded != null:
return loaded(_that);case _BillPlanListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _BillPlanListInitial value)  initial,required TResult Function( _BillPlanListLoading value)  loading,required TResult Function( _BillPlanListLoaded value)  loaded,required TResult Function( _BillPlanListError value)  error,}){
final _that = this;
switch (_that) {
case _BillPlanListInitial():
return initial(_that);case _BillPlanListLoading():
return loading(_that);case _BillPlanListLoaded():
return loaded(_that);case _BillPlanListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _BillPlanListInitial value)?  initial,TResult? Function( _BillPlanListLoading value)?  loading,TResult? Function( _BillPlanListLoaded value)?  loaded,TResult? Function( _BillPlanListError value)?  error,}){
final _that = this;
switch (_that) {
case _BillPlanListInitial() when initial != null:
return initial(_that);case _BillPlanListLoading() when loading != null:
return loading(_that);case _BillPlanListLoaded() when loaded != null:
return loaded(_that);case _BillPlanListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<({BillPlan plan, Account category})> items)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillPlanListInitial() when initial != null:
return initial();case _BillPlanListLoading() when loading != null:
return loading();case _BillPlanListLoaded() when loaded != null:
return loaded(_that.items);case _BillPlanListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<({BillPlan plan, Account category})> items)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _BillPlanListInitial():
return initial();case _BillPlanListLoading():
return loading();case _BillPlanListLoaded():
return loaded(_that.items);case _BillPlanListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<({BillPlan plan, Account category})> items)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _BillPlanListInitial() when initial != null:
return initial();case _BillPlanListLoading() when loading != null:
return loading();case _BillPlanListLoaded() when loaded != null:
return loaded(_that.items);case _BillPlanListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _BillPlanListInitial implements BillPlanListState {
  const _BillPlanListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillPlanListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BillPlanListState.initial()';
}


}




/// @nodoc


class _BillPlanListLoading implements BillPlanListState {
  const _BillPlanListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillPlanListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BillPlanListState.loading()';
}


}




/// @nodoc


class _BillPlanListLoaded implements BillPlanListState {
  const _BillPlanListLoaded({final  List<({BillPlan plan, Account category})> items = const []}): _items = items;
  

 final  List<({BillPlan plan, Account category})> _items;
@JsonKey() List<({BillPlan plan, Account category})> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of BillPlanListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillPlanListLoadedCopyWith<_BillPlanListLoaded> get copyWith => __$BillPlanListLoadedCopyWithImpl<_BillPlanListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillPlanListLoaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'BillPlanListState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class _$BillPlanListLoadedCopyWith<$Res> implements $BillPlanListStateCopyWith<$Res> {
  factory _$BillPlanListLoadedCopyWith(_BillPlanListLoaded value, $Res Function(_BillPlanListLoaded) _then) = __$BillPlanListLoadedCopyWithImpl;
@useResult
$Res call({
 List<({BillPlan plan, Account category})> items
});




}
/// @nodoc
class __$BillPlanListLoadedCopyWithImpl<$Res>
    implements _$BillPlanListLoadedCopyWith<$Res> {
  __$BillPlanListLoadedCopyWithImpl(this._self, this._then);

  final _BillPlanListLoaded _self;
  final $Res Function(_BillPlanListLoaded) _then;

/// Create a copy of BillPlanListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_BillPlanListLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<({BillPlan plan, Account category})>,
  ));
}


}

/// @nodoc


class _BillPlanListError implements BillPlanListState {
  const _BillPlanListError({required this.message});
  

 final  String message;

/// Create a copy of BillPlanListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillPlanListErrorCopyWith<_BillPlanListError> get copyWith => __$BillPlanListErrorCopyWithImpl<_BillPlanListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillPlanListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BillPlanListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$BillPlanListErrorCopyWith<$Res> implements $BillPlanListStateCopyWith<$Res> {
  factory _$BillPlanListErrorCopyWith(_BillPlanListError value, $Res Function(_BillPlanListError) _then) = __$BillPlanListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$BillPlanListErrorCopyWithImpl<$Res>
    implements _$BillPlanListErrorCopyWith<$Res> {
  __$BillPlanListErrorCopyWithImpl(this._self, this._then);

  final _BillPlanListError _self;
  final $Res Function(_BillPlanListError) _then;

/// Create a copy of BillPlanListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_BillPlanListError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
