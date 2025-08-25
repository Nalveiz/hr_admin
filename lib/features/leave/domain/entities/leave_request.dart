/// Leave request status enum
enum LeaveRequestStatus {
  pending('Pending', 'Bekliyor'),
  approved('Approved', 'Onaylandı'),
  rejected('Rejected', 'Reddedildi'),
  cancelled('Cancelled', 'İptal Edildi');

  const LeaveRequestStatus(this.value, this.label);

  final String value;
  final String label;

  static LeaveRequestStatus fromValue(String value) {
    return LeaveRequestStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LeaveRequestStatus.pending,
    );
  }
}

/// Leave request type enum
enum LeaveRequestType {
  annual('Annual', 'Yıllık İzin'),
  sick('Sick', 'Hastalık İzni'),
  maternity('Maternity', 'Doğum İzni'),
  paternity('Paternity', 'Babalık İzni'),
  personal('Personal', 'Kişisel İzin'),
  unpaid('Unpaid', 'Ücretsiz İzin');

  const LeaveRequestType(this.value, this.label);

  final String value;
  final String label;

  static LeaveRequestType fromValue(String value) {
    return LeaveRequestType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => LeaveRequestType.annual,
    );
  }
}

/// Leave request entity class
class LeaveRequest {
  final String id;
  final String employeeId;
  final String employeeMail;
  final String employeeName;
  final LeaveRequestType type;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String reason;
  final LeaveRequestStatus status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeMail,
    required this.employeeName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  LeaveRequest copyWith({
    String? id,
    String? employeeId,
    String? employeeMail,
    String? employeeName,
    LeaveRequestType? type,
    DateTime? startDate,
    DateTime? endDate,
    int? totalDays,
    String? reason,
    LeaveRequestStatus? status,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectionReason,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeMail: employeeMail ?? this.employeeMail,
      employeeName: employeeName ?? this.employeeName,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LeaveRequest &&
        other.id == id &&
        other.employeeId == employeeId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ employeeId.hashCode;
  }

  @override
  String toString() {
    return 'LeaveRequest(id: $id, employeeMail: $employeeMail, status: ${status.label})';
  }
}
