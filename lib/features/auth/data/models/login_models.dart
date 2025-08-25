import 'user_model.dart';
import 'auth_tokens_model.dart';

/// Login request model - Updated for NewLdapApi
class LoginRequest {
  final String username; // Changed from email to username per API spec
  final String password;
  final String? platform; // Optional platform field

  const LoginRequest({
    required this.username,
    required this.password,
    this.platform,
  });

  Map<String, dynamic> toJson() {
    final json = {'username': username, 'password': password};
    if (platform != null) {
      json['platform'] = platform!;
    }
    return json;
  }

  @override
  String toString() {
    return 'LoginRequest(username: $username, platform: $platform)';
  }
}

/// Login response model
class LoginResponse {
  final UserModel user;
  final AuthTokensModel tokens;

  const LoginResponse({required this.user, required this.tokens});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json['user'] ?? {}),
      tokens: AuthTokensModel.fromJson(json['tokens'] ?? json),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'tokens': tokens.toJson()};
  }
}

/// Token request model for refresh token endpoint
class TokenRequestDto {
  final String refreshToken;

  const TokenRequestDto({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken};
  }

  factory TokenRequestDto.fromJson(Map<String, dynamic> json) {
    return TokenRequestDto(refreshToken: json['refreshToken']);
  }
}
