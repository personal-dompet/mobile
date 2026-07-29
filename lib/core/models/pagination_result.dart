import 'package:dompet_app/core/models/pagination_meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_result.freezed.dart';

@freezed
abstract class PaginationResult<T> with _$PaginationResult<T> {
  factory PaginationResult({
    @Default([]) List<T> items,
    required PaginationMeta meta,
  }) = _PaginationResult<T>;
}
