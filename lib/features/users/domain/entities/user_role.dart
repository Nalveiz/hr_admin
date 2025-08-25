enum UserRole {
  personel, // 0
  manager, // 1
  hr, // 2
  superUser, // 3
}

extension UserRoleExtension on UserRole {
  int get value => index;

  String get displayName {
    switch (this) {
      case UserRole.personel:
        return 'Personel';
      case UserRole.manager:
        return 'Manager';
      case UserRole.hr:
        return 'İK';
      case UserRole.superUser:
        return 'Süper Kullanıcı';
    }
  }

  static UserRole fromInt(int value) {
    switch (value) {
      case 0:
        return UserRole.personel;
      case 1:
        return UserRole.manager;
      case 2:
        return UserRole.hr;
      case 3:
        return UserRole.superUser;
      default:
        return UserRole.personel;
    }
  }

  static UserRole? fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'personel':
        return UserRole.personel;
      case 'manager':
        return UserRole.manager;
      case 'hr':
        return UserRole.hr;
      case 'superuser':
        return UserRole.superUser;
      default:
        return null;
    }
  }
}
