// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionSummary {

 int get income; int get expense;
/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionSummaryCopyWith<TransactionSummary> get copyWith => _$TransactionSummaryCopyWithImpl<TransactionSummary>(this as TransactionSummary, _$identity);

  /// Serializes this TransactionSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionSummary&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,income,expense);

@override
String toString() {
  return 'TransactionSummary(income: $income, expense: $expense)';
}


}

/// @nodoc
abstract mixin class $TransactionSummaryCopyWith<$Res>  {
  factory $TransactionSummaryCopyWith(TransactionSummary value, $Res Function(TransactionSummary) _then) = _$TransactionSummaryCopyWithImpl;
@useResult
$Res call({
 int income, int expense
});




}
/// @nodoc
class _$TransactionSummaryCopyWithImpl<$Res>
    implements $TransactionSummaryCopyWith<$Res> {
  _$TransactionSummaryCopyWithImpl(this._self, this._then);

  final TransactionSummary _self;
  final $Res Function(TransactionSummary) _then;

/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? income = null,Object? expense = null,}) {
  return _then(_self.copyWith(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionSummary].
extension TransactionSummaryPatterns on TransactionSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionSummary value)  $default,){
final _that = this;
switch (_that) {
case _TransactionSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int income,  int expense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
return $default(_that.income,_that.expense);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int income,  int expense)  $default,) {final _that = this;
switch (_that) {
case _TransactionSummary():
return $default(_that.income,_that.expense);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int income,  int expense)?  $default,) {final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
return $default(_that.income,_that.expense);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionSummary implements TransactionSummary {
  const _TransactionSummary({this.income = 0, this.expense = 0});
  factory _TransactionSummary.fromJson(Map<String, dynamic> json) => _$TransactionSummaryFromJson(json);

@override@JsonKey() final  int income;
@override@JsonKey() final  int expense;

/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionSummaryCopyWith<_TransactionSummary> get copyWith => __$TransactionSummaryCopyWithImpl<_TransactionSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionSummary&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,income,expense);

@override
String toString() {
  return 'TransactionSummary(income: $income, expense: $expense)';
}


}

/// @nodoc
abstract mixin class _$TransactionSummaryCopyWith<$Res> implements $TransactionSummaryCopyWith<$Res> {
  factory _$TransactionSummaryCopyWith(_TransactionSummary value, $Res Function(_TransactionSummary) _then) = __$TransactionSummaryCopyWithImpl;
@override @useResult
$Res call({
 int income, int expense
});




}
/// @nodoc
class __$TransactionSummaryCopyWithImpl<$Res>
    implements _$TransactionSummaryCopyWith<$Res> {
  __$TransactionSummaryCopyWithImpl(this._self, this._then);

  final _TransactionSummary _self;
  final $Res Function(_TransactionSummary) _then;

/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? income = null,Object? expense = null,}) {
  return _then(_TransactionSummary(
income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
