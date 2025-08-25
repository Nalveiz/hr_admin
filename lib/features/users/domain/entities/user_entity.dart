import 'package:equatable/equatable.dart';

/// User domain entity
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String surname;
  final String email;
  final UserRoleEntity role;
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

  const UserEntity({
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

  @override
  List<Object?> get props => [
    id,
    name,
    surname,
    email,
    role,
    companyId,
    employmentStartDate,
    phone,
    address,
    note,
    managerId,
    departmentIds,
    teamIds,
    createdAt,
    updatedAt,
  ];
}

/// User role domain entity
enum UserRoleEntity {
  personel(0),
  manager(1),
  hr(2),
  superUser(3);

  const UserRoleEntity(this.value);
  final int value;

  static UserRoleEntity fromValue(int value) {
    return UserRoleEntity.values.firstWhere((role) => role.value == value);
  }
}
