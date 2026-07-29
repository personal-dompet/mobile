import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_meta.freezed.dart';
part 'pagination_meta.g.dart';

@freezed
abstract class PaginationMeta with _$PaginationMeta {
  const PaginationMeta._();
  const factory PaginationMeta({
    @Default(0) int total,
    @Default(0) int page,
    @Default(0) int limit,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  bool get hasMore => page * limit < total;
}
