/// Data Transfer Objects (DTOs) for User operations
/// These DTOs are used for API communication and form validation

import '../../domain/entities/user_entity.dart';

/// DTO for creating a new user
class CreateUserDto {
  final String name;
  final String surname;
  final String email;
  final UserRoleEntity role;
  final DateTime? employmentStartDate;
  final String? phone;
  final String? address;
  final String? signature;
  final String? attachment;
  final String? note;
  final String? managerId;
  final String companyId;
  final List<String> departmentIds;
  final List<String> teamIds;

  const CreateUserDto({
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    required this.companyId,
    this.employmentStartDate,
    this.phone,
    this.address,
    this.signature,
    this.attachment,
    this.note,
    this.managerId,
    this.departmentIds = const [],
    this.teamIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'role': role.value,
      'employmentStartDate': employmentStartDate?.toIso8601String(),
      'phone': phone,
      'address': address,
      'signature': signature,
      'attachment': attachment,
      'note': note,
      'managerId': managerId,
      'companyId': companyId,
      'departmentIds': departmentIds,
      'teamIds': teamIds,
    };
  }

  factory CreateUserDto.fromJson(Map<String, dynamic> json) {
    return CreateUserDto(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      role: UserRoleEntity.fromValue(json['role'] ?? 0),
      companyId: json['companyId'] ?? '',
      employmentStartDate: json['employmentStartDate'] != null
          ? DateTime.parse(json['employmentStartDate'])
          : null,
      phone: json['phone'],
      address: json['address'],
      note: json['note'],
      managerId: json['managerId'],
      departmentIds: List<String>.from(json['departmentIds'] ?? []),
      teamIds: List<String>.from(json['teamIds'] ?? []),
    );
  }
}

/// DTO for updating an existing user
class UpdateUserDto {
  final String? name;
  final String? surname;
  final String? email;
  final UserRoleEntity? role;
  final DateTime? employmentStartDate;
  final String? phone;
  final String? address;
  final String? signature;
  final String? attachment;
  final String? note;
  final String? managerId;
  final String? companyId;
  final List<String>? departmentIds;
  final List<String>? teamIds;

  const UpdateUserDto({
    this.name,
    this.surname,
    this.email,
    this.role,
    this.companyId,
    this.employmentStartDate,
    this.phone,
    this.address,
    this.signature,
    this.attachment,
    this.note,
    this.managerId,
    this.departmentIds,
    this.teamIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name!;
    if (surname != null) json['surname'] = surname!;
    if (email != null) json['email'] = email!;
    if (role != null) json['role'] = role!.value;
    if (companyId != null) json['companyId'] = companyId!;
    if (employmentStartDate != null) {
      json['employmentStartDate'] = employmentStartDate!.toIso8601String();
    }
    if (phone != null) json['phone'] = phone!;
    if (address != null) json['address'] = address!;
    if (signature != null) json['signature'] = signature!;
    if (attachment != null) json['attachment'] = attachment!;
    if (note != null) json['note'] = note!;
    if (managerId != null) json['managerId'] = managerId!;
    if (departmentIds != null) json['departmentIds'] = departmentIds!;
    if (teamIds != null) json['teamIds'] = teamIds!;
    return json;
  }

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) {
    return UpdateUserDto(
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      role: json['role'] != null
          ? UserRoleEntity.fromValue(json['role'])
          : null,
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
    );
  }
}
