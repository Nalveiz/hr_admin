import '../../domain/entities/attendance_record.dart';

/// Attendance record data model for API serialization
class AttendanceRecordModel {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final int? totalMinutes;
  final int? breakMinutes;
  final String status;
  final String? notes;
  final String? location;
  final bool isManualEntry;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AttendanceRecordModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.totalMinutes,
    this.breakMinutes,
    required this.status,
    this.notes,
    this.location,
    required this.isManualEntry,
    this.approvedBy,
    this.approvedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id']?.toString() ?? '',
      employeeId:
          json['employeeId']?.toString() ??
          json['employee_id']?.toString() ??
          '',
      employeeName:
          json['employeeName']?.toString() ??
          json['employee_name']?.toString() ??
          '',
      date: _parseDateTime(json['date']) ?? DateTime.now(),
      checkInTime: _parseDateTime(json['checkInTime'] ?? json['check_in_time']),
      checkOutTime: _parseDateTime(
        json['checkOutTime'] ?? json['check_out_time'],
      ),
      totalMinutes: json['totalMinutes'] ?? json['total_minutes'],
      breakMinutes: json['breakMinutes'] ?? json['break_minutes'],
      status: json['status']?.toString() ?? 'absent',
      notes: json['notes']?.toString(),
      location: json['location']?.toString(),
      isManualEntry: json['isManualEntry'] ?? json['is_manual_entry'] ?? false,
      approvedBy:
          json['approvedBy']?.toString() ?? json['approved_by']?.toString(),
      approvedAt: _parseDateTime(json['approvedAt'] ?? json['approved_at']),
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
      'employeeName': employeeName,
      'date': date.toIso8601String().split('T')[0], // Date only
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'totalMinutes': totalMinutes,
      'breakMinutes': breakMinutes,
      'status': status,
      'notes': notes,
      'location': location,
      'isManualEntry': isManualEntry,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
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

  AttendanceRecord toEntity() {
    return AttendanceRecord(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      date: date,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      totalHours: totalMinutes != null
          ? Duration(minutes: totalMinutes!)
          : null,
      breakDuration: breakMinutes != null
          ? Duration(minutes: breakMinutes!)
          : null,
      status: status,
      notes: notes,
      location: location,
      isManualEntry: isManualEntry,
      approvedBy: approvedBy,
      approvedAt: approvedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static AttendanceRecordModel fromEntity(AttendanceRecord record) {
    return AttendanceRecordModel(
      id: record.id,
      employeeId: record.employeeId,
      employeeName: record.employeeName,
      date: record.date,
      checkInTime: record.checkInTime,
      checkOutTime: record.checkOutTime,
      totalMinutes: record.totalHours?.inMinutes,
      breakMinutes: record.breakDuration?.inMinutes,
      status: record.status,
      notes: record.notes,
      location: record.location,
      isManualEntry: record.isManualEntry,
      approvedBy: record.approvedBy,
      approvedAt: record.approvedAt,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }
}
