import '../../domain/entities/department.dart';

/// Department data model for API serialization
class DepartmentModel {
  final String id;
  final String name;
  final String? description;
  final String? managerId;
  final String? managerName;
  final int employeeCount;
  final String? budget;
  final bool isActive;
  final String? companyId;
  final String? companyName;
  final int teamCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const DepartmentModel({
    required this.id,
    required this.name,
    this.description,
    this.managerId,
    this.managerName,
    required this.employeeCount,
    this.budget,
    required this.isActive,
    this.companyId,
    this.companyName,
    this.teamCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      managerId:
          json['managerId']?.toString() ?? json['manager_id']?.toString(),
      managerName:
          json['managerName']?.toString() ?? json['manager_name']?.toString(),
      employeeCount:
          json['userCount'] ??
          json['employeeCount'] ??
          json['employee_count'] ??
          0,
      budget: json['budget']?.toString(),
      isActive:
          json['isActive'] ??
          json['is_active'] ??
          true, // Default true since API doesn't return this
      companyId: json['companyId']?.toString(),
      companyName: json['companyName']?.toString(),
      teamCount: json['teamCount'] ?? 0,
      createdAt:
          _parseDateTime(json['createdAt'] ?? json['created_at']) ??
          DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'managerId': managerId,
      'managerName': managerName,
      'userCount': employeeCount, // API bekledği field name
      'budget': budget,
      'isActive': isActive,
      'companyId': companyId,
      'companyName': companyName,
      'teamCount': teamCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return null;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return null;
      }
    } else if (dateTime is DateTime) {
      return dateTime;
    }
    return null;
  }

  Department toEntity() {
    return Department(
      id: id,
      name: name,
      description: description,
      managerId: managerId,
      managerName: managerName,
      employeeCount: employeeCount,
      budget: budget,
      isActive: isActive,
      companyId: companyId,
      companyName: companyName,
      teamCount: teamCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DepartmentModel fromEntity(Department department) {
    return DepartmentModel(
      id: department.id,
      name: department.name,
      description: department.description,
      managerId: department.managerId,
      managerName: department.managerName,
      employeeCount: department.employeeCount,
      budget: department.budget,
      isActive: department.isActive,
      companyId: department.companyId,
      companyName: department.companyName,
      teamCount: department.teamCount,
      createdAt: department.createdAt,
      updatedAt: department.updatedAt,
    );
  }
}
