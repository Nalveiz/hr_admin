import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/base_http_service.dart';
import '../models/attendance_record_model.dart';

/// Service for attendance-related API operations
class AttendanceService extends BaseHttpService {
  AttendanceService(super.prefs);

  /// Get attendance records
  Future<ApiResponse<List<AttendanceRecordModel>>> getAttendanceRecords({
    String? employeeId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};
    if (employeeId != null) queryParams['employeeId'] = employeeId;
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
    }
    if (status != null) queryParams['status'] = status;
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;

    return await get<List<AttendanceRecordModel>>(
      ApiEndpoints.attendance,
      queryParameters: queryParams,
      fromJson: (json) {
        final List<dynamic> data = json['data'] ?? [];
        return data
            .map((item) => AttendanceRecordModel.fromJson(item))
            .toList();
      },
    );
  }

  /// Get attendance record by ID
  Future<ApiResponse<AttendanceRecordModel>> getAttendanceById(
    String id,
  ) async {
    return await get<AttendanceRecordModel>(
      ApiEndpoints.attendanceById(id),
      fromJson: (json) => AttendanceRecordModel.fromJson(json['data']),
    );
  }

  /// Check in employee
  Future<ApiResponse<AttendanceRecordModel>> checkIn({
    required String employeeId,
    String? location,
    String? notes,
  }) async {
    return await post<AttendanceRecordModel>(
      ApiEndpoints.attendanceCheckIn,
      data: {
        'employeeId': employeeId,
        'location': location,
        'notes': notes,
        'timestamp': DateTime.now().toIso8601String(),
      },
      fromJson: (json) => AttendanceRecordModel.fromJson(json['data']),
    );
  }

  /// Check out employee
  Future<ApiResponse<AttendanceRecordModel>> checkOut({
    required String employeeId,
    String? location,
    String? notes,
  }) async {
    return await post<AttendanceRecordModel>(
      ApiEndpoints.attendanceCheckOut,
      data: {
        'employeeId': employeeId,
        'location': location,
        'notes': notes,
        'timestamp': DateTime.now().toIso8601String(),
      },
      fromJson: (json) => AttendanceRecordModel.fromJson(json['data']),
    );
  }

  /// Create manual attendance record
  Future<ApiResponse<AttendanceRecordModel>> createManualRecord({
    required String employeeId,
    required DateTime date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    int? breakMinutes,
    String? notes,
    String? location,
  }) async {
    return await post<AttendanceRecordModel>(
      ApiEndpoints.attendanceManual,
      data: {
        'employeeId': employeeId,
        'date': date.toIso8601String().split('T')[0],
        'checkInTime': checkInTime?.toIso8601String(),
        'checkOutTime': checkOutTime?.toIso8601String(),
        'breakMinutes': breakMinutes,
        'notes': notes,
        'location': location,
        'isManualEntry': true,
      },
      fromJson: (json) => AttendanceRecordModel.fromJson(json['data']),
    );
  }

  /// Update attendance record
  Future<ApiResponse<AttendanceRecordModel>> updateAttendance(
    String id,
    AttendanceRecordModel record,
  ) async {
    final requestData = record.toJson();
    requestData.remove('id');
    requestData.remove('createdAt');

    return await put<AttendanceRecordModel>(
      ApiEndpoints.attendanceById(id),
      data: requestData,
      fromJson: (json) => AttendanceRecordModel.fromJson(json['data']),
    );
  }

  /// Delete attendance record
  Future<ApiResponse<void>> deleteAttendance(String id) async {
    return await delete<void>(ApiEndpoints.attendanceById(id));
  }

  /// Approve manual attendance record
  Future<ApiResponse<AttendanceRecordModel>> approveAttendance(
    String id,
  ) async {
    return await patch<AttendanceRecordModel>(
      ApiEndpoints.attendanceApprove(id),
      data: {'approvedAt': DateTime.now().toIso8601String()},
      fromJson: (json) => AttendanceRecordModel.fromJson(json['data']),
    );
  }

  /// Reject manual attendance record
  Future<ApiResponse<void>> rejectAttendance(String id, String reason) async {
    return await patch<void>(
      ApiEndpoints.attendanceReject(id),
      data: {'reason': reason},
    );
  }

  /// Get employee attendance summary
  Future<ApiResponse<Map<String, dynamic>>> getAttendanceSummary({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await get<Map<String, dynamic>>(
      ApiEndpoints.attendanceSummary,
      queryParameters: {
        'employeeId': employeeId,
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      },
      fromJson: (json) => json['data'] as Map<String, dynamic>,
    );
  }

  /// Get department attendance report
  Future<ApiResponse<Map<String, dynamic>>> getDepartmentAttendanceReport({
    required String departmentId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await get<Map<String, dynamic>>(
      ApiEndpoints.attendanceDepartmentReport,
      queryParameters: {
        'departmentId': departmentId,
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      },
      fromJson: (json) => json['data'] as Map<String, dynamic>,
    );
  }
}
