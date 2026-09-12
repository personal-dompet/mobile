class Pagination {
  final int page;
  final int limit;

  const Pagination({this.page = 1, this.limit = 20});

  int get offset => (page - 1) * limit;
}
