import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

/// Uygulamanın tüm network ve sistem hatalarını kullanıcı dostu mesajlara çeviren servis
abstract class ErrorHandlingService {
  String getHumanReadableErrorMessage(dynamic error);
  String getNetworkErrorMessage(DioException error);
  String getHttpErrorMessage(int statusCode);
  bool isNetworkError(dynamic error);
}

class ErrorHandlingServiceImpl implements ErrorHandlingService {
  const ErrorHandlingServiceImpl();

  @override
  String getHumanReadableErrorMessage(dynamic error) {
    // DioException handling
    if (error is DioException) {
      return getNetworkErrorMessage(error);
    }

    // SocketException (no internet)
    if (error is SocketException) {
      return 'İnternet bağlantısı bulunamadı. Bağlantınızı kontrol edin.';
    }

    // HttpException
    if (error is HttpException) {
      return 'Sunucu isteği başarısız oldu. Lütfen tekrar deneyin.';
    }

    // FormatException (JSON parse error)
    if (error is FormatException) {
      return 'Veri formatı hatası oluştu. Sistem yöneticisine başvurun.';
    }

    // TimeoutException
    if (error.runtimeType.toString().contains('TimeoutException')) {
      return 'Bağlantı zaman aşımına uğradı. Tekrar deneyin.';
    }

    // String error mesajları
    if (error is String) {
      return _parseStringError(error);
    }

    // Exception'ların toString() mesajları
    if (error is Exception) {
      return _parseStringError(error.toString());
    }

    // Generic fallback
    return 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
  }

  @override
  String getNetworkErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Bağlantı zaman aşımına uğradı. İnternet bağlantınızı kontrol edin.';

      case DioExceptionType.sendTimeout:
        return 'Veri gönderimi zaman aşımına uğradı. Tekrar deneyin.';

      case DioExceptionType.receiveTimeout:
        return 'Sunucudan yanıt alınamadı. Tekrar deneyin.';

      case DioExceptionType.badResponse:
        if (error.response?.statusCode != null) {
          // Backend'den gelen hata mesajını kontrol et
          final backendMessage = _extractBackendErrorMessage(
            error.response?.data,
          );
          if (backendMessage != null) {
            return backendMessage;
          }
          return getHttpErrorMessage(error.response!.statusCode!);
        }
        return 'Sunucudan geçersiz yanıt alındı.';

      case DioExceptionType.cancel:
        return 'İstek iptal edildi.';

      case DioExceptionType.connectionError:
        return 'Sunucuya bağlanılamıyor. İnternet bağlantınızı kontrol edin.';

      case DioExceptionType.badCertificate:
        return 'Güvenlik sertifikası hatası. Sistem yöneticisine başvurun.';

      case DioExceptionType.unknown:
        return _parseStringError(error.message ?? 'Bilinmeyen ağ hatası');
    }
  }

  @override
  String getHttpErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Geçersiz istek. Girdiğiniz bilgileri kontrol edin.';
      case 401:
        return 'Kullanıcı adı veya şifre hatalı.';
      case 403:
        return 'Bu işlem için yetkiniz bulunmuyor.';
      case 404:
        return 'İstenen kaynak bulunamadı.';
      case 408:
        return 'İstek zaman aşımına uğradı. Tekrar deneyin.';
      case 409:
        return 'Çakışan veri hatası. Verilerinizi kontrol edin.';
      case 422:
        return 'Girilen veriler geçersiz. Kontrol edip tekrar deneyin.';
      case 429:
        return 'Çok fazla istek gönderildi. Lütfen bekleyin.';
      case 500:
        return 'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.';
      case 502:
        return 'Sunucu geçici olarak erişilemiyor.';
      case 503:
        return 'Servis şu anda kullanılamıyor. Lütfen daha sonra tekrar deneyin.';
      case 504:
        return 'Sunucu yanıt vermiyor. Lütfen daha sonra tekrar deneyin.';
      default:
        if (statusCode >= 500) {
          return 'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.';
        } else if (statusCode >= 400) {
          return 'İstek hatası oluştu. Bilgilerinizi kontrol edin.';
        }
        return 'HTTP hatası oluştu (Kod: $statusCode).';
    }
  }

  @override
  bool isNetworkError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout;
    }

    if (error is SocketException) {
      return true;
    }

    if (error is String) {
      final errorLower = error.toLowerCase();
      return errorLower.contains('network') ||
          errorLower.contains('connection') ||
          errorLower.contains('internet') ||
          errorLower.contains('timeout');
    }

    return false;
  }

  /// String hata mesajlarını parse eder
  String _parseStringError(String error) {
    final errorLower = error.toLowerCase();

    // XMLHttpRequest hataları (web)
    if (errorLower.contains('xmlhttprequest') ||
        errorLower.contains('onerror')) {
      return 'Sunucuya bağlanılamıyor. İnternet bağlantınızı kontrol edin.';
    }

    // Connection hataları
    if (errorLower.contains('connection') || errorLower.contains('network')) {
      return 'Ağ bağlantısı hatası. Lütfen tekrar deneyin.';
    }

    // Timeout hataları
    if (errorLower.contains('timeout')) {
      return 'Bağlantı zaman aşımına uğradı. Tekrar deneyin.';
    }

    // CORS hataları
    if (errorLower.contains('cors') || errorLower.contains('access-control')) {
      return 'Sunucu erişim hatası. Sistem yöneticisine başvurun.';
    }

    // SSL/TLS hataları
    if (errorLower.contains('ssl') ||
        errorLower.contains('tls') ||
        errorLower.contains('certificate')) {
      return 'Güvenlik sertifikası hatası. Sistem yöneticisine başvurun.';
    }

    // Host unreachable
    if (errorLower.contains('host') && errorLower.contains('unreachable')) {
      return 'Sunucuya erişilemiyor. İnternet bağlantınızı kontrol edin.';
    }

    // No route to host
    if (errorLower.contains('no route')) {
      return 'Sunucu adresine ulaşılamıyor. Bağlantınızı kontrol edin.';
    }

    // Connection refused
    if (errorLower.contains('connection refused')) {
      return 'Sunucu bağlantıyı reddetti. Servis geçici olarak kapalı olabilir.';
    }

    // Generic fallback
    return 'Bir hata oluştu. Lütfen tekrar deneyin.';
  }

  /// Backend'den gelen error response'unu parse eder
  String? _extractBackendErrorMessage(dynamic data) {
    if (data == null) return null;

    try {
      // JSON string ise parse et
      if (data is String) {
        data = _tryParseJson(data);
      }

      // Map değilse çevrilemiyor
      if (data is! Map<String, dynamic>) {
        return null;
      }

      // Farklı backend error formatları
      String? message;

      // Standard formats: message, error, detail
      message = data['message'] ?? data['error'] ?? data['detail'];
      if (message != null && message.isNotEmpty) {
        return _mapBackendMessageToUserFriendly(message);
      }

      // Error array format
      if (data['error'] is List && (data['error'] as List).isNotEmpty) {
        return _mapBackendMessageToUserFriendly(
          (data['error'] as List).first.toString(),
        );
      }

      // Laravel validation errors
      if (data['errors'] is Map<String, dynamic>) {
        final errors = data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.firstOrNull;
        if (firstError is List && firstError.isNotEmpty) {
          return _mapBackendMessageToUserFriendly(firstError.first.toString());
        }
        if (firstError is String && firstError.isNotEmpty) {
          return _mapBackendMessageToUserFriendly(firstError);
        }
      }

      // Spring Boot format
      if (data['status'] != null && data['message'] != null) {
        return _mapBackendMessageToUserFriendly(data['message']);
      }

      // Express.js format
      if (data['msg'] != null) {
        return _mapBackendMessageToUserFriendly(data['msg']);
      }

      // ASP.NET Core format
      if (data['title'] != null) {
        return _mapBackendMessageToUserFriendly(data['title']);
      }
    } catch (e) {
      // Parse error, return null to fallback
      return null;
    }

    return null;
  }

  /// JSON string'i parse etmeye çalışır
  dynamic _tryParseJson(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      return jsonString;
    }
  }

  /// Backend mesajlarını kullanıcı dostu mesajlara çevirir
  String _mapBackendMessageToUserFriendly(String backendMessage) {
    final message = backendMessage.toLowerCase().trim();

    // Server/Database errors (en önce kontrol et)
    if (message.contains('internal server error') ||
        message.contains('server error') ||
        message.contains('database') ||
        message.contains('connection') ||
        message.contains('please try again later') ||
        message.contains('service unavailable') ||
        message.contains('sunucu hatası')) {
      return 'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.';
    }

    // Specific authentication errors
    if (message.contains('invalid credentials') ||
        message.contains('invalid username or password') ||
        message.contains('wrong password') ||
        message.contains('incorrect password') ||
        message.contains('authentication failed') ||
        message.contains('bad credentials') ||
        message.contains('kullanıcı adı veya şifre hatalı') ||
        message.contains('geçersiz kimlik bilgileri')) {
      return 'Kullanıcı adı veya şifre hatalı. Lütfen kontrol ediniz.';
    }

    // Generic login errors (sadece çok spesifik olanlar)
    if (message.contains('login failed') || message.contains('giriş hatası')) {
      return 'Kullanıcı adı veya şifre hatalı. Lütfen kontrol ediniz.';
    }

    // User not found
    if (message.contains('user not found') ||
        message.contains('kullanıcı bulunamadı') ||
        message.contains('account not found')) {
      return 'Kullanıcı bulunamadı. Kullanıcı adınızı kontrol ediniz.';
    }

    // Account disabled/locked
    if (message.contains('account disabled') ||
        message.contains('account locked') ||
        message.contains('account suspended') ||
        message.contains('hesap kilitli') ||
        message.contains('hesap devre dışı')) {
      return 'Hesabınız kilitlenmiş veya devre dışı bırakılmış. Yöneticinize başvurun.';
    }

    // Token errors
    if (message.contains('token expired') ||
        message.contains('token invalid') ||
        message.contains('unauthorized') ||
        message.contains('yetkisiz erişim')) {
      return 'Oturumunuz sona ermiş. Lütfen tekrar giriş yapın.';
    }

    // Validation errors
    if (message.contains('validation failed') ||
        message.contains('invalid input') ||
        message.contains('bad request') ||
        message.contains('geçersiz veri')) {
      return 'Girdiğiniz bilgiler geçersiz. Lütfen kontrol edin.';
    }

    // Permission errors
    if (message.contains('permission denied') ||
        message.contains('access denied') ||
        message.contains('forbidden') ||
        message.contains('yetki yok')) {
      return 'Bu işlem için yetkiniz bulunmuyor.';
    }

    // Server errors
    if (message.contains('internal server error') ||
        message.contains('server error') ||
        message.contains('sunucu hatası')) {
      return 'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.';
    }

    // Network/Connection errors
    if (message.contains('connection error') ||
        message.contains('network error') ||
        message.contains('bağlantı hatası')) {
      return 'Bağlantı hatası oluştu. İnternet bağlantınızı kontrol edin.';
    }

    // Generic error messages (fallback for non-specific errors)
    if (message.contains('an error occurred') ||
        message.contains('something went wrong') ||
        message.contains('unexpected error')) {
      return 'Bir hata oluştu. Lütfen daha sonra tekrar deneyin.';
    }

    // If no match, return original message (cleaned up)
    return backendMessage.length > 100
        ? 'Bir hata oluştu. Lütfen tekrar deneyin.'
        : backendMessage;
  }
}
