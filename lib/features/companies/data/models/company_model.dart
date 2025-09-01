/// Company model for NewLdapApi
class CompanyModel {
  final String id;
  final String name;
  final int userCount;
  final int departmentCount;
  final bool? valid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CompanyModel({
    required this.id,
    required this.name,
    this.userCount = 0,
    this.departmentCount = 0,
    this.valid,
    this.createdAt,
    this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      userCount: json['userCount'] ?? 0,
      departmentCount: json['departmentCount'] ?? 0,
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
      'userCount': userCount,
      'departmentCount': departmentCount,
      'valid': valid,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
