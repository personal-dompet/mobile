// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryState()';
}


}

/// @nodoc
class $CategoryStateCopyWith<$Res>  {
$CategoryStateCopyWith(CategoryState _, $Res Function(CategoryState) __);
}


/// Adds pattern-matching-related methods to [CategoryState].
extension CategoryStatePatterns on CategoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CategoryInitial value)?  initial,TResult Function( _CategoryLoading value)?  loading,TResult Function( _CategoryRefreshing value)?  refreshing,TResult Function( _CategoryLoaded value)?  loaded,TResult Function( _CategoryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryInitial() when initial != null:
return initial(_that);case _CategoryLoading() when loading != null:
return loading(_that);case _CategoryRefreshing() when refreshing != null:
return refreshing(_that);case _CategoryLoaded() when loaded != null:
return loaded(_that);case _CategoryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CategoryInitial value)  initial,required TResult Function( _CategoryLoading value)  loading,required TResult Function( _CategoryRefreshing value)  refreshing,required TResult Function( _CategoryLoaded value)  loaded,required TResult Function( _CategoryError value)  error,}){
final _that = this;
switch (_that) {
case _CategoryInitial():
return initial(_that);case _CategoryLoading():
return loading(_that);case _CategoryRefreshing():
return refreshing(_that);case _CategoryLoaded():
return loaded(_that);case _CategoryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CategoryInitial value)?  initial,TResult? Function( _CategoryLoading value)?  loading,TResult? Function( _CategoryRefreshing value)?  refreshing,TResult? Function( _CategoryLoaded value)?  loaded,TResult? Function( _CategoryError value)?  error,}){
final _that = this;
switch (_that) {
case _CategoryInitial() when initial != null:
return initial(_that);case _CategoryLoading() when loading != null:
return loading(_that);case _CategoryRefreshing() when refreshing != null:
return refreshing(_that);case _CategoryLoaded() when loaded != null:
return loaded(_that);case _CategoryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Account> categories)?  refreshing,TResult Function( List<Account> categories)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryInitial() when initial != null:
return initial();case _CategoryLoading() when loading != null:
return loading();case _CategoryRefreshing() when refreshing != null:
return refreshing(_that.categories);case _CategoryLoaded() when loaded != null:
return loaded(_that.categories);case _CategoryError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Account> categories)  refreshing,required TResult Function( List<Account> categories)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _CategoryInitial():
return initial();case _CategoryLoading():
return loading();case _CategoryRefreshing():
return refreshing(_that.categories);case _CategoryLoaded():
return loaded(_that.categories);case _CategoryError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Account> categories)?  refreshing,TResult? Function( List<Account> categories)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _CategoryInitial() when initial != null:
return initial();case _CategoryLoading() when loading != null:
return loading();case _CategoryRefreshing() when refreshing != null:
return refreshing(_that.categories);case _CategoryLoaded() when loaded != null:
return loaded(_that.categories);case _CategoryError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryInitial implements CategoryState {
  const _CategoryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryState.initial()';
}


}




/// @nodoc


class _CategoryLoading implements CategoryState {
  const _CategoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryState.loading()';
}


}




/// @nodoc


class _CategoryRefreshing implements CategoryState {
  const _CategoryRefreshing({final  List<Account> categories = const []}): _categories = categories;
  

 final  List<Account> _categories;
@JsonKey() List<Account> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryRefreshingCopyWith<_CategoryRefreshing> get copyWith => __$CategoryRefreshingCopyWithImpl<_CategoryRefreshing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryRefreshing&&const DeepCollectionEquality().equals(other._categories, _categories));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'CategoryState.refreshing(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$CategoryRefreshingCopyWith<$Res> implements $CategoryStateCopyWith<$Res> {
  factory _$CategoryRefreshingCopyWith(_CategoryRefreshing value, $Res Function(_CategoryRefreshing) _then) = __$CategoryRefreshingCopyWithImpl;
@useResult
$Res call({
 List<Account> categories
});




}
/// @nodoc
class __$CategoryRefreshingCopyWithImpl<$Res>
    implements _$CategoryRefreshingCopyWith<$Res> {
  __$CategoryRefreshingCopyWithImpl(this._self, this._then);

  final _CategoryRefreshing _self;
  final $Res Function(_CategoryRefreshing) _then;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_CategoryRefreshing(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Account>,
  ));
}


}

/// @nodoc


class _CategoryLoaded implements CategoryState {
  const _CategoryLoaded({final  List<Account> categories = const []}): _categories = categories;
  

 final  List<Account> _categories;
@JsonKey() List<Account> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryLoadedCopyWith<_CategoryLoaded> get copyWith => __$CategoryLoadedCopyWithImpl<_CategoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryLoaded&&const DeepCollectionEquality().equals(other._categories, _categories));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'CategoryState.loaded(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$CategoryLoadedCopyWith<$Res> implements $CategoryStateCopyWith<$Res> {
  factory _$CategoryLoadedCopyWith(_CategoryLoaded value, $Res Function(_CategoryLoaded) _then) = __$CategoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<Account> categories
});




}
/// @nodoc
class __$CategoryLoadedCopyWithImpl<$Res>
    implements _$CategoryLoadedCopyWith<$Res> {
  __$CategoryLoadedCopyWithImpl(this._self, this._then);

  final _CategoryLoaded _self;
  final $Res Function(_CategoryLoaded) _then;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_CategoryLoaded(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Account>,
  ));
}


}

/// @nodoc


class _CategoryError implements CategoryState {
  const _CategoryError({required this.message});
  

 final  String message;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryErrorCopyWith<_CategoryError> get copyWith => __$CategoryErrorCopyWithImpl<_CategoryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CategoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$CategoryErrorCopyWith<$Res> implements $CategoryStateCopyWith<$Res> {
  factory _$CategoryErrorCopyWith(_CategoryError value, $Res Function(_CategoryError) _then) = __$CategoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$CategoryErrorCopyWithImpl<$Res>
    implements _$CategoryErrorCopyWith<$Res> {
  __$CategoryErrorCopyWithImpl(this._self, this._then);

  final _CategoryError _self;
  final $Res Function(_CategoryError) _then;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_CategoryError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
