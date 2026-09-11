// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BillState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BillState()';
}


}

/// @nodoc
class $BillStateCopyWith<$Res>  {
$BillStateCopyWith(BillState _, $Res Function(BillState) __);
}


/// Adds pattern-matching-related methods to [BillState].
extension BillStatePatterns on BillState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _BillInitial value)?  initial,TResult Function( _BillLoading value)?  loading,TResult Function( _BillLoaded value)?  loaded,TResult Function( _BillError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillInitial() when initial != null:
return initial(_that);case _BillLoading() when loading != null:
return loading(_that);case _BillLoaded() when loaded != null:
return loaded(_that);case _BillError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _BillInitial value)  initial,required TResult Function( _BillLoading value)  loading,required TResult Function( _BillLoaded value)  loaded,required TResult Function( _BillError value)  error,}){
final _that = this;
switch (_that) {
case _BillInitial():
return initial(_that);case _BillLoading():
return loading(_that);case _BillLoaded():
return loaded(_that);case _BillError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _BillInitial value)?  initial,TResult? Function( _BillLoading value)?  loading,TResult? Function( _BillLoaded value)?  loaded,TResult? Function( _BillError value)?  error,}){
final _that = this;
switch (_that) {
case _BillInitial() when initial != null:
return initial(_that);case _BillLoading() when loading != null:
return loading(_that);case _BillLoaded() when loaded != null:
return loaded(_that);case _BillError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Bill> attention,  List<Bill> upcoming,  List<Bill> recentPaid)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillInitial() when initial != null:
return initial();case _BillLoading() when loading != null:
return loading();case _BillLoaded() when loaded != null:
return loaded(_that.attention,_that.upcoming,_that.recentPaid);case _BillError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Bill> attention,  List<Bill> upcoming,  List<Bill> recentPaid)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _BillInitial():
return initial();case _BillLoading():
return loading();case _BillLoaded():
return loaded(_that.attention,_that.upcoming,_that.recentPaid);case _BillError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Bill> attention,  List<Bill> upcoming,  List<Bill> recentPaid)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _BillInitial() when initial != null:
return initial();case _BillLoading() when loading != null:
return loading();case _BillLoaded() when loaded != null:
return loaded(_that.attention,_that.upcoming,_that.recentPaid);case _BillError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _BillInitial implements BillState {
  const _BillInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BillState.initial()';
}


}




/// @nodoc


class _BillLoading implements BillState {
  const _BillLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BillState.loading()';
}


}




/// @nodoc


class _BillLoaded implements BillState {
  const _BillLoaded({final  List<Bill> attention = const [], final  List<Bill> upcoming = const [], final  List<Bill> recentPaid = const []}): _attention = attention,_upcoming = upcoming,_recentPaid = recentPaid;
  

 final  List<Bill> _attention;
@JsonKey() List<Bill> get attention {
  if (_attention is EqualUnmodifiableListView) return _attention;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attention);
}

 final  List<Bill> _upcoming;
@JsonKey() List<Bill> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

 final  List<Bill> _recentPaid;
@JsonKey() List<Bill> get recentPaid {
  if (_recentPaid is EqualUnmodifiableListView) return _recentPaid;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentPaid);
}


/// Create a copy of BillState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillLoadedCopyWith<_BillLoaded> get copyWith => __$BillLoadedCopyWithImpl<_BillLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillLoaded&&const DeepCollectionEquality().equals(other._attention, _attention)&&const DeepCollectionEquality().equals(other._upcoming, _upcoming)&&const DeepCollectionEquality().equals(other._recentPaid, _recentPaid));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_attention),const DeepCollectionEquality().hash(_upcoming),const DeepCollectionEquality().hash(_recentPaid));

@override
String toString() {
  return 'BillState.loaded(attention: $attention, upcoming: $upcoming, recentPaid: $recentPaid)';
}


}

/// @nodoc
abstract mixin class _$BillLoadedCopyWith<$Res> implements $BillStateCopyWith<$Res> {
  factory _$BillLoadedCopyWith(_BillLoaded value, $Res Function(_BillLoaded) _then) = __$BillLoadedCopyWithImpl;
@useResult
$Res call({
 List<Bill> attention, List<Bill> upcoming, List<Bill> recentPaid
});




}
/// @nodoc
class __$BillLoadedCopyWithImpl<$Res>
    implements _$BillLoadedCopyWith<$Res> {
  __$BillLoadedCopyWithImpl(this._self, this._then);

  final _BillLoaded _self;
  final $Res Function(_BillLoaded) _then;

/// Create a copy of BillState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? attention = null,Object? upcoming = null,Object? recentPaid = null,}) {
  return _then(_BillLoaded(
attention: null == attention ? _self._attention : attention // ignore: cast_nullable_to_non_nullable
as List<Bill>,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<Bill>,recentPaid: null == recentPaid ? _self._recentPaid : recentPaid // ignore: cast_nullable_to_non_nullable
as List<Bill>,
  ));
}


}

/// @nodoc


class _BillError implements BillState {
  const _BillError({required this.message});
  

 final  String message;

/// Create a copy of BillState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillErrorCopyWith<_BillError> get copyWith => __$BillErrorCopyWithImpl<_BillError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BillState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$BillErrorCopyWith<$Res> implements $BillStateCopyWith<$Res> {
  factory _$BillErrorCopyWith(_BillError value, $Res Function(_BillError) _then) = __$BillErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$BillErrorCopyWithImpl<$Res>
    implements _$BillErrorCopyWith<$Res> {
  __$BillErrorCopyWithImpl(this._self, this._then);

  final _BillError _self;
  final $Res Function(_BillError) _then;

/// Create a copy of BillState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_BillError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
