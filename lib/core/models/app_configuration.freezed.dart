// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfiguration {

 AppHint get hint; AppThemeMode get themeMode;
/// Create a copy of AppConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigurationCopyWith<AppConfiguration> get copyWith => _$AppConfigurationCopyWithImpl<AppConfiguration>(this as AppConfiguration, _$identity);

  /// Serializes this AppConfiguration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfiguration&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hint,themeMode);

@override
String toString() {
  return 'AppConfiguration(hint: $hint, themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class $AppConfigurationCopyWith<$Res>  {
  factory $AppConfigurationCopyWith(AppConfiguration value, $Res Function(AppConfiguration) _then) = _$AppConfigurationCopyWithImpl;
@useResult
$Res call({
 AppHint hint, AppThemeMode themeMode
});


$AppHintCopyWith<$Res> get hint;

}
/// @nodoc
class _$AppConfigurationCopyWithImpl<$Res>
    implements $AppConfigurationCopyWith<$Res> {
  _$AppConfigurationCopyWithImpl(this._self, this._then);

  final AppConfiguration _self;
  final $Res Function(AppConfiguration) _then;

/// Create a copy of AppConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hint = null,Object? themeMode = null,}) {
  return _then(_self.copyWith(
hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as AppHint,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,
  ));
}
/// Create a copy of AppConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppHintCopyWith<$Res> get hint {
  
  return $AppHintCopyWith<$Res>(_self.hint, (value) {
    return _then(_self.copyWith(hint: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppConfiguration].
extension AppConfigurationPatterns on AppConfiguration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfiguration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfiguration() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfiguration value)  $default,){
final _that = this;
switch (_that) {
case _AppConfiguration():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfiguration value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfiguration() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppHint hint,  AppThemeMode themeMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfiguration() when $default != null:
return $default(_that.hint,_that.themeMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppHint hint,  AppThemeMode themeMode)  $default,) {final _that = this;
switch (_that) {
case _AppConfiguration():
return $default(_that.hint,_that.themeMode);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppHint hint,  AppThemeMode themeMode)?  $default,) {final _that = this;
switch (_that) {
case _AppConfiguration() when $default != null:
return $default(_that.hint,_that.themeMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppConfiguration implements AppConfiguration {
   _AppConfiguration({required this.hint, this.themeMode = AppThemeMode.system});
  factory _AppConfiguration.fromJson(Map<String, dynamic> json) => _$AppConfigurationFromJson(json);

@override final  AppHint hint;
@override@JsonKey() final  AppThemeMode themeMode;

/// Create a copy of AppConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigurationCopyWith<_AppConfiguration> get copyWith => __$AppConfigurationCopyWithImpl<_AppConfiguration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfiguration&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hint,themeMode);

@override
String toString() {
  return 'AppConfiguration(hint: $hint, themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class _$AppConfigurationCopyWith<$Res> implements $AppConfigurationCopyWith<$Res> {
  factory _$AppConfigurationCopyWith(_AppConfiguration value, $Res Function(_AppConfiguration) _then) = __$AppConfigurationCopyWithImpl;
@override @useResult
$Res call({
 AppHint hint, AppThemeMode themeMode
});


@override $AppHintCopyWith<$Res> get hint;

}
/// @nodoc
class __$AppConfigurationCopyWithImpl<$Res>
    implements _$AppConfigurationCopyWith<$Res> {
  __$AppConfigurationCopyWithImpl(this._self, this._then);

  final _AppConfiguration _self;
  final $Res Function(_AppConfiguration) _then;

/// Create a copy of AppConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hint = null,Object? themeMode = null,}) {
  return _then(_AppConfiguration(
hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as AppHint,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,
  ));
}

/// Create a copy of AppConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppHintCopyWith<$Res> get hint {
  
  return $AppHintCopyWith<$Res>(_self.hint, (value) {
    return _then(_self.copyWith(hint: value));
  });
}
}


/// @nodoc
mixin _$AppHint {

@JsonKey(name: 'category_swipe') bool get categorySwipeHint;
/// Create a copy of AppHint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppHintCopyWith<AppHint> get copyWith => _$AppHintCopyWithImpl<AppHint>(this as AppHint, _$identity);

  /// Serializes this AppHint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppHint&&(identical(other.categorySwipeHint, categorySwipeHint) || other.categorySwipeHint == categorySwipeHint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categorySwipeHint);

@override
String toString() {
  return 'AppHint(categorySwipeHint: $categorySwipeHint)';
}


}

/// @nodoc
abstract mixin class $AppHintCopyWith<$Res>  {
  factory $AppHintCopyWith(AppHint value, $Res Function(AppHint) _then) = _$AppHintCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_swipe') bool categorySwipeHint
});




}
/// @nodoc
class _$AppHintCopyWithImpl<$Res>
    implements $AppHintCopyWith<$Res> {
  _$AppHintCopyWithImpl(this._self, this._then);

  final AppHint _self;
  final $Res Function(AppHint) _then;

/// Create a copy of AppHint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categorySwipeHint = null,}) {
  return _then(_self.copyWith(
categorySwipeHint: null == categorySwipeHint ? _self.categorySwipeHint : categorySwipeHint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppHint].
extension AppHintPatterns on AppHint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppHint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppHint() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppHint value)  $default,){
final _that = this;
switch (_that) {
case _AppHint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppHint value)?  $default,){
final _that = this;
switch (_that) {
case _AppHint() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_swipe')  bool categorySwipeHint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppHint() when $default != null:
return $default(_that.categorySwipeHint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_swipe')  bool categorySwipeHint)  $default,) {final _that = this;
switch (_that) {
case _AppHint():
return $default(_that.categorySwipeHint);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_swipe')  bool categorySwipeHint)?  $default,) {final _that = this;
switch (_that) {
case _AppHint() when $default != null:
return $default(_that.categorySwipeHint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppHint implements AppHint {
   _AppHint({@JsonKey(name: 'category_swipe') this.categorySwipeHint = false});
  factory _AppHint.fromJson(Map<String, dynamic> json) => _$AppHintFromJson(json);

@override@JsonKey(name: 'category_swipe') final  bool categorySwipeHint;

/// Create a copy of AppHint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppHintCopyWith<_AppHint> get copyWith => __$AppHintCopyWithImpl<_AppHint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppHintToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppHint&&(identical(other.categorySwipeHint, categorySwipeHint) || other.categorySwipeHint == categorySwipeHint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categorySwipeHint);

@override
String toString() {
  return 'AppHint(categorySwipeHint: $categorySwipeHint)';
}


}

/// @nodoc
abstract mixin class _$AppHintCopyWith<$Res> implements $AppHintCopyWith<$Res> {
  factory _$AppHintCopyWith(_AppHint value, $Res Function(_AppHint) _then) = __$AppHintCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_swipe') bool categorySwipeHint
});




}
/// @nodoc
class __$AppHintCopyWithImpl<$Res>
    implements _$AppHintCopyWith<$Res> {
  __$AppHintCopyWithImpl(this._self, this._then);

  final _AppHint _self;
  final $Res Function(_AppHint) _then;

/// Create a copy of AppHint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categorySwipeHint = null,}) {
  return _then(_AppHint(
categorySwipeHint: null == categorySwipeHint ? _self.categorySwipeHint : categorySwipeHint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
