/// Team model for NewLdapApi
class TeamModel {
  final String id;
  final String name;
  final String departmentId;
  final bool? valid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TeamModel({
    required this.id,
    required this.name,
    required this.departmentId,
    this.valid,
    this.createdAt,
    this.updatedAt,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      name: json['name'],
      departmentId: json['departmentId'],
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
      'departmentId': departmentId,
      'valid': valid,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
