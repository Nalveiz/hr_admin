import '../../domain/entities/leave_request.dart';

/// Leave request data model for API serialization
class LeaveRequestModel {
  final String id;
  final String employeeId;
  final String employeeMail;
  final String employeeName;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String reason;
  final String status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const LeaveRequestModel({
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

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: json['id']?.toString() ?? '',
      employeeId:
          json['employeeId']?.toString() ??
          json['employee_id']?.toString() ??
          '',
      employeeMail:
          json['employeeMail']?.toString() ??
          json['employee_mail']?.toString() ??
          '',
      employeeName:
          json['employeeName']?.toString() ??
          json['employee_name']?.toString() ??
          '',
      type:
          json['type']?.toString() ??
          json['leave_type']?.toString() ??
          'Annual',
      startDate:
          _parseDateTime(json['startDate'] ?? json['start_date']) ??
          DateTime.now(),
      endDate:
          _parseDateTime(json['endDate'] ?? json['end_date']) ?? DateTime.now(),
      totalDays:
          json['totalDays'] ??
          json['total_days'] ??
          _calculateDays(
            _parseDateTime(json['startDate'] ?? json['start_date']),
            _parseDateTime(json['endDate'] ?? json['end_date']),
          ),
      reason: json['reason']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
      approvedBy:
          json['approvedBy']?.toString() ?? json['approved_by']?.toString(),
      approvedAt: _parseDateTime(json['approvedAt'] ?? json['approved_at']),
      rejectionReason:
          json['rejectionReason']?.toString() ??
          json['rejection_reason']?.toString(),
      notes: json['notes']?.toString(),
      createdAt:
          _parseDateTime(json['createdAt'] ?? json['created_at']) ??
          DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeMail': employeeMail,
      'employeeName': employeeName,
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalDays': totalDays,
      'reason': reason,
      'status': status,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'notes': notes,
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

  static int _calculateDays(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 0;
    return end.difference(start).inDays + 1;
  }

  LeaveRequest toEntity() {
    return LeaveRequest(
      id: id,
      employeeId: employeeId,
      employeeMail: employeeMail,
      employeeName: employeeName,
      type: LeaveRequestType.fromValue(type),
      startDate: startDate,
      endDate: endDate,
      totalDays: totalDays,
      reason: reason,
      status: LeaveRequestStatus.fromValue(status),
      approvedBy: approvedBy,
      approvedAt: approvedAt,
      rejectionReason: rejectionReason,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static LeaveRequestModel fromEntity(LeaveRequest leaveRequest) {
    return LeaveRequestModel(
      id: leaveRequest.id,
      employeeId: leaveRequest.employeeId,
      employeeMail: leaveRequest.employeeMail,
      employeeName: leaveRequest.employeeName,
      type: leaveRequest.type.value,
      startDate: leaveRequest.startDate,
      endDate: leaveRequest.endDate,
      totalDays: leaveRequest.totalDays,
      reason: leaveRequest.reason,
      status: leaveRequest.status.value,
      approvedBy: leaveRequest.approvedBy,
      approvedAt: leaveRequest.approvedAt,
      rejectionReason: leaveRequest.rejectionReason,
      notes: leaveRequest.notes,
      createdAt: leaveRequest.createdAt,
      updatedAt: leaveRequest.updatedAt,
    );
  }
}
