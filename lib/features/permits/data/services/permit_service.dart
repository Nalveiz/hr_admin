import '../../../../core/network/base_http_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../models/permit_model.dart';

/// Permit (Leave Request) service for handling permit operations
class PermitService extends BaseHttpService {
  PermitService(super.prefs);

  /// Get all permits with optional filtering
  Future<ApiResponse<List<PermitModel>>> getPermits([
    PermitFilterParams? params,
  ]) async {
    final queryParams = params?.toQueryParameters() ?? {};

    final response = await get<List<PermitModel>>(
      ApiEndpoints.permits,
      queryParameters: queryParams,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => PermitModel.fromJson(item)).toList();
        }
        return <PermitModel>[];
      },
    );

    return response;
  }

  /// Get permits for current employee
  Future<ApiResponse<List<PermitModel>>> getPermitsByEmployee() async {
    return await get<List<PermitModel>>(
      ApiEndpoints.permitsByEmployee,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => PermitModel.fromJson(item)).toList();
        }
        return <PermitModel>[];
      },
    );
  }

  /// Get permits by status
  Future<ApiResponse<List<PermitModel>>> getPermitsByStatus(
    String status,
  ) async {
    return await get<List<PermitModel>>(
      ApiEndpoints.permitsByStatus,
      queryParameters: {'status': status},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => PermitModel.fromJson(item)).toList();
        }
        return <PermitModel>[];
      },
    );
  }

  /// Create a new permit
  Future<ApiResponse<PermitModel>> createPermit(
    CreateLeaveRequestDto dto,
  ) async {
    return await post<PermitModel>(
      ApiEndpoints.permits,
      data: dto.toJson(),
      fromJson: (json) => PermitModel.fromJson(json),
    );
  }

  /// Approve/Reject permit
  Future<ApiResponse<PermitModel>> updatePermit(
    String permitId,
    ApproveLeaveRequestDto dto,
  ) async {
    return await put<PermitModel>(
      ApiEndpoints.permits,
      queryParameters: {'permitId': permitId},
      data: dto.toJson(),
      fromJson: (json) => PermitModel.fromJson(json),
    );
  }

  /// Delete permit
  Future<ApiResponse<void>> deletePermit(String permitId) async {
    return await delete<void>(
      ApiEndpoints.permitDelete,
      queryParameters: {'permitId': permitId},
    );
  }
}
