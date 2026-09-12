class PaginationMeta {
  final int total;
  final int page;
  final int limit;

  const PaginationMeta({this.total = 0, this.page = 0, this.limit = 0});

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  bool get hasMore => page * limit < total;
}
