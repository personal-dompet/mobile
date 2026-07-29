// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_setup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssetSetupState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetSetupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetSetupState()';
}


}

/// @nodoc
class $AssetSetupStateCopyWith<$Res>  {
$AssetSetupStateCopyWith(AssetSetupState _, $Res Function(AssetSetupState) __);
}


/// Adds pattern-matching-related methods to [AssetSetupState].
extension AssetSetupStatePatterns on AssetSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AssetSetupInitial value)?  initial,TResult Function( _AssetSetupLoading value)?  loading,TResult Function( _AssetSetupReady value)?  ready,TResult Function( _AssetSetupAwaitingSetup value)?  awaitingSetup,TResult Function( _AssetSetupSelectedPreset value)?  selectedPreset,TResult Function( _AssetSetupError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetSetupInitial() when initial != null:
return initial(_that);case _AssetSetupLoading() when loading != null:
return loading(_that);case _AssetSetupReady() when ready != null:
return ready(_that);case _AssetSetupAwaitingSetup() when awaitingSetup != null:
return awaitingSetup(_that);case _AssetSetupSelectedPreset() when selectedPreset != null:
return selectedPreset(_that);case _AssetSetupError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AssetSetupInitial value)  initial,required TResult Function( _AssetSetupLoading value)  loading,required TResult Function( _AssetSetupReady value)  ready,required TResult Function( _AssetSetupAwaitingSetup value)  awaitingSetup,required TResult Function( _AssetSetupSelectedPreset value)  selectedPreset,required TResult Function( _AssetSetupError value)  error,}){
final _that = this;
switch (_that) {
case _AssetSetupInitial():
return initial(_that);case _AssetSetupLoading():
return loading(_that);case _AssetSetupReady():
return ready(_that);case _AssetSetupAwaitingSetup():
return awaitingSetup(_that);case _AssetSetupSelectedPreset():
return selectedPreset(_that);case _AssetSetupError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AssetSetupInitial value)?  initial,TResult? Function( _AssetSetupLoading value)?  loading,TResult? Function( _AssetSetupReady value)?  ready,TResult? Function( _AssetSetupAwaitingSetup value)?  awaitingSetup,TResult? Function( _AssetSetupSelectedPreset value)?  selectedPreset,TResult? Function( _AssetSetupError value)?  error,}){
final _that = this;
switch (_that) {
case _AssetSetupInitial() when initial != null:
return initial(_that);case _AssetSetupLoading() when loading != null:
return loading(_that);case _AssetSetupReady() when ready != null:
return ready(_that);case _AssetSetupAwaitingSetup() when awaitingSetup != null:
return awaitingSetup(_that);case _AssetSetupSelectedPreset() when selectedPreset != null:
return selectedPreset(_that);case _AssetSetupError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Account> accounts,  List<Account> presetAccounts,  bool fromCreate)?  ready,TResult Function( List<Account> presetAccounts,  bool fromCreate)?  awaitingSetup,TResult Function( List<Account> accounts,  int selectedAccountId)?  selectedPreset,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetSetupInitial() when initial != null:
return initial();case _AssetSetupLoading() when loading != null:
return loading();case _AssetSetupReady() when ready != null:
return ready(_that.accounts,_that.presetAccounts,_that.fromCreate);case _AssetSetupAwaitingSetup() when awaitingSetup != null:
return awaitingSetup(_that.presetAccounts,_that.fromCreate);case _AssetSetupSelectedPreset() when selectedPreset != null:
return selectedPreset(_that.accounts,_that.selectedAccountId);case _AssetSetupError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Account> accounts,  List<Account> presetAccounts,  bool fromCreate)  ready,required TResult Function( List<Account> presetAccounts,  bool fromCreate)  awaitingSetup,required TResult Function( List<Account> accounts,  int selectedAccountId)  selectedPreset,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _AssetSetupInitial():
return initial();case _AssetSetupLoading():
return loading();case _AssetSetupReady():
return ready(_that.accounts,_that.presetAccounts,_that.fromCreate);case _AssetSetupAwaitingSetup():
return awaitingSetup(_that.presetAccounts,_that.fromCreate);case _AssetSetupSelectedPreset():
return selectedPreset(_that.accounts,_that.selectedAccountId);case _AssetSetupError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Account> accounts,  List<Account> presetAccounts,  bool fromCreate)?  ready,TResult? Function( List<Account> presetAccounts,  bool fromCreate)?  awaitingSetup,TResult? Function( List<Account> accounts,  int selectedAccountId)?  selectedPreset,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _AssetSetupInitial() when initial != null:
return initial();case _AssetSetupLoading() when loading != null:
return loading();case _AssetSetupReady() when ready != null:
return ready(_that.accounts,_that.presetAccounts,_that.fromCreate);case _AssetSetupAwaitingSetup() when awaitingSetup != null:
return awaitingSetup(_that.presetAccounts,_that.fromCreate);case _AssetSetupSelectedPreset() when selectedPreset != null:
return selectedPreset(_that.accounts,_that.selectedAccountId);case _AssetSetupError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _AssetSetupInitial implements AssetSetupState {
  const _AssetSetupInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetSetupInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetSetupState.initial()';
}


}




/// @nodoc


class _AssetSetupLoading implements AssetSetupState {
  const _AssetSetupLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetSetupLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetSetupState.loading()';
}


}




/// @nodoc


class _AssetSetupReady implements AssetSetupState {
  const _AssetSetupReady({required final  List<Account> accounts, required final  List<Account> presetAccounts, this.fromCreate = false}): _accounts = accounts,_presetAccounts = presetAccounts;
  

 final  List<Account> _accounts;
 List<Account> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

 final  List<Account> _presetAccounts;
 List<Account> get presetAccounts {
  if (_presetAccounts is EqualUnmodifiableListView) return _presetAccounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_presetAccounts);
}

@JsonKey() final  bool fromCreate;

/// Create a copy of AssetSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetSetupReadyCopyWith<_AssetSetupReady> get copyWith => __$AssetSetupReadyCopyWithImpl<_AssetSetupReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetSetupReady&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&const DeepCollectionEquality().equals(other._presetAccounts, _presetAccounts)&&(identical(other.fromCreate, fromCreate) || other.fromCreate == fromCreate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_accounts),const DeepCollectionEquality().hash(_presetAccounts),fromCreate);

@override
String toString() {
  return 'AssetSetupState.ready(accounts: $accounts, presetAccounts: $presetAccounts, fromCreate: $fromCreate)';
}


}

/// @nodoc
abstract mixin class _$AssetSetupReadyCopyWith<$Res> implements $AssetSetupStateCopyWith<$Res> {
  factory _$AssetSetupReadyCopyWith(_AssetSetupReady value, $Res Function(_AssetSetupReady) _then) = __$AssetSetupReadyCopyWithImpl;
@useResult
$Res call({
 List<Account> accounts, List<Account> presetAccounts, bool fromCreate
});




}
/// @nodoc
class __$AssetSetupReadyCopyWithImpl<$Res>
    implements _$AssetSetupReadyCopyWith<$Res> {
  __$AssetSetupReadyCopyWithImpl(this._self, this._then);

  final _AssetSetupReady _self;
  final $Res Function(_AssetSetupReady) _then;

/// Create a copy of AssetSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accounts = null,Object? presetAccounts = null,Object? fromCreate = null,}) {
  return _then(_AssetSetupReady(
accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,presetAccounts: null == presetAccounts ? _self._presetAccounts : presetAccounts // ignore: cast_nullable_to_non_nullable
as List<Account>,fromCreate: null == fromCreate ? _self.fromCreate : fromCreate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AssetSetupAwaitingSetup implements AssetSetupState {
  const _AssetSetupAwaitingSetup({required final  List<Account> presetAccounts, this.fromCreate = false}): _presetAccounts = presetAccounts;
  

 final  List<Account> _presetAccounts;
 List<Account> get presetAccounts {
  if (_presetAccounts is EqualUnmodifiableListView) return _presetAccounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_presetAccounts);
}

@JsonKey() final  bool fromCreate;

/// Create a copy of AssetSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetSetupAwaitingSetupCopyWith<_AssetSetupAwaitingSetup> get copyWith => __$AssetSetupAwaitingSetupCopyWithImpl<_AssetSetupAwaitingSetup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetSetupAwaitingSetup&&const DeepCollectionEquality().equals(other._presetAccounts, _presetAccounts)&&(identical(other.fromCreate, fromCreate) || other.fromCreate == fromCreate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_presetAccounts),fromCreate);

@override
String toString() {
  return 'AssetSetupState.awaitingSetup(presetAccounts: $presetAccounts, fromCreate: $fromCreate)';
}


}

/// @nodoc
abstract mixin class _$AssetSetupAwaitingSetupCopyWith<$Res> implements $AssetSetupStateCopyWith<$Res> {
  factory _$AssetSetupAwaitingSetupCopyWith(_AssetSetupAwaitingSetup value, $Res Function(_AssetSetupAwaitingSetup) _then) = __$AssetSetupAwaitingSetupCopyWithImpl;
@useResult
$Res call({
 List<Account> presetAccounts, bool fromCreate
});




}
/// @nodoc
class __$AssetSetupAwaitingSetupCopyWithImpl<$Res>
    implements _$AssetSetupAwaitingSetupCopyWith<$Res> {
  __$AssetSetupAwaitingSetupCopyWithImpl(this._self, this._then);

  final _AssetSetupAwaitingSetup _self;
  final $Res Function(_AssetSetupAwaitingSetup) _then;

/// Create a copy of AssetSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? presetAccounts = null,Object? fromCreate = null,}) {
  return _then(_AssetSetupAwaitingSetup(
presetAccounts: null == presetAccounts ? _self._presetAccounts : presetAccounts // ignore: cast_nullable_to_non_nullable
as List<Account>,fromCreate: null == fromCreate ? _self.fromCreate : fromCreate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AssetSetupSelectedPreset implements AssetSetupState {
  const _AssetSetupSelectedPreset({required final  List<Account> accounts, required this.selectedAccountId}): _accounts = accounts;
  

 final  List<Account> _accounts;
 List<Account> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

 final  int selectedAccountId;

/// Create a copy of AssetSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetSetupSelectedPresetCopyWith<_AssetSetupSelectedPreset> get copyWith => __$AssetSetupSelectedPresetCopyWithImpl<_AssetSetupSelectedPreset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetSetupSelectedPreset&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&(identical(other.selectedAccountId, selectedAccountId) || other.selectedAccountId == selectedAccountId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_accounts),selectedAccountId);

@override
String toString() {
  return 'AssetSetupState.selectedPreset(accounts: $accounts, selectedAccountId: $selectedAccountId)';
}


}

/// @nodoc
abstract mixin class _$AssetSetupSelectedPresetCopyWith<$Res> implements $AssetSetupStateCopyWith<$Res> {
  factory _$AssetSetupSelectedPresetCopyWith(_AssetSetupSelectedPreset value, $Res Function(_AssetSetupSelectedPreset) _then) = __$AssetSetupSelectedPresetCopyWithImpl;
@useResult
$Res call({
 List<Account> accounts, int selectedAccountId
});




}
/// @nodoc
class __$AssetSetupSelectedPresetCopyWithImpl<$Res>
    implements _$AssetSetupSelectedPresetCopyWith<$Res> {
  __$AssetSetupSelectedPresetCopyWithImpl(this._self, this._then);

  final _AssetSetupSelectedPreset _self;
  final $Res Function(_AssetSetupSelectedPreset) _then;

/// Create a copy of AssetSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accounts = null,Object? selectedAccountId = null,}) {
  return _then(_AssetSetupSelectedPreset(
accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,selectedAccountId: null == selectedAccountId ? _self.selectedAccountId : selectedAccountId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _AssetSetupError implements AssetSetupState {
  const _AssetSetupError({required this.message});
  

 final  String message;

/// Create a copy of AssetSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetSetupErrorCopyWith<_AssetSetupError> get copyWith => __$AssetSetupErrorCopyWithImpl<_AssetSetupError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetSetupError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AssetSetupState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AssetSetupErrorCopyWith<$Res> implements $AssetSetupStateCopyWith<$Res> {
  factory _$AssetSetupErrorCopyWith(_AssetSetupError value, $Res Function(_AssetSetupError) _then) = __$AssetSetupErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$AssetSetupErrorCopyWithImpl<$Res>
    implements _$AssetSetupErrorCopyWith<$Res> {
  __$AssetSetupErrorCopyWithImpl(this._self, this._then);

  final _AssetSetupError _self;
  final $Res Function(_AssetSetupError) _then;

/// Create a copy of AssetSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_AssetSetupError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
