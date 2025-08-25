/// Leave Type enum for NewLdapApi
enum LeaveType {
  annual(0),
  sick(1),
  personal(2),
  maternity(3),
  paternity(4),
  unpaid(5);

  const LeaveType(this.value);
  final int value;

  static LeaveType fromValue(int value) {
    return LeaveType.values.firstWhere((type) => type.value == value);
  }
}

/// Leave Status enum
enum LeaveStatus {
  pending(0),
  approved(1),
  rejected(2),
  cancelled(3);

  const LeaveStatus(this.value);
  final int value;

  static LeaveStatus fromValue(int value) {
    return LeaveStatus.values.firstWhere((status) => status.value == value);
  }
}

/// Create leave DTO
class CreateLeaveDto {
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final String? leaveAddress;
  final String? leavePhone;
  final int? travelLeavePeriod;
  final String? signature;
  final LeaveType type;
  final String? attachment;
  final String? description;

  const CreateLeaveDto({
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.leaveAddress,
    this.leavePhone,
    this.travelLeavePeriod,
    this.signature,
    this.attachment,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'ownerId': ownerId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type.value,
    };

    if (leaveAddress != null) json['leaveAddress'] = leaveAddress;
    if (leavePhone != null) json['leavePhone'] = leavePhone;
    if (travelLeavePeriod != null)
      json['travelLeavePeriod'] = travelLeavePeriod;
    if (signature != null) json['signature'] = signature;
    if (attachment != null) json['attachment'] = attachment;
    if (description != null) json['description'] = description;

    return json;
  }
}

/// Update leave DTO
class UpdateLeaveDto {
  final DateTime startDate;
  final DateTime endDate;
  final String? leaveAddress;
  final String? leavePhone;
  final int? travelLeavePeriod;
  final String? signature;
  final LeaveType type;
  final String? attachment;
  final String? description;

  const UpdateLeaveDto({
    required this.startDate,
    required this.endDate,
    required this.type,
    this.leaveAddress,
    this.leavePhone,
    this.travelLeavePeriod,
    this.signature,
    this.attachment,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type.value,
    };

    if (leaveAddress != null) json['leaveAddress'] = leaveAddress;
    if (leavePhone != null) json['leavePhone'] = leavePhone;
    if (travelLeavePeriod != null)
      json['travelLeavePeriod'] = travelLeavePeriod;
    if (signature != null) json['signature'] = signature;
    if (attachment != null) json['attachment'] = attachment;
    if (description != null) json['description'] = description;

    return json;
  }
}

/// Leave status update DTO
class LeaveStatusUpdateDto {
  final LeaveStatus status;
  final String? note;
  final String approvedBy;

  const LeaveStatusUpdateDto({
    required this.status,
    required this.approvedBy,
    this.note,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'status': status.value,
      'approvedBy': approvedBy,
    };

    if (note != null) json['note'] = note;
    return json;
  }
}

/// Validate leave period DTO
class ValidateLeavePeriodDto {
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final String? excludeId;

  const ValidateLeavePeriodDto({
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    this.excludeId,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'ownerId': ownerId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };

    if (excludeId != null) json['excludeId'] = excludeId;
    return json;
  }
}

/// Leave filter parameters
class LeaveFilterParams {
  final String? ownerId;
  final String? status;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? companyId;
  final int? pageNumber;
  final int? pageSize;

  const LeaveFilterParams({
    this.ownerId,
    this.status,
    this.type,
    this.startDate,
    this.endDate,
    this.companyId,
    this.pageNumber,
    this.pageSize,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (ownerId != null) params['OwnerId'] = ownerId;
    if (status != null) params['Status'] = status;
    if (type != null) params['Type'] = type;
    if (startDate != null) params['StartDate'] = startDate!.toIso8601String();
    if (endDate != null) params['EndDate'] = endDate!.toIso8601String();
    if (companyId != null) params['CompanyId'] = companyId;
    if (pageNumber != null) params['PageNumber'] = pageNumber;
    if (pageSize != null) params['PageSize'] = pageSize;
    return params;
  }
}

/// Leave model
class LeaveModel {
  final String id;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final String? leaveAddress;
  final String? leavePhone;
  final int? travelLeavePeriod;
  final String? signature;
  final LeaveType type;
  final String? attachment;
  final String? description;
  final LeaveStatus status;
  final String? approvedBy;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LeaveModel({
    required this.id,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.status,
    this.leaveAddress,
    this.leavePhone,
    this.travelLeavePeriod,
    this.signature,
    this.attachment,
    this.description,
    this.approvedBy,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'],
      ownerId: json['ownerId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      type: LeaveType.fromValue(json['type']),
      status: LeaveStatus.fromValue(json['status']),
      leaveAddress: json['leaveAddress'],
      leavePhone: json['leavePhone'],
      travelLeavePeriod: json['travelLeavePeriod'],
      signature: json['signature'],
      attachment: json['attachment'],
      description: json['description'],
      approvedBy: json['approvedBy'],
      note: json['note'],
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
      'ownerId': ownerId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type.value,
      'status': status.value,
      'leaveAddress': leaveAddress,
      'leavePhone': leavePhone,
      'travelLeavePeriod': travelLeavePeriod,
      'signature': signature,
      'attachment': attachment,
      'description': description,
      'approvedBy': approvedBy,
      'note': note,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
