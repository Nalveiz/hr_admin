import '../../../../core/network/base_http_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../models/department_model_new.dart';

/// Department service for handling department operations
class DepartmentServiceNew extends BaseHttpService {
  DepartmentServiceNew(super.prefs, super.errorHandlingService);

  /// Get all departments with optional filtering
  Future<ApiResponse<List<DepartmentModel>>> getDepartments([
    DepartmentFilterParams? params,
  ]) async {
    final queryParams = params?.toQueryParameters() ?? {};

    final response = await get<List<DepartmentModel>>(
      ApiEndpoints.departments,
      queryParameters: queryParams,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => DepartmentModel.fromJson(item)).toList();
        }
        return <DepartmentModel>[];
      },
    );

    return response;
  }

  /// Get department by ID
  Future<ApiResponse<DepartmentModel>> getDepartmentById(String id) async {
    return await get<DepartmentModel>(
      ApiEndpoints.departmentById(id),
      fromJson: (json) => DepartmentModel.fromJson(json),
    );
  }

  /// Get department details by ID
  Future<ApiResponse<Map<String, dynamic>>> getDepartmentDetails(
    String id,
  ) async {
    return await get<Map<String, dynamic>>(
      ApiEndpoints.departmentDetails(id),
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Get all departments (simple list)
  Future<ApiResponse<List<DepartmentModel>>> getAllDepartments() async {
    return await get<List<DepartmentModel>>(
      ApiEndpoints.departmentsAll,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => DepartmentModel.fromJson(item)).toList();
        }
        return <DepartmentModel>[];
      },
    );
  }

  /// Get paged departments
  Future<ApiResponse<Map<String, dynamic>>> getPagedDepartments([
    DepartmentFilterParams? params,
  ]) async {
    final queryParams = params?.toQueryParameters() ?? {};

    return await get<Map<String, dynamic>>(
      ApiEndpoints.departmentsPaged,
      queryParameters: queryParams,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Search departments by name
  Future<ApiResponse<List<DepartmentModel>>> searchDepartments(
    String name,
  ) async {
    return await get<List<DepartmentModel>>(
      ApiEndpoints.departmentSearch,
      queryParameters: {'name': name},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => DepartmentModel.fromJson(item)).toList();
        }
        return <DepartmentModel>[];
      },
    );
  }

  /// Create a new department
  Future<ApiResponse<DepartmentModel>> createDepartment(
    CreateDepartmentDto dto,
  ) async {
    return await post<DepartmentModel>(
      ApiEndpoints.departments,
      data: dto.toJson(),
      fromJson: (json) => DepartmentModel.fromJson(json),
    );
  }

  /// Update department
  Future<ApiResponse<DepartmentModel>> updateDepartment(
    String id,
    UpdateDepartmentDto dto,
  ) async {
    return await put<DepartmentModel>(
      ApiEndpoints.departmentById(id),
      data: dto.toJson(),
      fromJson: (json) => DepartmentModel.fromJson(json),
    );
  }

  /// Delete department
  Future<ApiResponse<void>> deleteDepartment(String id) async {
    return await delete<void>(ApiEndpoints.departmentById(id));
  }
}
