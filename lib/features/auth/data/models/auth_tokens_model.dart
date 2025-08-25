import '../../domain/entities/auth_tokens.dart';

/// Authentication tokens data model for API serialization
class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
    required super.expiresAt,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'] ?? json['expiresIn'] ?? 3600;
    final expiresAt = json['expires_at'] != null
        ? DateTime.parse(json['expires_at'])
        : DateTime.now().add(Duration(seconds: expiresIn));

    return AuthTokensModel(
      accessToken: json['access_token'] ?? json['accessToken'] ?? '',
      refreshToken: json['refresh_token'] ?? json['refreshToken'] ?? '',
      tokenType: json['token_type'] ?? json['tokenType'] ?? 'Bearer',
      expiresIn: expiresIn,
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      expiresAt: expiresAt,
    );
  }

  static AuthTokensModel fromEntity(AuthTokens tokens) {
    return AuthTokensModel(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      tokenType: tokens.tokenType,
      expiresIn: tokens.expiresIn,
      expiresAt: tokens.expiresAt,
    );
  }
}
