// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Budget {

@JsonKey(name: BudgetKey.id) int get id;@JsonKey(name: BudgetKey.accountId) int get accountId;@JsonKey(name: BudgetKey.accountName) String get accountName;@JsonKey(name: BudgetKey.budgetedAmount) int get budgetAmount;@JsonKey(name: BudgetKey.periodStart) int get periodStart;@JsonKey(name: BudgetKey.periodEnd) int get periodEnd;@JsonKey(name: BudgetKey.actualSpend) int get actualSpend;@JsonKey(name: BudgetKey.categoryArchived) bool get categoryArchived;@JsonKey(name: BudgetKey.carryAmount) int get carryAmount;@JsonKey(name: BudgetKey.leftover) int get leftover;@JsonKey(name: BudgetKey.closedAt) int? get closedAt;
/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetCopyWith<Budget> get copyWith => _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);

  /// Serializes this Budget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Budget&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.actualSpend, actualSpend) || other.actualSpend == actualSpend)&&(identical(other.categoryArchived, categoryArchived) || other.categoryArchived == categoryArchived)&&(identical(other.carryAmount, carryAmount) || other.carryAmount == carryAmount)&&(identical(other.leftover, leftover) || other.leftover == leftover)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountName,budgetAmount,periodStart,periodEnd,actualSpend,categoryArchived,carryAmount,leftover,closedAt);

@override
String toString() {
  return 'Budget(id: $id, accountId: $accountId, accountName: $accountName, budgetAmount: $budgetAmount, periodStart: $periodStart, periodEnd: $periodEnd, actualSpend: $actualSpend, categoryArchived: $categoryArchived, carryAmount: $carryAmount, leftover: $leftover, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res>  {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) = _$BudgetCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: BudgetKey.id) int id,@JsonKey(name: BudgetKey.accountId) int accountId,@JsonKey(name: BudgetKey.accountName) String accountName,@JsonKey(name: BudgetKey.budgetedAmount) int budgetAmount,@JsonKey(name: BudgetKey.periodStart) int periodStart,@JsonKey(name: BudgetKey.periodEnd) int periodEnd,@JsonKey(name: BudgetKey.actualSpend) int actualSpend,@JsonKey(name: BudgetKey.categoryArchived) bool categoryArchived,@JsonKey(name: BudgetKey.carryAmount) int carryAmount,@JsonKey(name: BudgetKey.leftover) int leftover,@JsonKey(name: BudgetKey.closedAt) int? closedAt
});




}
/// @nodoc
class _$BudgetCopyWithImpl<$Res>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? accountName = null,Object? budgetAmount = null,Object? periodStart = null,Object? periodEnd = null,Object? actualSpend = null,Object? categoryArchived = null,Object? carryAmount = null,Object? leftover = null,Object? closedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,budgetAmount: null == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as int,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as int,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as int,actualSpend: null == actualSpend ? _self.actualSpend : actualSpend // ignore: cast_nullable_to_non_nullable
as int,categoryArchived: null == categoryArchived ? _self.categoryArchived : categoryArchived // ignore: cast_nullable_to_non_nullable
as bool,carryAmount: null == carryAmount ? _self.carryAmount : carryAmount // ignore: cast_nullable_to_non_nullable
as int,leftover: null == leftover ? _self.leftover : leftover // ignore: cast_nullable_to_non_nullable
as int,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Budget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Budget value)  $default,){
final _that = this;
switch (_that) {
case _Budget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Budget value)?  $default,){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: BudgetKey.id)  int id, @JsonKey(name: BudgetKey.accountId)  int accountId, @JsonKey(name: BudgetKey.accountName)  String accountName, @JsonKey(name: BudgetKey.budgetedAmount)  int budgetAmount, @JsonKey(name: BudgetKey.periodStart)  int periodStart, @JsonKey(name: BudgetKey.periodEnd)  int periodEnd, @JsonKey(name: BudgetKey.actualSpend)  int actualSpend, @JsonKey(name: BudgetKey.categoryArchived)  bool categoryArchived, @JsonKey(name: BudgetKey.carryAmount)  int carryAmount, @JsonKey(name: BudgetKey.leftover)  int leftover, @JsonKey(name: BudgetKey.closedAt)  int? closedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.accountId,_that.accountName,_that.budgetAmount,_that.periodStart,_that.periodEnd,_that.actualSpend,_that.categoryArchived,_that.carryAmount,_that.leftover,_that.closedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: BudgetKey.id)  int id, @JsonKey(name: BudgetKey.accountId)  int accountId, @JsonKey(name: BudgetKey.accountName)  String accountName, @JsonKey(name: BudgetKey.budgetedAmount)  int budgetAmount, @JsonKey(name: BudgetKey.periodStart)  int periodStart, @JsonKey(name: BudgetKey.periodEnd)  int periodEnd, @JsonKey(name: BudgetKey.actualSpend)  int actualSpend, @JsonKey(name: BudgetKey.categoryArchived)  bool categoryArchived, @JsonKey(name: BudgetKey.carryAmount)  int carryAmount, @JsonKey(name: BudgetKey.leftover)  int leftover, @JsonKey(name: BudgetKey.closedAt)  int? closedAt)  $default,) {final _that = this;
switch (_that) {
case _Budget():
return $default(_that.id,_that.accountId,_that.accountName,_that.budgetAmount,_that.periodStart,_that.periodEnd,_that.actualSpend,_that.categoryArchived,_that.carryAmount,_that.leftover,_that.closedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: BudgetKey.id)  int id, @JsonKey(name: BudgetKey.accountId)  int accountId, @JsonKey(name: BudgetKey.accountName)  String accountName, @JsonKey(name: BudgetKey.budgetedAmount)  int budgetAmount, @JsonKey(name: BudgetKey.periodStart)  int periodStart, @JsonKey(name: BudgetKey.periodEnd)  int periodEnd, @JsonKey(name: BudgetKey.actualSpend)  int actualSpend, @JsonKey(name: BudgetKey.categoryArchived)  bool categoryArchived, @JsonKey(name: BudgetKey.carryAmount)  int carryAmount, @JsonKey(name: BudgetKey.leftover)  int leftover, @JsonKey(name: BudgetKey.closedAt)  int? closedAt)?  $default,) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.accountId,_that.accountName,_that.budgetAmount,_that.periodStart,_that.periodEnd,_that.actualSpend,_that.categoryArchived,_that.carryAmount,_that.leftover,_that.closedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Budget extends Budget {
  const _Budget({@JsonKey(name: BudgetKey.id) required this.id, @JsonKey(name: BudgetKey.accountId) required this.accountId, @JsonKey(name: BudgetKey.accountName) required this.accountName, @JsonKey(name: BudgetKey.budgetedAmount) required this.budgetAmount, @JsonKey(name: BudgetKey.periodStart) required this.periodStart, @JsonKey(name: BudgetKey.periodEnd) required this.periodEnd, @JsonKey(name: BudgetKey.actualSpend) this.actualSpend = 0, @JsonKey(name: BudgetKey.categoryArchived) this.categoryArchived = false, @JsonKey(name: BudgetKey.carryAmount) this.carryAmount = 0, @JsonKey(name: BudgetKey.leftover) this.leftover = 0, @JsonKey(name: BudgetKey.closedAt) this.closedAt}): super._();
  factory _Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

@override@JsonKey(name: BudgetKey.id) final  int id;
@override@JsonKey(name: BudgetKey.accountId) final  int accountId;
@override@JsonKey(name: BudgetKey.accountName) final  String accountName;
@override@JsonKey(name: BudgetKey.budgetedAmount) final  int budgetAmount;
@override@JsonKey(name: BudgetKey.periodStart) final  int periodStart;
@override@JsonKey(name: BudgetKey.periodEnd) final  int periodEnd;
@override@JsonKey(name: BudgetKey.actualSpend) final  int actualSpend;
@override@JsonKey(name: BudgetKey.categoryArchived) final  bool categoryArchived;
@override@JsonKey(name: BudgetKey.carryAmount) final  int carryAmount;
@override@JsonKey(name: BudgetKey.leftover) final  int leftover;
@override@JsonKey(name: BudgetKey.closedAt) final  int? closedAt;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetCopyWith<_Budget> get copyWith => __$BudgetCopyWithImpl<_Budget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Budget&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.actualSpend, actualSpend) || other.actualSpend == actualSpend)&&(identical(other.categoryArchived, categoryArchived) || other.categoryArchived == categoryArchived)&&(identical(other.carryAmount, carryAmount) || other.carryAmount == carryAmount)&&(identical(other.leftover, leftover) || other.leftover == leftover)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountName,budgetAmount,periodStart,periodEnd,actualSpend,categoryArchived,carryAmount,leftover,closedAt);

@override
String toString() {
  return 'Budget(id: $id, accountId: $accountId, accountName: $accountName, budgetAmount: $budgetAmount, periodStart: $periodStart, periodEnd: $periodEnd, actualSpend: $actualSpend, categoryArchived: $categoryArchived, carryAmount: $carryAmount, leftover: $leftover, closedAt: $closedAt)';
}


}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) = __$BudgetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: BudgetKey.id) int id,@JsonKey(name: BudgetKey.accountId) int accountId,@JsonKey(name: BudgetKey.accountName) String accountName,@JsonKey(name: BudgetKey.budgetedAmount) int budgetAmount,@JsonKey(name: BudgetKey.periodStart) int periodStart,@JsonKey(name: BudgetKey.periodEnd) int periodEnd,@JsonKey(name: BudgetKey.actualSpend) int actualSpend,@JsonKey(name: BudgetKey.categoryArchived) bool categoryArchived,@JsonKey(name: BudgetKey.carryAmount) int carryAmount,@JsonKey(name: BudgetKey.leftover) int leftover,@JsonKey(name: BudgetKey.closedAt) int? closedAt
});




}
/// @nodoc
class __$BudgetCopyWithImpl<$Res>
    implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? accountName = null,Object? budgetAmount = null,Object? periodStart = null,Object? periodEnd = null,Object? actualSpend = null,Object? categoryArchived = null,Object? carryAmount = null,Object? leftover = null,Object? closedAt = freezed,}) {
  return _then(_Budget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,budgetAmount: null == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as int,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as int,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as int,actualSpend: null == actualSpend ? _self.actualSpend : actualSpend // ignore: cast_nullable_to_non_nullable
as int,categoryArchived: null == categoryArchived ? _self.categoryArchived : categoryArchived // ignore: cast_nullable_to_non_nullable
as bool,carryAmount: null == carryAmount ? _self.carryAmount : carryAmount // ignore: cast_nullable_to_non_nullable
as int,leftover: null == leftover ? _self.leftover : leftover // ignore: cast_nullable_to_non_nullable
as int,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
