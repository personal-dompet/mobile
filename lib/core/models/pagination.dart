import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';

@freezed
abstract class Pagination with _$Pagination {
  const Pagination._();
  const factory Pagination({@Default(1) int page, @Default(20) int limit}) =
      _Pagination;

  int get offset => (page - 1) * limit;
}
