import 'package:dompet_app/core/models/pagination_meta.dart';

class PaginationResult<T> {
  final List<T> items;
  final PaginationMeta meta;

  const PaginationResult({this.items = const [], required this.meta});
}
