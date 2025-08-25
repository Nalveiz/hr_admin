import '../../domain/entities/user.dart';

/// User data model for API serialization
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phone,
    super.department,
    super.position,
    super.profileImage,
    required super.roles,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName:
          json['fullName']?.toString() ?? json['full_name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      department: json['department']?.toString(),
      position: json['position']?.toString(),
      profileImage:
          json['profileImage']?.toString() ?? json['profile_image']?.toString(),
      roles: _parseRoles(json['roles']),
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      createdAt: _parseDateTime(json['createdAt'] ?? json['created_at']),
      updatedAt: _parseDateTime(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'department': department,
      'position': position,
      'profileImage': profileImage,
      'roles': roles,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static List<String> _parseRoles(dynamic rolesData) {
    if (rolesData is List) {
      return rolesData.map((role) => role.toString()).toList();
    } else if (rolesData is String) {
      return [rolesData];
    }
    return [];
  }

  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime is String) {
      return DateTime.parse(dateTime);
    } else if (dateTime is DateTime) {
      return dateTime;
    }
    return DateTime.now();
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
      phone: phone,
      department: department,
      position: position,
      profileImage: profileImage,
      roles: roles,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static UserModel fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      phone: user.phone,
      department: user.department,
      position: user.position,
      profileImage: user.profileImage,
      roles: user.roles,
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
