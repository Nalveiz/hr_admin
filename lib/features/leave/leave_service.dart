import 'package:hr_admin/core/services/http_service.dart';
import 'package:hr_admin/features/leave/leave_request_model.dart';

class LeaveRequestService {
  final HttpService _httpService;

  LeaveRequestService(this._httpService);

  Future<HttpResponse<List<PermissionRequest>>> getLeaveRequests({
    int? page,
    int? pageSize,
    String? employeeId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};

    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['pageSize'] = pageSize.toString();
    if (employeeId != null && employeeId.isNotEmpty) {
      queryParams['employeeId'] = employeeId;
    }
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String();
    }

    final response = await _httpService.get<List<PermissionRequest>>(
      '/permits',
      queryParameters: queryParams,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => PermissionRequest.fromJson(item)).toList();
        }
        // .NET API pagination response format
        if (json is Map<String, dynamic> && json.containsKey('data')) {
          final List<dynamic> data = json['data'];
          return data.map((item) => PermissionRequest.fromJson(item)).toList();
        }
        throw Exception('Invalid response format for leave requests.');
      },
    );

    return response;
  }

  /// Fetches a single leave request by ID.
  Future<HttpResponse<PermissionRequest>> getLeaveRequestById(String id) async {
    final response = await _httpService.get<PermissionRequest>(
      '/permits/$id', // Specific leave request endpoint
      fromJson: (json) => PermissionRequest.fromJson(json),
    );

    return response;
  }

  /// Creates a new leave request.
  Future<HttpResponse<PermissionRequest>> createLeaveRequest({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    String? notes,
  }) async {
    final body = {
      'employeeId': employeeId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
      if (notes != null) 'notes': notes,
      // Status will likely be set by the backend to 'Pending' by default
    };

    final response = await _httpService.post<PermissionRequest>(
      '/permits', // Endpoint for creating a new leave request
      body: body,
      fromJson: (json) => PermissionRequest.fromJson(json),
    );

    return response;
  }

  /// Updates the status of a specific leave request (e.g., Approve/Reject).
  ///
  /// [status] should be the string representation of the status (e.g., 'Approved', 'Rejected').
  Future<HttpResponse<PermissionRequest>> updateLeaveRequestStatus(
    String id,
    int status, // Expecting int for C# enum index
    String? approverId,
    String? notes,
  ) async {
    final body = {
      'status': status,
      if (approverId != null) 'approverId': approverId,
      if (notes != null) 'notes': notes,
    };

    final response = await _httpService.put<PermissionRequest>(
      '/leave-requests/$id/status', // Endpoint for status update
      body: body,
      fromJson: (json) => PermissionRequest.fromJson(json),
    );

    return response;
  }

  /// Deletes a leave request.
  Future<HttpResponse<void>> deleteLeaveRequest(String id) async {
    final response = await _httpService.delete<void>('/leave-requests/$id');
    return response;
  }
}
