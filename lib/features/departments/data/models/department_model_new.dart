/// Department model for NewLdapApi
class DepartmentModel {
  final String id;
  final String name;
  final String companyId;
  final bool? valid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DepartmentModel({
    required this.id,
    required this.name,
    required this.companyId,
    this.valid,
    this.createdAt,
    this.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'],
      name: json['name'],
      companyId: json['companyId'],
      valid: json['valid'],
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
      'companyId': companyId,
      'valid': valid,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

/// Create department DTO
class CreateDepartmentDto {
  final String name;
  final String companyId;

  const CreateDepartmentDto({
    required this.name,
    required this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'companyId': companyId,
    };
  }
}

/// Update department DTO
class UpdateDepartmentDto {
  final String name;
  final String companyId;
  final bool? valid;

  const UpdateDepartmentDto({
    required this.name,
    required this.companyId,
    this.valid,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'companyId': companyId,
    };
    if (valid != null) {
      json['valid'] = valid!;
    }
    return json;
  }
}

/// Department filter parameters
class DepartmentFilterParams {
  final String? id;
  final String? name;
  final String? companyId;
  final bool? valid;
  final int? pageNumber;
  final int? pageSize;

  const DepartmentFilterParams({
    this.id,
    this.name,
    this.companyId,
    this.valid,
    this.pageNumber,
    this.pageSize,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (id != null) params['Id'] = id;
    if (name != null) params['Name'] = name;
    if (companyId != null) params['CompanyId'] = companyId;
    if (valid != null) params['Valid'] = valid;
    if (pageNumber != null) params['PageNumber'] = pageNumber;
    if (pageSize != null) params['PageSize'] = pageSize;
    return params;
  }
}
