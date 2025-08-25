/// DTO for creating a new team
class CreateTeamDto {
  final String name;
  final String departmentId;
  final String? description;
  final String? companyId;
  final String? managerId;

  const CreateTeamDto({
    required this.name,
    required this.departmentId,
    this.description,
    this.companyId,
    this.managerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'departmentId': departmentId,
      if (description != null) 'description': description,
      if (companyId != null) 'companyId': companyId,
      if (managerId != null) 'managerId': managerId,
    };
  }
}

/// DTO for updating a team
class UpdateTeamDto {
  final String? name;
  final String? departmentId;
  final String? description;
  final String? companyId;
  final String? managerId;

  const UpdateTeamDto({
    this.name,
    this.departmentId,
    this.description,
    this.companyId,
    this.managerId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (departmentId != null) 'departmentId': departmentId,
      if (description != null) 'description': description,
      if (companyId != null) 'companyId': companyId,
      if (managerId != null) 'managerId': managerId,
    };
  }
}

/// DTO for team filtering parameters
class TeamFilterParams {
  final String? search;
  final int? page;
  final int? size;
  final String? sortBy;
  final String? sortDirection;

  const TeamFilterParams({
    this.search,
    this.page,
    this.size,
    this.sortBy,
    this.sortDirection,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,
      if (page != null) 'page': page,
      if (size != null) 'size': size,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortDirection != null) 'sortDirection': sortDirection,
    };
  }
}
