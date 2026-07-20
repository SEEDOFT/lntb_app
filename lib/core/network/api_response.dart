class ApiStatus {
  final int code;
  final bool success;
  final String message;
  final String? errorCode;

  ApiStatus({
    required this.code,
    required this.success,
    required this.message,
    this.errorCode,
  });

  factory ApiStatus.fromJson(Map<String, dynamic> json) {
    return ApiStatus(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      errorCode: json['error_code'] as String?,
    );
  }
}

class ApiResponse<T> {
  final ApiStatus status;
  final T data;
  final Map<String, dynamic>? meta;

  ApiResponse({required this.status, required this.data, this.meta});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic)? fromJsonT,
  ]) {
    final dynamic rawData = json['data'];
    final parsedData = fromJsonT != null ? fromJsonT(rawData) : rawData as T;

    return ApiResponse<T>(
      status: ApiStatus.fromJson(json['status'] as Map<String, dynamic>),
      data: parsedData,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}
