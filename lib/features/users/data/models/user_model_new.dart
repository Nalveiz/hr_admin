import '../../domain/entities/user_entity.dart';

/// User Role enum for NewLdapApi
enum UserRole {
  Personel(0),
  Manager(1),
  HR(2),
  SuperUser(3);

  const UserRole(this.value);
  final int value;

  static UserRole fromValue(int value) {
    return UserRole.values.firstWhere((role) => role.value == value);
  }
}

/// User model for NewLdapApi
class UserModelNew {
  final String id;
  final String name;
  final String surname;
  final String email;
  final UserRole role;
  final DateTime? employmentStartDate;
  final String? phone;
  final String? address;
  final String? note;
  final String? managerId;
  final String companyId;
  final List<String>? departmentIds;
  final List<String>? teamIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModelNew({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    required this.companyId,
    this.employmentStartDate,
    this.phone,
    this.address,
    this.note,
    this.managerId,
    this.departmentIds,
    this.teamIds,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$name $surname';

  factory UserModelNew.fromJson(Map<String, dynamic> json) {
    return UserModelNew(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      role: UserRole.fromValue(json['role']),
      companyId: json['companyId'],
      employmentStartDate: json['employmentStartDate'] != null
          ? DateTime.parse(json['employmentStartDate'])
          : null,
      phone: json['phone'],
      address: json['address'],
      note: json['note'],
      managerId: json['managerId'],
      departmentIds: json['departmentIds'] != null
          ? List<String>.from(json['departmentIds'])
          : null,
      teamIds: json['teamIds'] != null
          ? List<String>.from(json['teamIds'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'role': role.value,
      'companyId': companyId,
      'employmentStartDate': employmentStartDate?.toIso8601String(),
      'phone': phone,
      'address': address,
      'note': note,
      'managerId': managerId,
      'departmentIds': departmentIds,
      'teamIds': teamIds,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      surname: surname,
      email: email,
      role: _mapToEntityRole(role),
      companyId: companyId,
      employmentStartDate: employmentStartDate,
      phone: phone,
      address: address,
      note: note,
      managerId: managerId,
      departmentIds: departmentIds,
      teamIds: teamIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert data model role to entity role
  UserRoleEntity _mapToEntityRole(UserRole role) {
    switch (role) {
      case UserRole.Personel:
        return UserRoleEntity.personel;
      case UserRole.Manager:
        return UserRoleEntity.manager;
      case UserRole.HR:
        return UserRoleEntity.hr;
      case UserRole.SuperUser:
        return UserRoleEntity.superUser;
    }
  }
}

/// Create user DTO
class CreateUserDto {
  final String name;
  final String surname;
  final String email;
  final UserRole role;
  final String companyId;
  final DateTime? employmentStartDate;
  final String? phone;
  final String? address;
  final String? note;
  final String? managerId;
  final List<String>? departmentIds;
  final List<String>? teamIds;

  const CreateUserDto({
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    required this.companyId,
    this.employmentStartDate,
    this.phone,
    this.address,
    this.note,
    this.managerId,
    this.departmentIds,
    this.teamIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'surname': surname,
      'email': email,
      'role': role.value,
      'companyId': companyId,
    };

    if (employmentStartDate != null) {
      json['employmentStartDate'] = employmentStartDate!.toIso8601String();
    }
    if (phone != null) json['phone'] = phone;
    if (address != null) json['address'] = address;
    if (note != null) json['note'] = note;
    if (managerId != null) json['managerId'] = managerId;
    if (departmentIds != null) json['departmentIds'] = departmentIds;
    if (teamIds != null) json['teamIds'] = teamIds;

    return json;
  }
}

/// Update user DTO
class UpdateUserDto {
  final String name;
  final String surname;
  final String email;
  final UserRole role;
  final String companyId;
  final DateTime? employmentStartDate;
  final String? phone;
  final String? address;
  final String? note;
  final String? managerId;
  final List<String>? departmentIds;
  final List<String>? teamIds;

  const UpdateUserDto({
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    required this.companyId,
    this.employmentStartDate,
    this.phone,
    this.address,
    this.note,
    this.managerId,
    this.departmentIds,
    this.teamIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'surname': surname,
      'email': email,
      'role': role.value,
      'companyId': companyId,
    };

    if (employmentStartDate != null) {
      json['employmentStartDate'] = employmentStartDate!.toIso8601String();
    }
    if (phone != null) json['phone'] = phone;
    if (address != null) json['address'] = address;
    if (note != null) json['note'] = note;
    if (managerId != null) json['managerId'] = managerId;
    if (departmentIds != null) json['departmentIds'] = departmentIds;
    if (teamIds != null) json['teamIds'] = teamIds;

    return json;
  }
}

/// User filter parameters
class UserFilterParams {
  final String? name;
  final String? email;
  final String? role;
  final String? companyId;
  final int? pageNumber;
  final int? pageSize;

  const UserFilterParams({
    this.name,
    this.email,
    this.role,
    this.companyId,
    this.pageNumber,
    this.pageSize,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (name != null) params['Name'] = name;
    if (email != null) params['Email'] = email;
    if (role != null) params['Role'] = role;
    if (companyId != null) params['CompanyId'] = companyId;
    if (pageNumber != null) params['PageNumber'] = pageNumber;
    if (pageSize != null) params['PageSize'] = pageSize;
    return params;
  }
}
