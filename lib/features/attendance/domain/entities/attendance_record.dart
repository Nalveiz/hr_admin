/// Attendance record entity
class AttendanceRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final Duration? totalHours;
  final Duration? breakDuration;
  final String status; // present, absent, late, partial_day
  final String? notes;
  final String? location;
  final bool isManualEntry;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.totalHours,
    this.breakDuration,
    required this.status,
    this.notes,
    this.location,
    required this.isManualEntry,
    this.approvedBy,
    this.approvedAt,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isPresent => status == 'present';
  bool get isAbsent => status == 'absent';
  bool get isLate => status == 'late';
  bool get isPartialDay => status == 'partial_day';
  bool get isCheckedIn => checkInTime != null;
  bool get isCheckedOut => checkOutTime != null;
  bool get needsApproval => isManualEntry && approvedBy == null;
}
