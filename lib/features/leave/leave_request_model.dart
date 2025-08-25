
enum PermissionStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

extension PermissionStatusExtension on PermissionStatus {
  String toDisplayString() {
    switch (this) {
      case PermissionStatus.pending:
        return 'Pending Approval';
      case PermissionStatus.approved:
        return 'Approved';
      case PermissionStatus.rejected:
        return 'Rejected';
      case PermissionStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class PermissionRequest {
  final String? id;
  final String? employeeId;
  final String? employeeMail;
  final DateTime? startDate;
  final DateTime? endDate;
  late final String? reason;
  final PermissionStatus? status;
  final DateTime? createdAt;
  final DateTime? approvedAt;
  final String? approverId;
  final String? notes;

  PermissionRequest({
     this.id,
     this.employeeId,
     this.employeeMail,
     this.startDate,
     this.endDate,
     this.reason,
     this.status,
     this.createdAt,
    this.approvedAt,
    this.approverId,
    this.notes,
  });

  factory PermissionRequest.fromJson(Map<String, dynamic> json) {
    return PermissionRequest(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeMail: json['employeeMail'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reason: json['reason'] as String,
      status: _mapStatusToEnum(json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      approvedAt: json['approvedAt'] != null ? DateTime.parse(json['approvedAt'] as String) : null,
      approverId: json['approverId'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeMail': employeeMail,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'reason': reason,
      'status': status?.index,
      'createdAt': createdAt?.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'approverId': approverId,
      'notes': notes,
    };
  }

  static PermissionStatus _mapStatusToEnum(dynamic status) {
    if (status is int) {
      switch (status) {
        case 0:
          return PermissionStatus.pending;
        case 1:
          return PermissionStatus.approved;
        case 2:
          return PermissionStatus.rejected;
        case 3:
          return PermissionStatus.cancelled;
        default:
          return PermissionStatus.pending;
      }
    } else if (status is String) {
      switch (status.toLowerCase()) {
        case 'pending':
          return PermissionStatus.pending;
        case 'approved':
          return PermissionStatus.approved;
        case 'rejected':
          return PermissionStatus.rejected;
        case 'cancelled':
          return PermissionStatus.cancelled;
        default:
          return PermissionStatus.pending;
      }
    }
    return PermissionStatus.pending;
  }
}
