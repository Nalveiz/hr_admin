/// Department entity class
class Department {
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

  const Department({
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

  Department copyWith({
    String? id,
    String? name,
    String? description,
    String? managerId,
    String? managerName,
    int? employeeCount,
    String? budget,
    bool? isActive,
    String? companyId,
    String? companyName,
    int? teamCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      employeeCount: employeeCount ?? this.employeeCount,
      budget: budget ?? this.budget,
      isActive: isActive ?? this.isActive,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      teamCount: teamCount ?? this.teamCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Department && other.id == id && other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode;
  }

  @override
  String toString() {
    return 'Department(id: $id, name: $name, employeeCount: $employeeCount)';
  }
}
