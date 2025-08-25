import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/base_http_service.dart';

/// Service for reports-related API operations
class ReportsService extends BaseHttpService {
  ReportsService(super.prefs);

  /// Get user summary report
  Future<ApiResponse<Map<String, dynamic>>> getUserSummaryReport({
    String? departmentId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (departmentId != null) queryParams['departmentId'] = departmentId;
      if (status != null) queryParams['status'] = status;
      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      if (endDate != null)
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];

      final response = await dio.get(
        '${ApiEndpoints.reports}/user-summary',
        queryParameters: queryParams,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message:
            response.data['message'] ??
            'User summary report fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch user summary report');
    }
  }

  /// Get attendance summary report
  Future<ApiResponse<Map<String, dynamic>>> getAttendanceSummaryReport({
    String? employeeId,
    String? departmentId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      };
      if (employeeId != null) queryParams['employeeId'] = employeeId;
      if (departmentId != null) queryParams['departmentId'] = departmentId;

      final response = await dio.get(
        '${ApiEndpoints.reports}/attendance-summary',
        queryParameters: queryParams,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message:
            response.data['message'] ??
            'Attendance summary report fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch attendance summary report');
    }
  }

  /// Get leave summary report
  Future<ApiResponse<Map<String, dynamic>>> getLeaveSummaryReport({
    String? employeeId,
    String? departmentId,
    String? leaveType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      };
      if (employeeId != null) queryParams['employeeId'] = employeeId;
      if (departmentId != null) queryParams['departmentId'] = departmentId;
      if (leaveType != null) queryParams['leaveType'] = leaveType;

      final response = await dio.get(
        '${ApiEndpoints.reports}/leave-summary',
        queryParameters: queryParams,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message:
            response.data['message'] ??
            'Leave summary report fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch leave summary report');
    }
  }

  /// Get payroll summary report
  Future<ApiResponse<Map<String, dynamic>>> getPayrollSummaryReport({
    String? departmentId,
    required String payPeriod,
  }) async {
    try {
      final queryParams = <String, dynamic>{'payPeriod': payPeriod};
      if (departmentId != null) queryParams['departmentId'] = departmentId;

      final response = await dio.get(
        '${ApiEndpoints.reports}/payroll-summary',
        queryParameters: queryParams,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message:
            response.data['message'] ??
            'Payroll summary report fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch payroll summary report');
    }
  }

  /// Get performance summary report
  Future<ApiResponse<Map<String, dynamic>>> getPerformanceSummaryReport({
    String? departmentId,
    String? reviewType,
    String? reviewPeriod,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (departmentId != null) queryParams['departmentId'] = departmentId;
      if (reviewType != null) queryParams['reviewType'] = reviewType;
      if (reviewPeriod != null) queryParams['reviewPeriod'] = reviewPeriod;

      final response = await dio.get(
        '${ApiEndpoints.reports}/performance-summary',
        queryParameters: queryParams,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message:
            response.data['message'] ??
            'Performance summary report fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch performance summary report');
    }
  }

  /// Get department analytics
  Future<ApiResponse<Map<String, dynamic>>> getDepartmentAnalytics({
    String? departmentId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (departmentId != null) queryParams['departmentId'] = departmentId;
      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      if (endDate != null)
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];

      final response = await dio.get(
        '${ApiEndpoints.reports}/department-analytics',
        queryParameters: queryParams,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message:
            response.data['message'] ??
            'Department analytics fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch department analytics');
    }
  }

  /// Get headcount report
  Future<ApiResponse<Map<String, dynamic>>> getHeadcountReport({
    String? departmentId,
    DateTime? asOfDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (departmentId != null) queryParams['departmentId'] = departmentId;
      if (asOfDate != null)
        queryParams['asOfDate'] = asOfDate.toIso8601String().split('T')[0];

      final response = await dio.get(
        '${ApiEndpoints.reports}/headcount',
        queryParameters: queryParams,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message:
            response.data['message'] ?? 'Headcount report fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch headcount report');
    }
  }

  /// Get turnover report
  Future<ApiResponse<Map<String, dynamic>>> getTurnoverReport({
    String? departmentId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      };
      if (departmentId != null) queryParams['departmentId'] = departmentId;

      final response = await dio.get(
        '${ApiEndpoints.reports}/turnover',
        queryParameters: queryParams,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message:
            response.data['message'] ?? 'Turnover report fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch turnover report');
    }
  }

  /// Export report to file
  Future<ApiResponse<Map<String, dynamic>>> exportReport({
    required String reportType,
    required String format, // 'csv', 'excel', 'pdf'
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final requestData = {
        'reportType': reportType,
        'format': format,
        if (parameters != null) ...parameters,
      };

      final response = await dio.post(
        '${ApiEndpoints.reports}/export',
        data: requestData,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message: response.data['message'] ?? 'Report exported successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to export report');
    }
  }

  /// Schedule report generation
  Future<ApiResponse<Map<String, dynamic>>> scheduleReport({
    required String reportType,
    required String frequency, // 'daily', 'weekly', 'monthly'
    required List<String> recipients,
    required String format,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final requestData = {
        'reportType': reportType,
        'frequency': frequency,
        'recipients': recipients,
        'format': format,
        if (parameters != null) ...parameters,
      };

      final response = await dio.post(
        '${ApiEndpoints.reports}/schedule',
        data: requestData,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message: response.data['message'] ?? 'Report scheduled successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to schedule report');
    }
  }

  /// Get scheduled reports
  Future<ApiResponse<List<Map<String, dynamic>>>> getScheduledReports() async {
    try {
      final response = await dio.get('${ApiEndpoints.reports}/scheduled');

      final List<dynamic> data = response.data['data'] ?? [];
      final reports = data.map((json) => json as Map<String, dynamic>).toList();

      return ApiResponse.success(
        reports,
        message:
            response.data['message'] ??
            'Scheduled reports fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch scheduled reports');
    }
  }

  /// Delete scheduled report
  Future<ApiResponse<void>> deleteScheduledReport(String id) async {
    try {
      final response = await dio.delete(
        '${ApiEndpoints.reports}/scheduled/$id',
      );

      return ApiResponse.success(
        null,
        message:
            response.data['message'] ?? 'Scheduled report deleted successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to delete scheduled report');
    }
  }

  /// Get custom report data
  Future<ApiResponse<Map<String, dynamic>>> getCustomReportData({
    required Map<String, dynamic> query,
  }) async {
    try {
      final response = await dio.post(
        '${ApiEndpoints.reports}/custom',
        data: query,
      );

      return ApiResponse.success(
        response.data['data'] as Map<String, dynamic>,
        message:
            response.data['message'] ??
            'Custom report data fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch custom report data');
    }
  }
}
