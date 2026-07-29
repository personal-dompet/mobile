// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalEntry {

@JsonKey(name: JournalEntryKey.id) int get id;@JsonKey(name: JournalEntryKey.entryDate) int get entryDate;@JsonKey(name: JournalEntryKey.description) String? get description;@JsonKey(name: JournalEntryKey.reference) String? get reference;@JsonKey(name: JournalEntryKey.metadata) String? get metadata;@JsonKey(name: JournalEntryKey.source) JournalSource get source;@JsonKey(name: JournalEntryKey.status) JournalStatus get status;@JsonKey(name: JournalEntryKey.sourceId) int? get sourceId;@JsonKey(name: JournalEntryKey.lines) List<JournalLine> get lines;
/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryCopyWith<JournalEntry> get copyWith => _$JournalEntryCopyWithImpl<JournalEntry>(this as JournalEntry, _$identity);

  /// Serializes this JournalEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&const DeepCollectionEquality().equals(other.lines, lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entryDate,description,reference,metadata,source,status,sourceId,const DeepCollectionEquality().hash(lines));

@override
String toString() {
  return 'JournalEntry(id: $id, entryDate: $entryDate, description: $description, reference: $reference, metadata: $metadata, source: $source, status: $status, sourceId: $sourceId, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $JournalEntryCopyWith<$Res>  {
  factory $JournalEntryCopyWith(JournalEntry value, $Res Function(JournalEntry) _then) = _$JournalEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: JournalEntryKey.id) int id,@JsonKey(name: JournalEntryKey.entryDate) int entryDate,@JsonKey(name: JournalEntryKey.description) String? description,@JsonKey(name: JournalEntryKey.reference) String? reference,@JsonKey(name: JournalEntryKey.metadata) String? metadata,@JsonKey(name: JournalEntryKey.source) JournalSource source,@JsonKey(name: JournalEntryKey.status) JournalStatus status,@JsonKey(name: JournalEntryKey.sourceId) int? sourceId,@JsonKey(name: JournalEntryKey.lines) List<JournalLine> lines
});




}
/// @nodoc
class _$JournalEntryCopyWithImpl<$Res>
    implements $JournalEntryCopyWith<$Res> {
  _$JournalEntryCopyWithImpl(this._self, this._then);

  final JournalEntry _self;
  final $Res Function(JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? entryDate = null,Object? description = freezed,Object? reference = freezed,Object? metadata = freezed,Object? source = null,Object? status = null,Object? sourceId = freezed,Object? lines = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as JournalSource,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JournalStatus,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntry].
extension JournalEntryPatterns on JournalEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntry value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntry value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: JournalEntryKey.id)  int id, @JsonKey(name: JournalEntryKey.entryDate)  int entryDate, @JsonKey(name: JournalEntryKey.description)  String? description, @JsonKey(name: JournalEntryKey.reference)  String? reference, @JsonKey(name: JournalEntryKey.metadata)  String? metadata, @JsonKey(name: JournalEntryKey.source)  JournalSource source, @JsonKey(name: JournalEntryKey.status)  JournalStatus status, @JsonKey(name: JournalEntryKey.sourceId)  int? sourceId, @JsonKey(name: JournalEntryKey.lines)  List<JournalLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
return $default(_that.id,_that.entryDate,_that.description,_that.reference,_that.metadata,_that.source,_that.status,_that.sourceId,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: JournalEntryKey.id)  int id, @JsonKey(name: JournalEntryKey.entryDate)  int entryDate, @JsonKey(name: JournalEntryKey.description)  String? description, @JsonKey(name: JournalEntryKey.reference)  String? reference, @JsonKey(name: JournalEntryKey.metadata)  String? metadata, @JsonKey(name: JournalEntryKey.source)  JournalSource source, @JsonKey(name: JournalEntryKey.status)  JournalStatus status, @JsonKey(name: JournalEntryKey.sourceId)  int? sourceId, @JsonKey(name: JournalEntryKey.lines)  List<JournalLine> lines)  $default,) {final _that = this;
switch (_that) {
case _JournalEntry():
return $default(_that.id,_that.entryDate,_that.description,_that.reference,_that.metadata,_that.source,_that.status,_that.sourceId,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: JournalEntryKey.id)  int id, @JsonKey(name: JournalEntryKey.entryDate)  int entryDate, @JsonKey(name: JournalEntryKey.description)  String? description, @JsonKey(name: JournalEntryKey.reference)  String? reference, @JsonKey(name: JournalEntryKey.metadata)  String? metadata, @JsonKey(name: JournalEntryKey.source)  JournalSource source, @JsonKey(name: JournalEntryKey.status)  JournalStatus status, @JsonKey(name: JournalEntryKey.sourceId)  int? sourceId, @JsonKey(name: JournalEntryKey.lines)  List<JournalLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
return $default(_that.id,_that.entryDate,_that.description,_that.reference,_that.metadata,_that.source,_that.status,_that.sourceId,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalEntry extends JournalEntry {
  const _JournalEntry({@JsonKey(name: JournalEntryKey.id) required this.id, @JsonKey(name: JournalEntryKey.entryDate) required this.entryDate, @JsonKey(name: JournalEntryKey.description) this.description, @JsonKey(name: JournalEntryKey.reference) this.reference, @JsonKey(name: JournalEntryKey.metadata) this.metadata, @JsonKey(name: JournalEntryKey.source) required this.source, @JsonKey(name: JournalEntryKey.status) required this.status, @JsonKey(name: JournalEntryKey.sourceId) this.sourceId, @JsonKey(name: JournalEntryKey.lines) final  List<JournalLine> lines = const []}): _lines = lines,super._();
  factory _JournalEntry.fromJson(Map<String, dynamic> json) => _$JournalEntryFromJson(json);

@override@JsonKey(name: JournalEntryKey.id) final  int id;
@override@JsonKey(name: JournalEntryKey.entryDate) final  int entryDate;
@override@JsonKey(name: JournalEntryKey.description) final  String? description;
@override@JsonKey(name: JournalEntryKey.reference) final  String? reference;
@override@JsonKey(name: JournalEntryKey.metadata) final  String? metadata;
@override@JsonKey(name: JournalEntryKey.source) final  JournalSource source;
@override@JsonKey(name: JournalEntryKey.status) final  JournalStatus status;
@override@JsonKey(name: JournalEntryKey.sourceId) final  int? sourceId;
 final  List<JournalLine> _lines;
@override@JsonKey(name: JournalEntryKey.lines) List<JournalLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryCopyWith<_JournalEntry> get copyWith => __$JournalEntryCopyWithImpl<_JournalEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&const DeepCollectionEquality().equals(other._lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entryDate,description,reference,metadata,source,status,sourceId,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'JournalEntry(id: $id, entryDate: $entryDate, description: $description, reference: $reference, metadata: $metadata, source: $source, status: $status, sourceId: $sourceId, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryCopyWith<$Res> implements $JournalEntryCopyWith<$Res> {
  factory _$JournalEntryCopyWith(_JournalEntry value, $Res Function(_JournalEntry) _then) = __$JournalEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: JournalEntryKey.id) int id,@JsonKey(name: JournalEntryKey.entryDate) int entryDate,@JsonKey(name: JournalEntryKey.description) String? description,@JsonKey(name: JournalEntryKey.reference) String? reference,@JsonKey(name: JournalEntryKey.metadata) String? metadata,@JsonKey(name: JournalEntryKey.source) JournalSource source,@JsonKey(name: JournalEntryKey.status) JournalStatus status,@JsonKey(name: JournalEntryKey.sourceId) int? sourceId,@JsonKey(name: JournalEntryKey.lines) List<JournalLine> lines
});




}
/// @nodoc
class __$JournalEntryCopyWithImpl<$Res>
    implements _$JournalEntryCopyWith<$Res> {
  __$JournalEntryCopyWithImpl(this._self, this._then);

  final _JournalEntry _self;
  final $Res Function(_JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? entryDate = null,Object? description = freezed,Object? reference = freezed,Object? metadata = freezed,Object? source = null,Object? status = null,Object? sourceId = freezed,Object? lines = null,}) {
  return _then(_JournalEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as JournalSource,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JournalStatus,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalLine>,
  ));
}


}

// dart format on
