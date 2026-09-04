// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_JournalEntry',
      json,
      ($checkedConvert) {
        final val = _JournalEntry(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          entryDate: $checkedConvert('entry_date', (v) => (v as num).toInt()),
          description: $checkedConvert('description', (v) => v as String?),
          reference: $checkedConvert('reference', (v) => v as String?),
          metadata: $checkedConvert('metadata', (v) => v as String?),
          source: $checkedConvert(
            'source',
            (v) => $enumDecode(_$JournalSourceEnumMap, v),
          ),
          status: $checkedConvert(
            'status',
            (v) => $enumDecode(_$JournalStatusEnumMap, v),
          ),
          sourceId: $checkedConvert('source_id', (v) => (v as num?)?.toInt()),
          lines: $checkedConvert(
            'lines',
            (v) =>
                (v as List<dynamic>?)
                    ?.map(
                      (e) => JournalLine.fromJson(e as Map<String, dynamic>),
                    )
                    .toList() ??
                const [],
          ),
        );
        return val;
      },
      fieldKeyMap: const {'entryDate': 'entry_date', 'sourceId': 'source_id'},
    );

Map<String, dynamic> _$JournalEntryToJson(_JournalEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entry_date': instance.entryDate,
      'description': ?instance.description,
      'reference': ?instance.reference,
      'metadata': ?instance.metadata,
      'source': _$JournalSourceEnumMap[instance.source]!,
      'status': _$JournalStatusEnumMap[instance.status]!,
      'source_id': ?instance.sourceId,
      'lines': instance.lines,
    };

const _$JournalSourceEnumMap = {
  JournalSource.setup: 'setup',
  JournalSource.transfer: 'transfer',
  JournalSource.transaction: 'transaction',
  JournalSource.billGenerated: 'bill_generated',
  JournalSource.billPayment: 'bill_payment',
  JournalSource.adjustment: 'adjustment',
  JournalSource.saving: 'saving',
};

const _$JournalStatusEnumMap = {
  JournalStatus.draft: 'draft',
  JournalStatus.posted: 'posted',
  JournalStatus.voided: 'voided',
};
