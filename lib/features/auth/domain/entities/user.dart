/// User entity class
class User {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? department;
  final String? position;
  final String? profileImage;
  final List<String> roles;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.department,
    this.position,
    this.profileImage,
    required this.roles,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? department,
    String? position,
    String? profileImage,
    List<String>? roles,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      position: position ?? this.position,
      profileImage: profileImage ?? this.profileImage,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.email == email &&
        other.fullName == fullName;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ fullName.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, fullName: $fullName)';
  }
}
