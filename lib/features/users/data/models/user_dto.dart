import '../../domain/entities/user_role.dart';

class CreateUserDto {
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
  final List<String> departmentIds;
  final List<String> teamIds;

  CreateUserDto({
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
    this.departmentIds = const [],
    this.teamIds = const [],
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "surname": surname,
    "email": email,
    "role": role.value,
    "employmentStartDate": employmentStartDate?.toIso8601String(),
    "phone": phone,
    "address": address,
    "note": note,
    "managerId": managerId,
    "companyId": companyId,
    "departmentIds": departmentIds,
    "teamIds": teamIds,
  };
}

class UpdateUserDto {
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
  final List<String> departmentIds;
  final List<String> teamIds;

  UpdateUserDto({
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
    this.departmentIds = const [],
    this.teamIds = const [],
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "surname": surname,
    "email": email,
    "role": role.value,
    "employmentStartDate": employmentStartDate?.toIso8601String(),
    "phone": phone,
    "address": address,
    "note": note,
    "managerId": managerId,
    "companyId": companyId,
    "departmentIds": departmentIds,
    "teamIds": teamIds,
  };
}

class UserFilterParams {
  final String? searchTerm;
  final String? name;
  final String? email;
  final int? role;
  final String? companyId;
  final int? pageNumber;
  final int? pageSize;

  const UserFilterParams({
    this.searchTerm,
    this.name,
    this.email,
    this.role,
    this.companyId,
    this.pageNumber,
    this.pageSize,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (searchTerm != null) params['searchTerm'] = searchTerm;
    if (name != null) params['Name'] = name;
    if (email != null) params['Email'] = email;
    if (role != null) params['Role'] = role;
    if (companyId != null) params['CompanyId'] = companyId;
    if (pageNumber != null) params['PageNumber'] = pageNumber;
    if (pageSize != null) params['PageSize'] = pageSize;
    return params;
  }
}
