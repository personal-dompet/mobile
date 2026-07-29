// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_adjustment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BalanceAdjustment {

@JsonKey(name: 'previous_balance') int get previousBalance;@JsonKey(name: 'current_balance') int get currentBalance;
/// Create a copy of BalanceAdjustment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BalanceAdjustmentCopyWith<BalanceAdjustment> get copyWith => _$BalanceAdjustmentCopyWithImpl<BalanceAdjustment>(this as BalanceAdjustment, _$identity);

  /// Serializes this BalanceAdjustment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BalanceAdjustment&&(identical(other.previousBalance, previousBalance) || other.previousBalance == previousBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,previousBalance,currentBalance);

@override
String toString() {
  return 'BalanceAdjustment(previousBalance: $previousBalance, currentBalance: $currentBalance)';
}


}

/// @nodoc
abstract mixin class $BalanceAdjustmentCopyWith<$Res>  {
  factory $BalanceAdjustmentCopyWith(BalanceAdjustment value, $Res Function(BalanceAdjustment) _then) = _$BalanceAdjustmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'previous_balance') int previousBalance,@JsonKey(name: 'current_balance') int currentBalance
});




}
/// @nodoc
class _$BalanceAdjustmentCopyWithImpl<$Res>
    implements $BalanceAdjustmentCopyWith<$Res> {
  _$BalanceAdjustmentCopyWithImpl(this._self, this._then);

  final BalanceAdjustment _self;
  final $Res Function(BalanceAdjustment) _then;

/// Create a copy of BalanceAdjustment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? previousBalance = null,Object? currentBalance = null,}) {
  return _then(_self.copyWith(
previousBalance: null == previousBalance ? _self.previousBalance : previousBalance // ignore: cast_nullable_to_non_nullable
as int,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BalanceAdjustment].
extension BalanceAdjustmentPatterns on BalanceAdjustment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BalanceAdjustment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BalanceAdjustment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BalanceAdjustment value)  $default,){
final _that = this;
switch (_that) {
case _BalanceAdjustment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BalanceAdjustment value)?  $default,){
final _that = this;
switch (_that) {
case _BalanceAdjustment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'previous_balance')  int previousBalance, @JsonKey(name: 'current_balance')  int currentBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BalanceAdjustment() when $default != null:
return $default(_that.previousBalance,_that.currentBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'previous_balance')  int previousBalance, @JsonKey(name: 'current_balance')  int currentBalance)  $default,) {final _that = this;
switch (_that) {
case _BalanceAdjustment():
return $default(_that.previousBalance,_that.currentBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'previous_balance')  int previousBalance, @JsonKey(name: 'current_balance')  int currentBalance)?  $default,) {final _that = this;
switch (_that) {
case _BalanceAdjustment() when $default != null:
return $default(_that.previousBalance,_that.currentBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BalanceAdjustment extends BalanceAdjustment {
  const _BalanceAdjustment({@JsonKey(name: 'previous_balance') this.previousBalance = 0, @JsonKey(name: 'current_balance') this.currentBalance = 0}): super._();
  factory _BalanceAdjustment.fromJson(Map<String, dynamic> json) => _$BalanceAdjustmentFromJson(json);

@override@JsonKey(name: 'previous_balance') final  int previousBalance;
@override@JsonKey(name: 'current_balance') final  int currentBalance;

/// Create a copy of BalanceAdjustment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BalanceAdjustmentCopyWith<_BalanceAdjustment> get copyWith => __$BalanceAdjustmentCopyWithImpl<_BalanceAdjustment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BalanceAdjustmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalanceAdjustment&&(identical(other.previousBalance, previousBalance) || other.previousBalance == previousBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,previousBalance,currentBalance);

@override
String toString() {
  return 'BalanceAdjustment(previousBalance: $previousBalance, currentBalance: $currentBalance)';
}


}

/// @nodoc
abstract mixin class _$BalanceAdjustmentCopyWith<$Res> implements $BalanceAdjustmentCopyWith<$Res> {
  factory _$BalanceAdjustmentCopyWith(_BalanceAdjustment value, $Res Function(_BalanceAdjustment) _then) = __$BalanceAdjustmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'previous_balance') int previousBalance,@JsonKey(name: 'current_balance') int currentBalance
});




}
/// @nodoc
class __$BalanceAdjustmentCopyWithImpl<$Res>
    implements _$BalanceAdjustmentCopyWith<$Res> {
  __$BalanceAdjustmentCopyWithImpl(this._self, this._then);

  final _BalanceAdjustment _self;
  final $Res Function(_BalanceAdjustment) _then;

/// Create a copy of BalanceAdjustment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? previousBalance = null,Object? currentBalance = null,}) {
  return _then(_BalanceAdjustment(
previousBalance: null == previousBalance ? _self.previousBalance : previousBalance // ignore: cast_nullable_to_non_nullable
as int,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
