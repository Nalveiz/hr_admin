import 'package:dio/dio.dart';
import 'dart:developer' as developer;

/// HTTP interceptor for logging requests and responses
class LoggingInterceptor extends Interceptor {
  final bool logRequests;
  final bool logResponses;
  final bool logErrors;

  LoggingInterceptor({
    this.logRequests = true,
    this.logResponses = true,
    this.logErrors = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequests) {
      developer.log(
        '🔵 REQUEST ${options.method} ${options.uri}',
        name: 'HTTP',
      );
      developer.log('Headers: ${options.headers}', name: 'HTTP');
      if (options.data != null) {
        developer.log('Body: ${options.data}', name: 'HTTP');
      }
      if (options.queryParameters.isNotEmpty) {
        developer.log(
          'Query Parameters: ${options.queryParameters}',
          name: 'HTTP',
        );
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponses) {
      developer.log(
        '🟢 RESPONSE ${response.statusCode} ${response.requestOptions.uri}',
        name: 'HTTP',
      );
      developer.log('Headers: ${response.headers}', name: 'HTTP');
      developer.log('Body: ${response.data}', name: 'HTTP');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logErrors) {
      developer.log(
        '🔴 ERROR ${err.response?.statusCode} ${err.requestOptions.uri}',
        name: 'HTTP',
      );
      developer.log('Message: ${err.message}', name: 'HTTP');
      developer.log('Type: ${err.type}', name: 'HTTP');
      if (err.response?.data != null) {
        developer.log('Response Body: ${err.response?.data}', name: 'HTTP');
      }
    }
    super.onError(err, handler);
  }
}
