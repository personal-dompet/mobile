// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {

 DashboardSectionStatus get balanceStatus; int get balance; String? get balanceError; DashboardSectionStatus get summaryStatus; TransactionSummary get summary; String? get summarayError; DashboardSectionStatus get recentActivitiesStatus; List<JournalEntry> get recentActivities; String? get recentActivitiesError; DashboardSectionStatus get presetAssetAccountsStatus; List<Account> get presetAssetAccounts; String? get presetAssetAccountsError;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&(identical(other.balanceStatus, balanceStatus) || other.balanceStatus == balanceStatus)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.balanceError, balanceError) || other.balanceError == balanceError)&&(identical(other.summaryStatus, summaryStatus) || other.summaryStatus == summaryStatus)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.summarayError, summarayError) || other.summarayError == summarayError)&&(identical(other.recentActivitiesStatus, recentActivitiesStatus) || other.recentActivitiesStatus == recentActivitiesStatus)&&const DeepCollectionEquality().equals(other.recentActivities, recentActivities)&&(identical(other.recentActivitiesError, recentActivitiesError) || other.recentActivitiesError == recentActivitiesError)&&(identical(other.presetAssetAccountsStatus, presetAssetAccountsStatus) || other.presetAssetAccountsStatus == presetAssetAccountsStatus)&&const DeepCollectionEquality().equals(other.presetAssetAccounts, presetAssetAccounts)&&(identical(other.presetAssetAccountsError, presetAssetAccountsError) || other.presetAssetAccountsError == presetAssetAccountsError));
}


@override
int get hashCode => Object.hash(runtimeType,balanceStatus,balance,balanceError,summaryStatus,summary,summarayError,recentActivitiesStatus,const DeepCollectionEquality().hash(recentActivities),recentActivitiesError,presetAssetAccountsStatus,const DeepCollectionEquality().hash(presetAssetAccounts),presetAssetAccountsError);

@override
String toString() {
  return 'DashboardState(balanceStatus: $balanceStatus, balance: $balance, balanceError: $balanceError, summaryStatus: $summaryStatus, summary: $summary, summarayError: $summarayError, recentActivitiesStatus: $recentActivitiesStatus, recentActivities: $recentActivities, recentActivitiesError: $recentActivitiesError, presetAssetAccountsStatus: $presetAssetAccountsStatus, presetAssetAccounts: $presetAssetAccounts, presetAssetAccountsError: $presetAssetAccountsError)';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 DashboardSectionStatus balanceStatus, int balance, String? balanceError, DashboardSectionStatus summaryStatus, TransactionSummary summary, String? summarayError, DashboardSectionStatus recentActivitiesStatus, List<JournalEntry> recentActivities, String? recentActivitiesError, DashboardSectionStatus presetAssetAccountsStatus, List<Account> presetAssetAccounts, String? presetAssetAccountsError
});


$TransactionSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balanceStatus = null,Object? balance = null,Object? balanceError = freezed,Object? summaryStatus = null,Object? summary = null,Object? summarayError = freezed,Object? recentActivitiesStatus = null,Object? recentActivities = null,Object? recentActivitiesError = freezed,Object? presetAssetAccountsStatus = null,Object? presetAssetAccounts = null,Object? presetAssetAccountsError = freezed,}) {
  return _then(_self.copyWith(
balanceStatus: null == balanceStatus ? _self.balanceStatus : balanceStatus // ignore: cast_nullable_to_non_nullable
as DashboardSectionStatus,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,balanceError: freezed == balanceError ? _self.balanceError : balanceError // ignore: cast_nullable_to_non_nullable
as String?,summaryStatus: null == summaryStatus ? _self.summaryStatus : summaryStatus // ignore: cast_nullable_to_non_nullable
as DashboardSectionStatus,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as TransactionSummary,summarayError: freezed == summarayError ? _self.summarayError : summarayError // ignore: cast_nullable_to_non_nullable
as String?,recentActivitiesStatus: null == recentActivitiesStatus ? _self.recentActivitiesStatus : recentActivitiesStatus // ignore: cast_nullable_to_non_nullable
as DashboardSectionStatus,recentActivities: null == recentActivities ? _self.recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<JournalEntry>,recentActivitiesError: freezed == recentActivitiesError ? _self.recentActivitiesError : recentActivitiesError // ignore: cast_nullable_to_non_nullable
as String?,presetAssetAccountsStatus: null == presetAssetAccountsStatus ? _self.presetAssetAccountsStatus : presetAssetAccountsStatus // ignore: cast_nullable_to_non_nullable
as DashboardSectionStatus,presetAssetAccounts: null == presetAssetAccounts ? _self.presetAssetAccounts : presetAssetAccounts // ignore: cast_nullable_to_non_nullable
as List<Account>,presetAssetAccountsError: freezed == presetAssetAccountsError ? _self.presetAssetAccountsError : presetAssetAccountsError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionSummaryCopyWith<$Res> get summary {
  
  return $TransactionSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardSectionStatus balanceStatus,  int balance,  String? balanceError,  DashboardSectionStatus summaryStatus,  TransactionSummary summary,  String? summarayError,  DashboardSectionStatus recentActivitiesStatus,  List<JournalEntry> recentActivities,  String? recentActivitiesError,  DashboardSectionStatus presetAssetAccountsStatus,  List<Account> presetAssetAccounts,  String? presetAssetAccountsError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.balanceStatus,_that.balance,_that.balanceError,_that.summaryStatus,_that.summary,_that.summarayError,_that.recentActivitiesStatus,_that.recentActivities,_that.recentActivitiesError,_that.presetAssetAccountsStatus,_that.presetAssetAccounts,_that.presetAssetAccountsError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardSectionStatus balanceStatus,  int balance,  String? balanceError,  DashboardSectionStatus summaryStatus,  TransactionSummary summary,  String? summarayError,  DashboardSectionStatus recentActivitiesStatus,  List<JournalEntry> recentActivities,  String? recentActivitiesError,  DashboardSectionStatus presetAssetAccountsStatus,  List<Account> presetAssetAccounts,  String? presetAssetAccountsError)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.balanceStatus,_that.balance,_that.balanceError,_that.summaryStatus,_that.summary,_that.summarayError,_that.recentActivitiesStatus,_that.recentActivities,_that.recentActivitiesError,_that.presetAssetAccountsStatus,_that.presetAssetAccounts,_that.presetAssetAccountsError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardSectionStatus balanceStatus,  int balance,  String? balanceError,  DashboardSectionStatus summaryStatus,  TransactionSummary summary,  String? summarayError,  DashboardSectionStatus recentActivitiesStatus,  List<JournalEntry> recentActivities,  String? recentActivitiesError,  DashboardSectionStatus presetAssetAccountsStatus,  List<Account> presetAssetAccounts,  String? presetAssetAccountsError)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.balanceStatus,_that.balance,_that.balanceError,_that.summaryStatus,_that.summary,_that.summarayError,_that.recentActivitiesStatus,_that.recentActivities,_that.recentActivitiesError,_that.presetAssetAccountsStatus,_that.presetAssetAccounts,_that.presetAssetAccountsError);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState implements DashboardState {
  const _DashboardState({this.balanceStatus = DashboardSectionStatus.initial, this.balance = 0, this.balanceError, this.summaryStatus = DashboardSectionStatus.initial, this.summary = const TransactionSummary(), this.summarayError, this.recentActivitiesStatus = DashboardSectionStatus.initial, final  List<JournalEntry> recentActivities = const [], this.recentActivitiesError, this.presetAssetAccountsStatus = DashboardSectionStatus.initial, final  List<Account> presetAssetAccounts = const [], this.presetAssetAccountsError}): _recentActivities = recentActivities,_presetAssetAccounts = presetAssetAccounts;
  

@override@JsonKey() final  DashboardSectionStatus balanceStatus;
@override@JsonKey() final  int balance;
@override final  String? balanceError;
@override@JsonKey() final  DashboardSectionStatus summaryStatus;
@override@JsonKey() final  TransactionSummary summary;
@override final  String? summarayError;
@override@JsonKey() final  DashboardSectionStatus recentActivitiesStatus;
 final  List<JournalEntry> _recentActivities;
@override@JsonKey() List<JournalEntry> get recentActivities {
  if (_recentActivities is EqualUnmodifiableListView) return _recentActivities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentActivities);
}

@override final  String? recentActivitiesError;
@override@JsonKey() final  DashboardSectionStatus presetAssetAccountsStatus;
 final  List<Account> _presetAssetAccounts;
@override@JsonKey() List<Account> get presetAssetAccounts {
  if (_presetAssetAccounts is EqualUnmodifiableListView) return _presetAssetAccounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_presetAssetAccounts);
}

@override final  String? presetAssetAccountsError;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&(identical(other.balanceStatus, balanceStatus) || other.balanceStatus == balanceStatus)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.balanceError, balanceError) || other.balanceError == balanceError)&&(identical(other.summaryStatus, summaryStatus) || other.summaryStatus == summaryStatus)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.summarayError, summarayError) || other.summarayError == summarayError)&&(identical(other.recentActivitiesStatus, recentActivitiesStatus) || other.recentActivitiesStatus == recentActivitiesStatus)&&const DeepCollectionEquality().equals(other._recentActivities, _recentActivities)&&(identical(other.recentActivitiesError, recentActivitiesError) || other.recentActivitiesError == recentActivitiesError)&&(identical(other.presetAssetAccountsStatus, presetAssetAccountsStatus) || other.presetAssetAccountsStatus == presetAssetAccountsStatus)&&const DeepCollectionEquality().equals(other._presetAssetAccounts, _presetAssetAccounts)&&(identical(other.presetAssetAccountsError, presetAssetAccountsError) || other.presetAssetAccountsError == presetAssetAccountsError));
}


@override
int get hashCode => Object.hash(runtimeType,balanceStatus,balance,balanceError,summaryStatus,summary,summarayError,recentActivitiesStatus,const DeepCollectionEquality().hash(_recentActivities),recentActivitiesError,presetAssetAccountsStatus,const DeepCollectionEquality().hash(_presetAssetAccounts),presetAssetAccountsError);

@override
String toString() {
  return 'DashboardState(balanceStatus: $balanceStatus, balance: $balance, balanceError: $balanceError, summaryStatus: $summaryStatus, summary: $summary, summarayError: $summarayError, recentActivitiesStatus: $recentActivitiesStatus, recentActivities: $recentActivities, recentActivitiesError: $recentActivitiesError, presetAssetAccountsStatus: $presetAssetAccountsStatus, presetAssetAccounts: $presetAssetAccounts, presetAssetAccountsError: $presetAssetAccountsError)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 DashboardSectionStatus balanceStatus, int balance, String? balanceError, DashboardSectionStatus summaryStatus, TransactionSummary summary, String? summarayError, DashboardSectionStatus recentActivitiesStatus, List<JournalEntry> recentActivities, String? recentActivitiesError, DashboardSectionStatus presetAssetAccountsStatus, List<Account> presetAssetAccounts, String? presetAssetAccountsError
});


@override $TransactionSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balanceStatus = null,Object? balance = null,Object? balanceError = freezed,Object? summaryStatus = null,Object? summary = null,Object? summarayError = freezed,Object? recentActivitiesStatus = null,Object? recentActivities = null,Object? recentActivitiesError = freezed,Object? presetAssetAccountsStatus = null,Object? presetAssetAccounts = null,Object? presetAssetAccountsError = freezed,}) {
  return _then(_DashboardState(
balanceStatus: null == balanceStatus ? _self.balanceStatus : balanceStatus // ignore: cast_nullable_to_non_nullable
as DashboardSectionStatus,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,balanceError: freezed == balanceError ? _self.balanceError : balanceError // ignore: cast_nullable_to_non_nullable
as String?,summaryStatus: null == summaryStatus ? _self.summaryStatus : summaryStatus // ignore: cast_nullable_to_non_nullable
as DashboardSectionStatus,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as TransactionSummary,summarayError: freezed == summarayError ? _self.summarayError : summarayError // ignore: cast_nullable_to_non_nullable
as String?,recentActivitiesStatus: null == recentActivitiesStatus ? _self.recentActivitiesStatus : recentActivitiesStatus // ignore: cast_nullable_to_non_nullable
as DashboardSectionStatus,recentActivities: null == recentActivities ? _self._recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<JournalEntry>,recentActivitiesError: freezed == recentActivitiesError ? _self.recentActivitiesError : recentActivitiesError // ignore: cast_nullable_to_non_nullable
as String?,presetAssetAccountsStatus: null == presetAssetAccountsStatus ? _self.presetAssetAccountsStatus : presetAssetAccountsStatus // ignore: cast_nullable_to_non_nullable
as DashboardSectionStatus,presetAssetAccounts: null == presetAssetAccounts ? _self._presetAssetAccounts : presetAssetAccounts // ignore: cast_nullable_to_non_nullable
as List<Account>,presetAssetAccountsError: freezed == presetAssetAccountsError ? _self.presetAssetAccountsError : presetAssetAccountsError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionSummaryCopyWith<$Res> get summary {
  
  return $TransactionSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
