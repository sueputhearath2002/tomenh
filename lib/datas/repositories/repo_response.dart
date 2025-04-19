class RepoResponse<T> {
  T records;
  final String? msg;
  final int? lastPage;
  final int? currentPage;
  final int? totalProducts;
  final bool isError;

  RepoResponse({
    required this.records,
    this.msg = "",
    this.lastPage = 1,
    this.currentPage = 1,
    this.totalProducts = 0,
    this.isError = false,
  });
}
