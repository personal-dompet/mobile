// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalLine {

@JsonKey(name: JournalLineKey.id) int get id;@JsonKey(name: JournalLineKey.journalEntryId) int get journalEntryId;@JsonKey(name: JournalLineKey.accountId) int get accountId;@JsonKey(name: JournalLineKey.debitAmount) int get debitAmount;@JsonKey(name: JournalLineKey.creditAmount) int get creditAmount;@JsonKey(name: JournalLineKey.note) String? get note;@JsonKey(name: JournalLineKey.lineOrder) int get lineOrder;@JsonKey(name: JournalLineKey.accountName) String get accountName;@JsonKey(name: JournalLineKey.accountType) AccountTypeName get accountType;@JsonKey(name: JournalLineKey.accountBalance) int get balance;@JsonKey(name: JournalLineKey.accountNormalBalance) BalanceType get accountNormalBalance;
/// Create a copy of JournalLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalLineCopyWith<JournalLine> get copyWith => _$JournalLineCopyWithImpl<JournalLine>(this as JournalLine, _$identity);

  /// Serializes this JournalLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalLine&&(identical(other.id, id) || other.id == id)&&(identical(other.journalEntryId, journalEntryId) || other.journalEntryId == journalEntryId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.debitAmount, debitAmount) || other.debitAmount == debitAmount)&&(identical(other.creditAmount, creditAmount) || other.creditAmount == creditAmount)&&(identical(other.note, note) || other.note == note)&&(identical(other.lineOrder, lineOrder) || other.lineOrder == lineOrder)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.accountNormalBalance, accountNormalBalance) || other.accountNormalBalance == accountNormalBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,journalEntryId,accountId,debitAmount,creditAmount,note,lineOrder,accountName,accountType,balance,accountNormalBalance);

@override
String toString() {
  return 'JournalLine(id: $id, journalEntryId: $journalEntryId, accountId: $accountId, debitAmount: $debitAmount, creditAmount: $creditAmount, note: $note, lineOrder: $lineOrder, accountName: $accountName, accountType: $accountType, balance: $balance, accountNormalBalance: $accountNormalBalance)';
}


}

/// @nodoc
abstract mixin class $JournalLineCopyWith<$Res>  {
  factory $JournalLineCopyWith(JournalLine value, $Res Function(JournalLine) _then) = _$JournalLineCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: JournalLineKey.id) int id,@JsonKey(name: JournalLineKey.journalEntryId) int journalEntryId,@JsonKey(name: JournalLineKey.accountId) int accountId,@JsonKey(name: JournalLineKey.debitAmount) int debitAmount,@JsonKey(name: JournalLineKey.creditAmount) int creditAmount,@JsonKey(name: JournalLineKey.note) String? note,@JsonKey(name: JournalLineKey.lineOrder) int lineOrder,@JsonKey(name: JournalLineKey.accountName) String accountName,@JsonKey(name: JournalLineKey.accountType) AccountTypeName accountType,@JsonKey(name: JournalLineKey.accountBalance) int balance,@JsonKey(name: JournalLineKey.accountNormalBalance) BalanceType accountNormalBalance
});




}
/// @nodoc
class _$JournalLineCopyWithImpl<$Res>
    implements $JournalLineCopyWith<$Res> {
  _$JournalLineCopyWithImpl(this._self, this._then);

  final JournalLine _self;
  final $Res Function(JournalLine) _then;

/// Create a copy of JournalLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? journalEntryId = null,Object? accountId = null,Object? debitAmount = null,Object? creditAmount = null,Object? note = freezed,Object? lineOrder = null,Object? accountName = null,Object? accountType = null,Object? balance = null,Object? accountNormalBalance = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,journalEntryId: null == journalEntryId ? _self.journalEntryId : journalEntryId // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,debitAmount: null == debitAmount ? _self.debitAmount : debitAmount // ignore: cast_nullable_to_non_nullable
as int,creditAmount: null == creditAmount ? _self.creditAmount : creditAmount // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,lineOrder: null == lineOrder ? _self.lineOrder : lineOrder // ignore: cast_nullable_to_non_nullable
as int,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as AccountTypeName,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,accountNormalBalance: null == accountNormalBalance ? _self.accountNormalBalance : accountNormalBalance // ignore: cast_nullable_to_non_nullable
as BalanceType,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalLine].
extension JournalLinePatterns on JournalLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalLine value)  $default,){
final _that = this;
switch (_that) {
case _JournalLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalLine value)?  $default,){
final _that = this;
switch (_that) {
case _JournalLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: JournalLineKey.id)  int id, @JsonKey(name: JournalLineKey.journalEntryId)  int journalEntryId, @JsonKey(name: JournalLineKey.accountId)  int accountId, @JsonKey(name: JournalLineKey.debitAmount)  int debitAmount, @JsonKey(name: JournalLineKey.creditAmount)  int creditAmount, @JsonKey(name: JournalLineKey.note)  String? note, @JsonKey(name: JournalLineKey.lineOrder)  int lineOrder, @JsonKey(name: JournalLineKey.accountName)  String accountName, @JsonKey(name: JournalLineKey.accountType)  AccountTypeName accountType, @JsonKey(name: JournalLineKey.accountBalance)  int balance, @JsonKey(name: JournalLineKey.accountNormalBalance)  BalanceType accountNormalBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalLine() when $default != null:
return $default(_that.id,_that.journalEntryId,_that.accountId,_that.debitAmount,_that.creditAmount,_that.note,_that.lineOrder,_that.accountName,_that.accountType,_that.balance,_that.accountNormalBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: JournalLineKey.id)  int id, @JsonKey(name: JournalLineKey.journalEntryId)  int journalEntryId, @JsonKey(name: JournalLineKey.accountId)  int accountId, @JsonKey(name: JournalLineKey.debitAmount)  int debitAmount, @JsonKey(name: JournalLineKey.creditAmount)  int creditAmount, @JsonKey(name: JournalLineKey.note)  String? note, @JsonKey(name: JournalLineKey.lineOrder)  int lineOrder, @JsonKey(name: JournalLineKey.accountName)  String accountName, @JsonKey(name: JournalLineKey.accountType)  AccountTypeName accountType, @JsonKey(name: JournalLineKey.accountBalance)  int balance, @JsonKey(name: JournalLineKey.accountNormalBalance)  BalanceType accountNormalBalance)  $default,) {final _that = this;
switch (_that) {
case _JournalLine():
return $default(_that.id,_that.journalEntryId,_that.accountId,_that.debitAmount,_that.creditAmount,_that.note,_that.lineOrder,_that.accountName,_that.accountType,_that.balance,_that.accountNormalBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: JournalLineKey.id)  int id, @JsonKey(name: JournalLineKey.journalEntryId)  int journalEntryId, @JsonKey(name: JournalLineKey.accountId)  int accountId, @JsonKey(name: JournalLineKey.debitAmount)  int debitAmount, @JsonKey(name: JournalLineKey.creditAmount)  int creditAmount, @JsonKey(name: JournalLineKey.note)  String? note, @JsonKey(name: JournalLineKey.lineOrder)  int lineOrder, @JsonKey(name: JournalLineKey.accountName)  String accountName, @JsonKey(name: JournalLineKey.accountType)  AccountTypeName accountType, @JsonKey(name: JournalLineKey.accountBalance)  int balance, @JsonKey(name: JournalLineKey.accountNormalBalance)  BalanceType accountNormalBalance)?  $default,) {final _that = this;
switch (_that) {
case _JournalLine() when $default != null:
return $default(_that.id,_that.journalEntryId,_that.accountId,_that.debitAmount,_that.creditAmount,_that.note,_that.lineOrder,_that.accountName,_that.accountType,_that.balance,_that.accountNormalBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalLine extends JournalLine {
  const _JournalLine({@JsonKey(name: JournalLineKey.id) required this.id, @JsonKey(name: JournalLineKey.journalEntryId) required this.journalEntryId, @JsonKey(name: JournalLineKey.accountId) required this.accountId, @JsonKey(name: JournalLineKey.debitAmount) this.debitAmount = 0, @JsonKey(name: JournalLineKey.creditAmount) this.creditAmount = 0, @JsonKey(name: JournalLineKey.note) this.note, @JsonKey(name: JournalLineKey.lineOrder) this.lineOrder = 0, @JsonKey(name: JournalLineKey.accountName) required this.accountName, @JsonKey(name: JournalLineKey.accountType) required this.accountType, @JsonKey(name: JournalLineKey.accountBalance) this.balance = 0, @JsonKey(name: JournalLineKey.accountNormalBalance) required this.accountNormalBalance}): super._();
  factory _JournalLine.fromJson(Map<String, dynamic> json) => _$JournalLineFromJson(json);

@override@JsonKey(name: JournalLineKey.id) final  int id;
@override@JsonKey(name: JournalLineKey.journalEntryId) final  int journalEntryId;
@override@JsonKey(name: JournalLineKey.accountId) final  int accountId;
@override@JsonKey(name: JournalLineKey.debitAmount) final  int debitAmount;
@override@JsonKey(name: JournalLineKey.creditAmount) final  int creditAmount;
@override@JsonKey(name: JournalLineKey.note) final  String? note;
@override@JsonKey(name: JournalLineKey.lineOrder) final  int lineOrder;
@override@JsonKey(name: JournalLineKey.accountName) final  String accountName;
@override@JsonKey(name: JournalLineKey.accountType) final  AccountTypeName accountType;
@override@JsonKey(name: JournalLineKey.accountBalance) final  int balance;
@override@JsonKey(name: JournalLineKey.accountNormalBalance) final  BalanceType accountNormalBalance;

/// Create a copy of JournalLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalLineCopyWith<_JournalLine> get copyWith => __$JournalLineCopyWithImpl<_JournalLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalLine&&(identical(other.id, id) || other.id == id)&&(identical(other.journalEntryId, journalEntryId) || other.journalEntryId == journalEntryId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.debitAmount, debitAmount) || other.debitAmount == debitAmount)&&(identical(other.creditAmount, creditAmount) || other.creditAmount == creditAmount)&&(identical(other.note, note) || other.note == note)&&(identical(other.lineOrder, lineOrder) || other.lineOrder == lineOrder)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.accountNormalBalance, accountNormalBalance) || other.accountNormalBalance == accountNormalBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,journalEntryId,accountId,debitAmount,creditAmount,note,lineOrder,accountName,accountType,balance,accountNormalBalance);

@override
String toString() {
  return 'JournalLine(id: $id, journalEntryId: $journalEntryId, accountId: $accountId, debitAmount: $debitAmount, creditAmount: $creditAmount, note: $note, lineOrder: $lineOrder, accountName: $accountName, accountType: $accountType, balance: $balance, accountNormalBalance: $accountNormalBalance)';
}


}

/// @nodoc
abstract mixin class _$JournalLineCopyWith<$Res> implements $JournalLineCopyWith<$Res> {
  factory _$JournalLineCopyWith(_JournalLine value, $Res Function(_JournalLine) _then) = __$JournalLineCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: JournalLineKey.id) int id,@JsonKey(name: JournalLineKey.journalEntryId) int journalEntryId,@JsonKey(name: JournalLineKey.accountId) int accountId,@JsonKey(name: JournalLineKey.debitAmount) int debitAmount,@JsonKey(name: JournalLineKey.creditAmount) int creditAmount,@JsonKey(name: JournalLineKey.note) String? note,@JsonKey(name: JournalLineKey.lineOrder) int lineOrder,@JsonKey(name: JournalLineKey.accountName) String accountName,@JsonKey(name: JournalLineKey.accountType) AccountTypeName accountType,@JsonKey(name: JournalLineKey.accountBalance) int balance,@JsonKey(name: JournalLineKey.accountNormalBalance) BalanceType accountNormalBalance
});




}
/// @nodoc
class __$JournalLineCopyWithImpl<$Res>
    implements _$JournalLineCopyWith<$Res> {
  __$JournalLineCopyWithImpl(this._self, this._then);

  final _JournalLine _self;
  final $Res Function(_JournalLine) _then;

/// Create a copy of JournalLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? journalEntryId = null,Object? accountId = null,Object? debitAmount = null,Object? creditAmount = null,Object? note = freezed,Object? lineOrder = null,Object? accountName = null,Object? accountType = null,Object? balance = null,Object? accountNormalBalance = null,}) {
  return _then(_JournalLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,journalEntryId: null == journalEntryId ? _self.journalEntryId : journalEntryId // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,debitAmount: null == debitAmount ? _self.debitAmount : debitAmount // ignore: cast_nullable_to_non_nullable
as int,creditAmount: null == creditAmount ? _self.creditAmount : creditAmount // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,lineOrder: null == lineOrder ? _self.lineOrder : lineOrder // ignore: cast_nullable_to_non_nullable
as int,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as AccountTypeName,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,accountNormalBalance: null == accountNormalBalance ? _self.accountNormalBalance : accountNormalBalance // ignore: cast_nullable_to_non_nullable
as BalanceType,
  ));
}


}

// dart format on
