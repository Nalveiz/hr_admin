import 'package:hr_admin/core/services/http_service.dart';

/// Authentication için DTO modelleri
class LoginRequest {
  final String Username;
  final String Password;
  final bool rememberMe;

  LoginRequest({
    required this.Username,
    required this.Password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'Username': Username,
      'Password': Password,
      'RememberMe': rememberMe,
    };
  }
}

class LoginResponse {
  final String token;
  final String refreshToken;
  final UserInfo user;
  final DateTime expiresAt;

  LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: UserInfo.fromJson(json['user'] ?? json),
      expiresAt: DateTime.parse(
        json['expiresAt'] ?? json['expiry'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class UserInfo {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final List<String> permissions;

  UserInfo({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.permissions = const [],
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? json['name']?.split(' ')[0] ?? '',
      lastName:
          json['lastName'] ?? json['name']?.split(' ').skip(1).join(' ') ?? '',
      role: json['role'] ?? 'user',
      permissions:
          (json['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'permissions': permissions,
    };
  }

  String get fullName => '$firstName $lastName'.trim();
}

/// Authentication API işlemleri için service
class AuthService {
  final HttpService _httpService;

  AuthService(this._httpService);

  /// Login işlemi
  Future<HttpResponse<LoginResponse>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final request = LoginRequest(
      Username: email,
      Password: password,
      rememberMe: rememberMe,
    );

    final response = await _httpService.post<LoginResponse>(
      '/auth/login-admin',
      body: request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    // Başarılı login'de token'ı kaydet
    if (response.isSuccess && response.data != null) {
      await _httpService.saveToken(response.data!.token);
    }

    return response;
  }

  /// Logout işlemi
  Future<HttpResponse<void>> logout() async {
    final response = await _httpService.post<void>('/auth/logout');

    // Token'ı temizle
    await _httpService.clearToken();

    return response;
  }

  /// Token'ı yenile
  Future<HttpResponse<LoginResponse>> refreshToken(String refreshToken) async {
    final body = {'refreshToken': refreshToken};

    final response = await _httpService.post<LoginResponse>(
      '/auth/refresh',
      body: body,
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    // Başarılı refresh'de yeni token'ı kaydet
    if (response.isSuccess && response.data != null) {
      await _httpService.saveToken(response.data!.token);
    }

    return response;
  }

  /// Mevcut kullanıcı bilgilerini getirir
  Future<HttpResponse<UserInfo>> getCurrentUser() async {
    final response = await _httpService.get<UserInfo>(
      '/auth/me',
      fromJson: (json) => UserInfo.fromJson(json),
    );

    return response;
  }

  /// Şifre değiştirme
  Future<HttpResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final body = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };

    final response = await _httpService.post<void>(
      '/auth/change-password',
      body: body,
    );

    return response;
  }

  /// Şifre sıfırlama isteği
  Future<HttpResponse<void>> forgotPassword(String email) async {
    final body = {'email': email};

    final response = await _httpService.post<void>(
      '/auth/forgot-password',
      body: body,
    );

    return response;
  }

  /// Şifre sıfırlama (token ile)
  Future<HttpResponse<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final body = {'token': token, 'newPassword': newPassword};

    final response = await _httpService.post<void>(
      '/auth/reset-password',
      body: body,
    );

    return response;
  }

  /// Token geçerliliğini kontrol eder
  Future<HttpResponse<bool>> validateToken() async {
    final response = await _httpService.get<bool>(
      '/auth/validate',
      fromJson: (json) {
        if (json is bool) return json;
        if (json is Map<String, dynamic>) {
          return json['isValid'] ?? false;
        }
        return false;
      },
    );

    return response;
  }

  /// Email doğrulama
  Future<HttpResponse<void>> verifyEmail(String token) async {
    final body = {'token': token};

    final response = await _httpService.post<void>(
      '/auth/verify-email',
      body: body,
    );

    return response;
  }

  /// Email doğrulama kodu gönderme
  Future<HttpResponse<void>> resendVerificationEmail() async {
    final response = await _httpService.post<void>('/auth/resend-verification');
    return response;
  }

  /// 2FA (Two-Factor Authentication) aktifleştirme
  Future<HttpResponse<Map<String, dynamic>>> enable2FA() async {
    final response = await _httpService.post<Map<String, dynamic>>(
      '/auth/enable-2fa',
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return response;
  }

  /// 2FA doğrulama
  Future<HttpResponse<void>> verify2FA(String code) async {
    final body = {'code': code};

    final response = await _httpService.post<void>(
      '/auth/verify-2fa',
      body: body,
    );

    return response;
  }

  /// 2FA deaktifleştirme
  Future<HttpResponse<void>> disable2FA(String password) async {
    final body = {'password': password};

    final response = await _httpService.post<void>(
      '/auth/disable-2fa',
      body: body,
    );

    return response;
  }

  /// Aktif oturumları listele
  Future<HttpResponse<List<Map<String, dynamic>>>> getActiveSessions() async {
    final response = await _httpService.get<List<Map<String, dynamic>>>(
      '/auth/sessions',
      fromJson: (json) {
        if (json is List) {
          return json.cast<Map<String, dynamic>>();
        }
        return <Map<String, dynamic>>[];
      },
    );

    return response;
  }

  /// Belirli bir oturumu sonlandır
  Future<HttpResponse<void>> terminateSession(String sessionId) async {
    final response = await _httpService.delete<void>(
      '/auth/sessions/$sessionId',
    );
    return response;
  }

  /// Tüm diğer oturumları sonlandır
  Future<HttpResponse<void>> terminateAllOtherSessions() async {
    final response = await _httpService.post<void>(
      '/auth/terminate-all-sessions',
    );
    return response;
  }
}
