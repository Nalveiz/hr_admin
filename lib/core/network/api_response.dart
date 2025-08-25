/// Generic API Response wrapper
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final String? error;
  final int? statusCode;

  const ApiResponse({
    this.data,
    this.message,
    required this.success,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse<T>(
      data: data,
      message: message,
      success: true,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse<T>(error: error, success: false, statusCode: statusCode);
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJson,
  ) {
    try {
      return ApiResponse<T>(
        data: json['data'] != null && fromJson != null
            ? fromJson(json['data'])
            : json['data'],
        message: json['message'],
        success: json['success'] ?? true,
        error: json['error'],
        statusCode: json['statusCode'],
      );
    } catch (e) {
      return ApiResponse<T>.error('JSON parse error: $e');
    }
  }

  bool get isSuccess => success && error == null;
  bool get isFailure => !success || error != null;
}
