// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PaginationMeta', json, ($checkedConvert) {
      final val = _PaginationMeta(
        total: $checkedConvert('total', (v) => (v as num?)?.toInt() ?? 0),
        page: $checkedConvert('page', (v) => (v as num?)?.toInt() ?? 0),
        limit: $checkedConvert('limit', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$PaginationMetaToJson(_PaginationMeta instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };
