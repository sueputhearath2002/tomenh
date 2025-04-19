class ApiResponse<T> {
  bool success;
  final String msg;
  final String token;
  T data;
  final Map? response;
  final int lastPage;
  final int currentPage;
  final Object? errors;

  ApiResponse({
    required this.success,
    this.msg = "",
    this.token = "",
    required this.data,
    this.lastPage = 1,
    this.currentPage = 1,
    this.errors,
    this.response,
  });
}
