import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/base_http_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/services/error_handling_service.dart';
import '../models/leave_model_new.dart';

/// Leave service for handling leave operations - NewLdapApi
class LeaveServiceNew extends BaseHttpService {
  LeaveServiceNew(SharedPreferences prefs, ErrorHandlingService errorHandler)
    : super(prefs, errorHandler);

  /// Get all leaves with optional filtering
  Future<ApiResponse<List<LeaveModel>>> getLeaves([
    LeaveFilterParams? params,
  ]) async {
    final queryParams = params?.toQueryParameters() ?? {};

    final response = await get<List<LeaveModel>>(
      ApiEndpoints.leaves,
      queryParameters: queryParams,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => LeaveModel.fromJson(item)).toList();
        }
        return <LeaveModel>[];
      },
    );

    return response;
  }

  /// Get leave by ID
  Future<ApiResponse<LeaveModel>> getLeaveById(String id) async {
    return await get<LeaveModel>(
      ApiEndpoints.leaveById(id),
      fromJson: (json) => LeaveModel.fromJson(json),
    );
  }

  /// Get leave history by ID
  Future<ApiResponse<List<Map<String, dynamic>>>> getLeaveHistory(
    String id,
  ) async {
    return await get<List<Map<String, dynamic>>>(
      ApiEndpoints.leaveHistory(id),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => item as Map<String, dynamic>).toList();
        }
        return <Map<String, dynamic>>[];
      },
    );
  }

  /// Get leaves by owner ID
  Future<ApiResponse<List<LeaveModel>>> getLeavesByOwner(String ownerId) async {
    return await get<List<LeaveModel>>(
      ApiEndpoints.leavesByOwner(ownerId),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => LeaveModel.fromJson(item)).toList();
        }
        return <LeaveModel>[];
      },
    );
  }

  /// Get leaves by status
  Future<ApiResponse<List<LeaveModel>>> getLeavesByStatus(
    LeaveStatus status,
  ) async {
    return await get<List<LeaveModel>>(
      ApiEndpoints.leavesByStatus(status.value.toString()),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => LeaveModel.fromJson(item)).toList();
        }
        return <LeaveModel>[];
      },
    );
  }

  /// Get pending approvals
  Future<ApiResponse<List<LeaveModel>>> getPendingApprovals() async {
    return await get<List<LeaveModel>>(
      ApiEndpoints.pendingApprovals,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => LeaveModel.fromJson(item)).toList();
        }
        return <LeaveModel>[];
      },
    );
  }

  /// Get leaves by company
  Future<ApiResponse<List<LeaveModel>>> getLeavesByCompany(
    String companyId,
  ) async {
    return await get<List<LeaveModel>>(
      ApiEndpoints.leavesByCompany(companyId),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => LeaveModel.fromJson(item)).toList();
        }
        return <LeaveModel>[];
      },
    );
  }

  /// Create a new leave
  Future<ApiResponse<LeaveModel>> createLeave(CreateLeaveDto dto) async {
    return await post<LeaveModel>(
      ApiEndpoints.leaves,
      data: dto.toJson(),
      fromJson: (json) => LeaveModel.fromJson(json),
    );
  }

  /// Update leave
  Future<ApiResponse<LeaveModel>> updateLeave(
    String id,
    UpdateLeaveDto dto,
  ) async {
    return await put<LeaveModel>(
      ApiEndpoints.leaveById(id),
      data: dto.toJson(),
      fromJson: (json) => LeaveModel.fromJson(json),
    );
  }

  /// Update leave status
  Future<ApiResponse<void>> updateLeaveStatus(
    String id,
    LeaveStatusUpdateDto dto,
  ) async {
    return await put<void>(
      ApiEndpoints.updateLeaveStatus(id),
      data: dto.toJson(),
    );
  }

  /// Delete leave
  Future<ApiResponse<void>> deleteLeave(String id) async {
    return await delete<void>(ApiEndpoints.leaveById(id));
  }

  /// Validate leave period
  Future<ApiResponse<Map<String, dynamic>>> validateLeavePeriod(
    ValidateLeavePeriodDto dto,
  ) async {
    return await post<Map<String, dynamic>>(
      ApiEndpoints.validateLeavePeriod,
      data: dto.toJson(),
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }
}
