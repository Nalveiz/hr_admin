/// Data Transfer Objects (DTOs) for Department operations
/// These DTOs are used for API communication and form validation

/// DTO for creating a new department
class CreateDepartmentDto {
  final String name;
  final String? description;
  final String? managerId;
  final String? budget;
  final bool isActive;

  const CreateDepartmentDto({
    required this.name,
    this.description,
    this.managerId,
    this.budget,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'managerId': managerId,
      'budget': budget,
      'isActive': isActive,
    };
  }

  factory CreateDepartmentDto.fromJson(Map<String, dynamic> json) {
    return CreateDepartmentDto(
      name: json['name'] ?? '',
      description: json['description'],
      managerId: json['managerId'],
      budget: json['budget'],
      isActive: json['isActive'] ?? true,
    );
  }
}

/// DTO for updating an existing department
class UpdateDepartmentDto {
  final String name;
  final String? description;
  final String? managerId;
  final String? budget;
  final bool? isActive;

  const UpdateDepartmentDto({
    required this.name,
    this.description,
    this.managerId,
    this.budget,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'name': name};

    if (description != null) json['description'] = description;
    if (managerId != null) json['managerId'] = managerId;
    if (budget != null) json['budget'] = budget;
    if (isActive != null) json['isActive'] = isActive;

    return json;
  }

  factory UpdateDepartmentDto.fromJson(Map<String, dynamic> json) {
    return UpdateDepartmentDto(
      name: json['name'] ?? '',
      description: json['description'],
      managerId: json['managerId'],
      budget: json['budget'],
      isActive: json['isActive'],
    );
  }
}

/// DTO for filtering departments
class DepartmentFilterDto {
  final String? search;
  final bool? isActive;
  final int? page;
  final int? limit;
  final String? managerId;

  const DepartmentFilterDto({
    this.search,
    this.isActive,
    this.page,
    this.limit,
    this.managerId,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (isActive != null) params['isActive'] = isActive;
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (managerId != null) params['managerId'] = managerId;

    return params;
  }

  factory DepartmentFilterDto.fromJson(Map<String, dynamic> json) {
    return DepartmentFilterDto(
      search: json['search'],
      isActive: json['isActive'],
      page: json['page'],
      limit: json['limit'],
      managerId: json['managerId'],
    );
  }
}
