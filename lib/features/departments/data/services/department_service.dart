import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/base_http_service.dart';
import '../models/department_model.dart';

/// Service for department-related API operations
class DepartmentService extends BaseHttpService {
  DepartmentService(super.prefs);

  /// Get all departments
  Future<ApiResponse<List<DepartmentModel>>> getDepartments({
    int? page,
    int? limit,
    String? search,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (isActive != null) queryParams['isActive'] = isActive;

      final response = await dio.get(
        ApiEndpoints.departments,
        queryParameters: queryParams,
      );

      // API direkt array döndürüyor, wrapped değil
      final List<dynamic> data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);

      final departments = data
          .map((json) => DepartmentModel.fromJson(json))
          .toList();

      return ApiResponse.success(
        departments,
        message: 'Departments fetched successfully',
      );
    } catch (e) {
      print('Department service error: $e'); // Debug için
      return ApiResponse.error('Failed to fetch departments: ${e.toString()}');
    }
  }

  /// Get department by ID
  Future<ApiResponse<DepartmentModel>> getDepartmentById(String id) async {
    try {
      final response = await dio.get('${ApiEndpoints.departments}/$id');

      final department = DepartmentModel.fromJson(response.data['data']);

      return ApiResponse.success(
        department,
        message: response.data['message'] ?? 'Department fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch department users');
    }
  }

  /// Create new department
  Future<ApiResponse<DepartmentModel>> createDepartment(
    DepartmentModel department,
  ) async {
    try {
      final requestData = department.toJson();
      // Remove ID for creation
      requestData.remove('id');
      requestData.remove('createdAt');
      requestData.remove('updatedAt');

      final response = await dio.post(
        ApiEndpoints.departments,
        data: requestData,
      );

      final createdDepartment = DepartmentModel.fromJson(response.data['data']);

      return ApiResponse.success(
        createdDepartment,
        message: response.data['message'] ?? 'Department created successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to create department');
    }
  }

  /// Update department
  Future<ApiResponse<DepartmentModel>> updateDepartment(
    String id,
    DepartmentModel department,
  ) async {
    try {
      final requestData = department.toJson();
      // Remove read-only fields
      requestData.remove('createdAt');
      requestData.remove('employeeCount');

      final response = await dio.put(
        '${ApiEndpoints.departments}/$id',
        data: requestData,
      );

      final updatedDepartment = DepartmentModel.fromJson(response.data['data']);

      return ApiResponse.success(
        updatedDepartment,
        message: response.data['message'] ?? 'Department updated successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to update department');
    }
  }

  /// Delete department
  Future<ApiResponse<void>> deleteDepartment(String id) async {
    try {
      final response = await dio.delete('${ApiEndpoints.departments}/$id');

      return ApiResponse.success(
        null,
        message: response.data['message'] ?? 'Department deleted successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to delete department');
    }
  }

  /// Get department users
  Future<ApiResponse<List<Map<String, dynamic>>>> getDepartmentUsers(
    String departmentId,
  ) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.departments}/$departmentId/users',
      );

      final List<dynamic> data = response.data['data'] ?? [];
      final users = data.map((json) => json as Map<String, dynamic>).toList();

      return ApiResponse.success(
        users,
        message:
            response.data['message'] ?? 'Department users fetched successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch department users');
    }
  }

  /// Activate/Deactivate department
  Future<ApiResponse<DepartmentModel>> toggleDepartmentStatus(
    String id,
    bool isActive,
  ) async {
    try {
      final response = await dio.patch(
        '${ApiEndpoints.departments}/$id/status',
        data: {'isActive': isActive},
      );

      final department = DepartmentModel.fromJson(response.data['data']);

      return ApiResponse.success(
        department,
        message:
            response.data['message'] ??
            'Department status updated successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to update department status');
    }
  }

  /// Assign manager to department
  Future<ApiResponse<DepartmentModel>> assignManager(
    String departmentId,
    String managerId,
  ) async {
    try {
      final response = await dio.patch(
        '${ApiEndpoints.departments}/$departmentId/manager',
        data: {'managerId': managerId},
      );

      final department = DepartmentModel.fromJson(response.data['data']);

      return ApiResponse.success(
        department,
        message: response.data['message'] ?? 'Manager assigned successfully',
      );
    } catch (e) {
      return ApiResponse.error('Failed to assign manager');
    }
  }

  /// Get departments by company ID
  Future<ApiResponse<List<DepartmentModel>>> getDepartmentsByCompany(
    String companyId,
  ) async {
    try {
      final response = await dio.get(
        ApiEndpoints.departments,
        queryParameters: {'companyId': companyId},
      );

      // API direkt array döndürüyor mu kontrol et
      final List<dynamic> data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);

      final departments = data
          .map((json) => DepartmentModel.fromJson(json))
          .toList();

      return ApiResponse.success(
        departments,
        message: 'Company departments fetched successfully',
      );
    } catch (e) {
      print('Department service error: $e');
      return ApiResponse.error(
        'Failed to fetch company departments: ${e.toString()}',
      );
    }
  }
}
