/// Create leave request DTO for permits endpoint
class CreateLeaveRequestDto {
  final String id;
  final String employeeId;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;

  const CreateLeaveRequestDto({
    required this.id,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
    };
  }

  factory CreateLeaveRequestDto.fromJson(Map<String, dynamic> json) {
    return CreateLeaveRequestDto(
      id: json['id'],
      employeeId: json['employeeId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reason: json['reason'],
    );
  }
}

/// Approve leave request DTO
class ApproveLeaveRequestDto {
  final String id;
  final String status;
  final String approverId;
  final String? notes;

  const ApproveLeaveRequestDto({
    required this.id,
    required this.status,
    required this.approverId,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'status': status,
      'approverId': approverId,
    };

    if (notes != null) json['notes'] = notes;
    return json;
  }

  factory ApproveLeaveRequestDto.fromJson(Map<String, dynamic> json) {
    return ApproveLeaveRequestDto(
      id: json['id'],
      status: json['status'],
      approverId: json['approverId'],
      notes: json['notes'],
    );
  }
}

/// Leave request filter parameters for permits
class PermitFilterParams {
  final String? employeeId;
  final String? reason;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const PermitFilterParams({
    this.employeeId,
    this.reason,
    this.status,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (employeeId != null) params['EmployeeId'] = employeeId;
    if (reason != null) params['Reason'] = reason;
    if (status != null) params['Status'] = status;
    if (startDate != null) params['StartDate'] = startDate!.toIso8601String();
    if (endDate != null) params['EndDate'] = endDate!.toIso8601String();
    return params;
  }
}

/// Leave request model for permits
class PermitModel {
  final String id;
  final String employeeId;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final String? approverId;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PermitModel({
    required this.id,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.approverId,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory PermitModel.fromJson(Map<String, dynamic> json) {
    return PermitModel(
      id: json['id'],
      employeeId: json['employeeId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reason: json['reason'],
      status: json['status'],
      approverId: json['approverId'],
      notes: json['notes'],
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
      'employeeId': employeeId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
      'status': status,
      'approverId': approverId,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
