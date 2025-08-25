import '../../../../core/network/base_http_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../models/login_models.dart'; // Import updated login models
import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';

/// Authentication service for handling auth operations
class AuthService extends BaseHttpService {
  AuthService(super.prefs);

  /// Login with username and password (Updated for NewLdapApi)
  Future<ApiResponse<LoginResponse>> login({
    required String username, // Changed from email to username
    required String password,
    String? platform, // Added platform parameter
  }) async {
    final loginRequest = LoginRequest(
      username: username, // Changed from email to username
      password: password,
      platform: platform, // Added platform
    );

    final response = await post<LoginResponse>(
      ApiEndpoints.login,
      data: loginRequest.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    // Store tokens if login successful
    if (response.isSuccess && response.data != null) {
      await _storeTokens(response.data!.tokens);
    }

    return response;
  }

  /// Refresh access token (Updated for NewLdapApi)
  Future<ApiResponse<AuthTokensModel>> refreshToken() async {
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) {
      return ApiResponse.error('No refresh token available');
    }

    final tokenRequest = TokenRequestDto(refreshToken: refreshToken);

    final response = await post<AuthTokensModel>(
      ApiEndpoints.refreshToken,
      data: tokenRequest.toJson(), // Use TokenRequestDto
      fromJson: (json) => AuthTokensModel.fromJson(json),
    );

    // Store new tokens if refresh successful
    if (response.isSuccess && response.data != null) {
      await _storeTokens(response.data!);
    }

    return response;
  }

  /// Get current user profile
  Future<ApiResponse<UserModel>> getProfile() async {
    return await get<UserModel>(
      ApiEndpoints.profile,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Update user profile
  Future<ApiResponse<UserModel>> updateProfile({
    required String fullName,
    String? phone,
    String? profileImage,
  }) async {
    return await put<UserModel>(
      ApiEndpoints.profile,
      data: {
        'fullName': fullName,
        'phone': phone,
        'profileImage': profileImage,
      },
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  /// Logout user
  Future<ApiResponse<void>> logout() async {
    final response = await post<void>(ApiEndpoints.logout);

    // Clear stored tokens regardless of response
    await _clearTokens();

    return response;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    final accessToken = prefs.getString('access_token');
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Get stored access token
  String? getAccessToken() {
    return prefs.getString('access_token');
  }

  /// Get stored refresh token
  String? getRefreshToken() {
    return prefs.getString('refresh_token');
  }

  /// Store authentication tokens
  Future<void> _storeTokens(AuthTokensModel tokens) async {
    await prefs.setString('access_token', tokens.accessToken);
    await prefs.setString('refresh_token', tokens.refreshToken);
    await prefs.setString('token_type', tokens.tokenType);
    await prefs.setInt('expires_in', tokens.expiresIn);
    await prefs.setString('expires_at', tokens.expiresAt.toIso8601String());
  }

  /// Clear stored tokens
  Future<void> _clearTokens() async {
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('token_type');
    await prefs.remove('expires_in');
    await prefs.remove('expires_at');
    await prefs.remove('user_data');
  }

  /// Store user data
  Future<void> storeUserData(UserModel user) async {
    await prefs.setString('user_data', user.toJson().toString());
  }

  /// Check if token is expired
  bool isTokenExpired() {
    final expiresAtString = prefs.getString('expires_at');
    if (expiresAtString == null) return true;

    try {
      final expiresAt = DateTime.parse(expiresAtString);
      return DateTime.now().isAfter(expiresAt);
    } catch (e) {
      return true;
    }
  }

  /// Check if token is near expiry (within 5 minutes)
  bool isTokenNearExpiry() {
    final expiresAtString = prefs.getString('expires_at');
    if (expiresAtString == null) return true;

    try {
      final expiresAt = DateTime.parse(expiresAtString);
      final nearExpiryTime = expiresAt.subtract(const Duration(minutes: 5));
      return DateTime.now().isAfter(nearExpiryTime);
    } catch (e) {
      return true;
    }
  }
}
